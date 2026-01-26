/*
* Created by Connel Asikong on 09/01/2026
*
*/

import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/fee_estimate.dart';

/// Service layer for Bitcoin wallet operations
/// Handles all BDK interactions and key management
class WalletService {
  Wallet? _wallet;
  Blockchain? _blockchain;

  final _storage = const FlutterSecureStorage();

  // Storage keys
  static const String _mnemonicKey = 'mnemonic';
  static const String _descriptorKey = 'descriptor';

  /// Check if wallet already exists
  Future<bool> walletExists() async {
    final mnemonic = await _storage.read(key: _mnemonicKey);
    return mnemonic != null;
  }

  /// Initialize wallet (create new or restore existing)
  Future<void> initWallet() async {
    final existingMnemonic = await _storage.read(key: _mnemonicKey);

    if (existingMnemonic != null) {
      await _restoreWallet(existingMnemonic);
    } else {
      await _createNewWallet();
    }

    await _initBlockchain();
  }

  /// Create a brand new wallet
  Future<void> _createNewWallet() async {
    // Generate new mnemonic (12 words)
    final mnemonic = await Mnemonic.create(WordCount.words12);

    // Save mnemonic securely
    await _storage.write(key: _mnemonicKey, value: mnemonic.asString());

    // Create descriptor for Native SegWit (bc1... addresses)
    final descriptorSecretKey = await DescriptorSecretKey.create(
      network: Network.testnet,
      mnemonic: mnemonic,
    );

    final descriptor = await Descriptor.create(
      descriptor: "wpkh(${descriptorSecretKey.asString()})",
      network: Network.testnet,
    );

    await _storage.write(key: _descriptorKey, value: descriptor.asString());

    // Create wallet instance
    _wallet = await Wallet.create(
      descriptor: descriptor,
      network: Network.testnet,
      databaseConfig: const DatabaseConfig.memory(),
    );
  }

  /// Restore wallet from existing mnemonic
  Future<void> _restoreWallet(String mnemonicString) async {
    final mnemonic = await Mnemonic.fromString(mnemonicString);

    final descriptorSecretKey = await DescriptorSecretKey.create(
      network: Network.testnet,
      mnemonic: mnemonic,
    );

    final descriptor = await Descriptor.create(
      descriptor: "wpkh(${descriptorSecretKey.asString()})",
      network: Network.testnet,
    );

    _wallet = await Wallet.create(
      descriptor: descriptor,
      network: Network.testnet,
      databaseConfig: const DatabaseConfig.memory(),
    );
  }

  /// Initialize blockchain connection
  Future<void> _initBlockchain() async {
    _blockchain = await Blockchain.create(
      config: BlockchainConfig.electrum(
        config: ElectrumConfig(
          url: "ssl://electrum.blockstream.info:60002",
          retry: 5,
          timeout: 5,
          stopGap: BigInt.from(10),
          validateDomain: true,
        ),
      ),
    );
  }

  /// Get a new receiving address
  Future<String> getNewAddress() async {
    if (_wallet == null) throw Exception('Wallet not initialized');

    final addressInfo = await _wallet!.getAddress(
      addressIndex: const AddressIndex.increase(),
    );

    return addressInfo.address.asString();
  }

  /// Get the last used address (for display purposes)
  Future<String> getLastAddress() async {
    if (_wallet == null) throw Exception('Wallet not initialized');

    final addressInfo = await _wallet!.getAddress(
      addressIndex: const AddressIndex.lastUnused(),
    );

    return addressInfo.address.asString();
  }

  /// Sync wallet with blockchain
  Future<void> sync() async {
    if (_wallet == null || _blockchain == null) {
      throw Exception('Wallet or blockchain not initialized');
    }

    await _wallet!.sync(blockchain: _blockchain!);
  }

  /// Get current balance
  Future<Balance> getBalance() async {
    if (_wallet == null) throw Exception('Wallet not initialized');

    return await _wallet!.getBalance();
  }

