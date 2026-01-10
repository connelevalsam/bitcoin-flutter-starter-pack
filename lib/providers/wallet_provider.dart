/*
* Created by Connel Asikong on 09/01/2026
*
*/

import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:bitcoin_flutter_starter/providers/wallet_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/wallet_service.dart';

/// Provider for WalletService singleton
final walletServiceProvider = Provider<WalletService>((ref) {
  return WalletService();
});

/// Provider for wallet state
final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>((
  ref,
) {
  final walletService = ref.watch(walletServiceProvider);
  return WalletNotifier(walletService);
});

/// StateNotifier that manages wallet state
class WalletNotifier extends StateNotifier<WalletState> {
  final WalletService _walletService;

  WalletNotifier(this._walletService) : super(const WalletState()) {
    // Auto-initialize on creation
    initializeWallet();
  }

  /// Initialize the wallet
  Future<void> initializeWallet() async {
    // Set loading state
    state = state.copyWith(isInitializing: true, error: null);

    try {
      // Initialize wallet
      await _walletService.initWallet();

      // Get initial address
      final address = await _walletService.getLastAddress();

      // Sync with blockchain
      await _syncWallet();

      // Update state with success
      state = state.copyWith(
        isInitializing: false,
        isInitialized: true,
        currentAddress: address,
      );
    } catch (e) {
      // Update state with error
      state = state.copyWith(isInitializing: false, error: e.toString());
    }
  }

  /// Sync wallet with blockchain
  Future<void> syncWallet() async {
    if (!state.isInitialized) return;

    state = state.copyWith(isSyncing: true, error: null);

    try {
      await _syncWallet();
    } catch (e) {
      state = state.copyWith(isSyncing: false, error: e.toString());
    }
  }

  /// Internal sync logic
  Future<void> _syncWallet() async {
    // Sync with blockchain
    await _walletService.sync();

    // Get updated balance
    final Balance balance = await _walletService.getBalance();

    // Update state
    state = state.copyWith(
      isSyncing: false,
      totalBalance: balance.total.toInt(),
      confirmedBalance: balance.confirmed.toInt(),
      pendingBalance: balance.trustedPending.toInt(),
      lastSyncTime: DateTime.now(),
    );
  }

  /// Generate a new receiving address
  Future<void> generateNewAddress() async {
    if (!state.isInitialized) return;

    try {
      final newAddress = await _walletService.getNewAddress();
      state = state.copyWith(currentAddress: newAddress);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Get mnemonic for backup
  Future<String?> getMnemonic() async {
    return await _walletService.getMnemonic();
  }

  /// Reset wallet (for testing)
  Future<void> resetWallet() async {
    await _walletService.deleteWallet();
    state = const WalletState();
    await initializeWallet();
  }
}
