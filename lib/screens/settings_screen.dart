/*
* Created by Connel Asikong on 10/01/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/wallet_provider.dart';
import 'widgets/section_header.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletNotifier = ref.read(walletProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const SectionHeader(title: 'Backup & Security'),

          ListTile(
            leading: const Icon(Icons.key),
            title: const Text('View Recovery Phrase'),
            subtitle: const Text('Show your 12-word backup phrase'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showRecoveryPhrase(context, walletNotifier),
          ),

          const Divider(),
          const SectionHeader(title: 'Danger Zone'),

          ListTile(
            leading: const Icon(Icons.warning, color: Colors.red),
            title: const Text('Reset Wallet'),
            subtitle: const Text('Delete and create a new wallet'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _confirmReset(context, walletNotifier),
          ),

          const Divider(),
          const SectionHeader(title: 'About'),

          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Version'),
            subtitle: Text('1.0.0 (Testnet)'),
          ),

          const ListTile(
            leading: Icon(Icons.person),
            title: Text('Author'),
            subtitle: Text(
              'Connel Asikong for the Mobile community in Bitcoin',
            ),
          ),

          const ListTile(
            leading: Icon(Icons.code),
            title: Text('Network'),
            subtitle: Text('Bitcoin Testnet'),
          ),
        ],
      ),
    );
  }

  Future<void> _showRecoveryPhrase(
    BuildContext context,
    WalletNotifier notifier,
  ) async {
    final mnemonic = await notifier.getMnemonic();

    if (mnemonic == null || !context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recovery Phrase'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '⚠️ Never share this phrase with anyone!',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                mnemonic,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: mnemonic));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copied to clipboard')),
              );
            },
            child: const Text('Copy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReset(
    BuildContext context,
    WalletNotifier notifier,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Wallet?'),
        content: const Text(
          'This will delete your current wallet and create a new one. '
          'Make sure you have backed up your recovery phrase!\n\n'
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await notifier.resetWallet();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wallet reset successfully')),
        );
      }
    }
  }
}
