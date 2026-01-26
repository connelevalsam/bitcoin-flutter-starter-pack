/*
* Created by Connel Asikong on 10/01/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/fee_estimate.dart';
import '../providers/wallet_provider.dart';
import '../router/app_router.dart';
import 'widgets/balance_card.dart';
import 'widgets/detail_row.dart';
import 'widgets/fee_estimate_card.dart';

class SendScreen extends ConsumerStatefulWidget {
  const SendScreen({super.key});

  @override
  ConsumerState createState() => _SendScreenState();
}

class _SendScreenState extends ConsumerState<SendScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _amountController = TextEditingController();

  FeeSpeed _selectedSpeed = FeeSpeed.normal;
  FeeEstimate? _feeEstimate;
  bool _isEstimating = false;
  bool _isSending = false;

  @override
  void dispose() {
    _addressController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Bitcoin'),
        actions: [
          // Settings button
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(Routes.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Balance display
              BalanceCard(state: walletState),

              const SizedBox(height: 24),

              // Recipient address
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Recipient Address',
                  hintText: 'tb1q...',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.qr_code_scanner),
                    onPressed: _scanQRCode,
                  ),
                ),
                maxLines: 2,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter recipient address';
                  }
                  if (!value.startsWith('tb1') &&
                      !value.startsWith('m') &&
                      !value.startsWith('n')) {
                    return 'Invalid testnet address';
                  }
                  return null;
                },
                onChanged: (_) => _clearFeeEstimate(),
              ),

              const SizedBox(height: 16),

              // Amount in sats
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount (sats)',
                  hintText: '10000',
                  border: OutlineInputBorder(),
                  suffixText: 'sats',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  final amount = int.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Invalid amount';
                  }
                  if (amount > walletState.confirmedBalance) {
                    return 'Insufficient balance';
                  }
                  if (amount < 546) {
                    return 'Minimum amount is 546 sats (dust limit)';
                  }
                  return null;
                },
                onChanged: (_) => _clearFeeEstimate(),
              ),

              const SizedBox(height: 24),

              // Fee selection
              const Text(
                'Transaction Speed',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              ...FeeSpeed.values.map(
                (speed) => RadioListTile<FeeSpeed>(
                  title: Text(speed.label),
                  subtitle: Text(
                    '${speed.estimatedTime} • ${speed.satsPerVByte} sats/vByte',
                  ),
                  value: speed,
                  groupValue: _selectedSpeed,
                  onChanged: (value) {
                    setState(() {
                      _selectedSpeed = value!;
                      _clearFeeEstimate();
                    });
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Estimate fee button
              ElevatedButton.icon(
                onPressed: _isEstimating ? null : _estimateFee,
                icon: _isEstimating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.calculate),
                label: Text(_isEstimating ? 'Estimating...' : 'Estimate Fee'),
              ),

              // Fee estimate display
              if (_feeEstimate != null) ...[
                const SizedBox(height: 16),
                FeeEstimateCard(estimate: _feeEstimate!),
              ],

              const SizedBox(height: 24),

              // Send button
              FilledButton.icon(
                onPressed: (_feeEstimate == null || _isSending)
                    ? null
                    : _confirmAndSend,
                icon: _isSending
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Icon(Icons.send),
                label: Text(_isSending ? 'Sending...' : 'Send Bitcoin'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.orange.shade700,
                ),
              ),

              const SizedBox(height: 16),

              // Warning
              const Card(
                color: Colors.red,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Colors.white),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Bitcoin transactions are irreversible. Double-check the address!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _clearFeeEstimate() {
    setState(() {
      _feeEstimate = null;
    });
  }

  Future<void> _estimateFee() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isEstimating = true;
    });

    try {
      final walletNotifier = ref.read(walletProvider.notifier);

      final estimate = await walletNotifier.estimateFee(
        recipientAddress: _addressController.text.trim(),
        amountSats: int.parse(_amountController.text),
        speed: _selectedSpeed,
      );

      setState(() {
        _feeEstimate = estimate;
        _isEstimating = false;
      });
    } catch (e) {
      setState(() {
        _isEstimating = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error estimating fee: $e')));
      }
    }
  }

  Future<void> _confirmAndSend() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Transaction'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailRow(
              label: 'To',
              value: _addressController.text.trim(),
              monospace: true,
            ),
            const SizedBox(height: 8),
            DetailRow(label: 'Amount', value: '${_amountController.text} sats'),
            DetailRow(label: 'Fee', value: '${_feeEstimate!.feeSats} sats'),
            const Divider(),
            DetailRow(
              label: 'Total',
              value:
                  '${int.parse(_amountController.text) + _feeEstimate!.feeSats} sats',
              bold: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.orange.shade700,
            ),
            child: const Text('Send'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isSending = true;
    });

    try {
      final walletNotifier = ref.read(walletProvider.notifier);

      final txId = await walletNotifier.sendBitcoin(
        recipientAddress: _addressController.text.trim(),
        amountSats: int.parse(_amountController.text),
        feeRate: _selectedSpeed.satsPerVByte,
      );

      if (mounted) {
        // Show success dialog
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('Transaction Sent!'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your transaction has been broadcast to the network.',
                ),
                const SizedBox(height: 16),
                const Text(
                  'Transaction ID:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  txId,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.pop(); // Go back to home
                },
                child: const Text('Done'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending transaction: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  void _scanQRCode() {
    // TODO: Implement QR code scanning in Week 4
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('QR scanning coming in Week 4!')),
    );
  }
}
