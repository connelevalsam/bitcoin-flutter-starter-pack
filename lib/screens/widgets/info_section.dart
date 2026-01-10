/*
* Created by Connel Asikong on 10/01/2026
*
*/

import 'package:flutter/material.dart';

import '../../providers/wallet_state.dart';

/// Wallet information section
class InfoSection extends StatelessWidget {
  final WalletState state;

  const InfoSection({required this.state});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Wallet Info',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _InfoRow(
              label: 'Network',
              value: 'Testnet',
              valueColor: Colors.orange,
            ),
            _InfoRow(
              label: 'Confirmed',
              value: '${state.confirmedBalance} sats',
            ),
            _InfoRow(label: 'Pending', value: '${state.pendingBalance} sats'),
            if (state.lastSyncTime != null)
              _InfoRow(
                label: 'Last Sync',
                value: _formatTime(state.lastSyncTime!),
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w500, color: valueColor),
          ),
        ],
      ),
    );
  }
}

String _formatTime(DateTime time) {
  final now = DateTime.now();
  final diff = now.difference(time);

  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  return '${diff.inDays}d ago';
}
