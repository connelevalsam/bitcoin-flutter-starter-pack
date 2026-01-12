/*
* Created by Connel Asikong on 10/01/2026
*
*/

import 'dart:math' as math;

import 'package:bitcoin_flutter_starter/screens/widgets/balance_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/wallet_provider.dart';
import '../router/app_router.dart';
import '../services/transaction.dart';
import 'widgets/chart_painter.dart';
import 'widgets/getting_started_card.dart';
import 'widgets/info_section.dart';
import 'widgets/transaction_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final transactions = [
    Transaction(
      type: 'received',
      amount: '+0.0245',
      usd: '+\$1,234.50',
      date: 'Today, 2:30 PM',
      from: 'Sarah Johnson',
      id: 'tx1234567890',
    ),
    Transaction(
      type: 'sent',
      amount: '-0.0180',
      usd: '-\$907.20',
      date: 'Today, 11:15 AM',
      from: 'Coffee Shop',
      id: 'tx0987654321',
    ),
    Transaction(
      type: 'received',
      amount: '+0.1500',
      usd: '+\$7,560.00',
      date: 'Yesterday',
      from: 'Michael Chen',
      id: 'tx1122334455',
    ),
    Transaction(
      type: 'sent',
      amount: '-0.0050',
      usd: '-\$252.00',
      date: 'Dec 10',
      from: 'Online Store',
      id: 'tx5544332211',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletProvider);
    final walletNotifier = ref.read(walletProvider.notifier);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFA855F7), // purple-500
              Color(0xFFEC4899), // pink-500
              Color(0xFFFB923C), // orange-400
            ],
          ),
        ),
        child: walletState.isInitializing
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Initializing wallet...'),
                    SizedBox(height: 8),
                    Text(
                      'This may take a few moments',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              )
            : walletState.error != null
            ? Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Something went wrong',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      walletState.error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => walletNotifier.initializeWallet(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : SafeArea(
                child: RefreshIndicator(
                  onRefresh: () => walletNotifier.syncWallet(),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: walletState.isSyncing
                                      ? null
                                      : () => walletNotifier.syncWallet(),
                                  icon: walletState.isSyncing
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.refresh,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                ),
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: () =>
                                      context.push(Routes.settings),
                                  icon: const Icon(
                                    Icons.settings,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Balance Card
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: BalanceCard(state: walletState),
                          ),
                          const SizedBox(height: 24),

                          // Action Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildActionButton(
                                icon: Icons.arrow_upward,
                                label: 'Send',
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFFB923C),
                                    Color(0xFFEC4899),
                                  ],
                                ),
                                shadowColor: const Color(0xFFFB923C),
                                rotation: 6,
                                onTab: () => context.push(Routes.send),
                              ),
                              _buildActionButton(
                                icon: Icons.arrow_downward,
                                label: 'Receive',
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFA855F7),
                                    Color(0xFF3B82F6),
                                  ],
                                ),
                                shadowColor: const Color(0xFFA855F7),
                                rotation: -6,
                                onTab: () => context.push(Routes.receive),
                              ),
                              _buildActionButton(
                                icon: Icons.qr_code,
                                label: 'QR',
                                gradient: null,
                                shadowColor: null,
                                rotation: 0,
                                isGlass: true,
                                onTab: () {},
                              ),
                              _buildActionButton(
                                icon: Icons.qr_code_scanner,
                                label: 'Scan',
                                gradient: null,
                                shadowColor: null,
                                rotation: 0,
                                isGlass: true,
                                onTab: () {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          /// Info section
                          InfoSection(state: walletState),
                          const SizedBox(height: 24),

                          // Price Chart
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ShaderMask(
                                      shaderCallback: (bounds) =>
                                          const LinearGradient(
                                            colors: [
                                              Color(0xFF9333EA),
                                              Color(0xFFDB2777),
                                            ],
                                          ).createShader(bounds),
                                      child: const Text(
                                        'Price Chart',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFFA855F7),
                                                Color(0xFFEC4899),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: const Text(
                                            '1W',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '1M',
                                          style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 10,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '1Y',
                                          style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  height: 80,
                                  child: CustomPaint(
                                    painter: ChartPainter(),
                                    child: Container(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Activity Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Activity',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'View All',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Transactions List
                          ...transactions.map(
                            (tx) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: TransactionCard(transaction: tx),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Getting started
                          GettingStartedCard(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Gradient? gradient,
    required Color? shadowColor,
    required double rotation,
    required VoidCallback onTab,
    bool isGlass = false,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTab,
          child: Transform.rotate(
            angle: rotation * math.pi / 180,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: gradient,
                color: isGlass ? Colors.white.withValues(alpha: 0.25) : null,
                border: isGlass
                    ? Border.all(color: Colors.white.withValues(alpha: 0.4))
                    : null,
                borderRadius: BorderRadius.circular(24),
                boxShadow: shadowColor != null
                    ? [
                        BoxShadow(
                          color: shadowColor.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