  /// Get mnemonic (backup phrase)
  Future<String?> getMnemonic() async {
    return await _storage.read(key: _mnemonicKey);
  }

  /// Delete wallet (for testing/reset)
  Future<void> deleteWallet() async {
    await _storage.delete(key: _mnemonicKey);
    await _storage.delete(key: _descriptorKey);
    _wallet = null;
    _blockchain = null;
  }

  /// Build a transaction
  /// Returns the transaction and return PSBT with fee info
  Future<(PartiallySignedTransaction psbt, TransactionDetails details)>
  buildTransaction({
    required String recipientAddress,
    required int amountSats,
    required double feeRate,
  }) async {
    if (_wallet == null) throw Exception('Wallet not initialized');

    try {
      // Create address object
      final address = await Address.fromString(
        s: recipientAddress,
        network: Network.testnet,
      );

      // Get script pubkey from address
      final script = await address.scriptPubkey();

      // Create transaction builder
      final txBuilder = TxBuilder();

      // Add recipient output
      await txBuilder.addRecipient(script, BigInt.from(amountSats));

      // Set fee rate
      await txBuilder.feeRate(feeRate);

      // Enable RBF (Replace-By-Fee) - allows fee bumping later
      await txBuilder.enableRbf();

      // Finish building - returns (PSBT, TransactionDetails)
      final result = await txBuilder.finish(_wallet!);

      return result;
    } catch (e) {
      throw Exception('Failed to build transaction: $e');
    }
  }

  /// Estimate fee for a transaction
  Future<FeeEstimate> estimateFee({
    required String recipientAddress,
    required int amountSats,
    required FeeSpeed speed,
  }) async {
    try {
      // Build transaction to get fee estimate
      final (psbt, details) = await buildTransaction(
        recipientAddress: recipientAddress,
        amountSats: amountSats,
        feeRate: speed.satsPerVByte,
      );

      // Get fee from transaction details
      final fee = details.fee?.toInt() ?? 0;

      // Estimate transaction size
      // Virtual size = fee / rate
      final vsize = fee > 0 ? (fee / speed.satsPerVByte).ceil() : 0;

      return FeeEstimate(
        feeSats: fee,
        feeRate: speed.satsPerVByte,
        txSize: vsize,
        speed: speed,
      );
    } catch (e) {
      throw Exception('Failed to estimate fee: $e');
    }
  }

  /// Sign and broadcast transaction
  Future<String> sendTransaction({
    required String recipientAddress,
    required int amountSats,
    required double feeRate,
  }) async {
    if (_wallet == null || _blockchain == null) {
      throw Exception('Wallet or blockchain not initialized');
    }

    try {
      // Build transaction
      final (psbt, details) = await buildTransaction(
        recipientAddress: recipientAddress,
        amountSats: amountSats,
        feeRate: feeRate,
      );

      // Sign the PSBT
      final signResult = await _wallet!.sign(
        psbt: psbt,
        signOptions: const SignOptions(
          trustWitnessUtxo: true,
          allowAllSighashes: false,
          removePartialSigs: true,
          tryFinalize: true,
          signWithTapInternalKey: true,
          allowGrinding: false,
        ),
      );

      // Check if signing was successful
      if (!signResult) {
        throw Exception('Failed to sign transaction');
      }

      // Extract the signed transaction
      final transaction = await psbt.extractTx();

      // Broadcast to network
      await _blockchain!.broadcast(transaction: transaction);

      // Get transaction ID
      final txid = await transaction.txid();

      return txid;
    } catch (e) {
      throw Exception('Failed to send transaction: $e');
    }
  }

  /// Validate Bitcoin address
  Future<bool> validateAddress(String address) async {
    try {
      final addr = await Address.fromString(
        s: address,
        network: Network.testnet,
      );

      // If we got here without error, address is valid for testnet
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get list of transactions
  Future<List<TransactionDetails>> getTransactions() async {
    if (_wallet == null) throw Exception('Wallet not initialized');

    final transactions = await _wallet!.listTransactions(includeRaw: false);
    return transactions;
  }
}
