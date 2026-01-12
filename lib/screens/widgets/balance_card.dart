/*
* Created by Connel Asikong on 11/01/2026
*
*/

import 'dart:math' as math;

import 'package:bitcoin_flutter_starter/providers/wallet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BalanceCard extends ConsumerWidget {
  final WalletState state;
  const BalanceCard({super.key, required this.state});

  double _calculate() {
    double btc = double.parse(state.balanceInBTC);
    String convert = btc.toStringAsFixed(2);
    double converted = double.parse(convert);
    return converted;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Balance',
                    style: TextStyle(color: Color(0xFF9333EA), fontSize: 14),
                  ),
                  if (state.isSyncing)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white70,
                        ),
                      ),
                    ),

                  const SizedBox(height: 8),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFF9333EA),
                        Color(0xFFDB2777),
                        Color(0xFFEA580C),
                      ],
                    ).createShader(bounds),
                    child: Text(
                      '${state.balanceInBTC} BTC',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '≈ \$${_calculate()}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            ),
            Transform.rotate(
              angle: 12 * math.pi / 180,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFA855F7), Color(0xFFEC4899)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFA855F7).withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '₿',
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(height: 1, color: const Color(0xFFE9D5FF)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFECFDF5), Color(0xFFD1FAE5)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today',
                      style: TextStyle(color: Colors.green[600], fontSize: 10),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '+\$1,234',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFAF5FF), Color(0xFFFCE7F3)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'This Week',
                      style: TextStyle(color: Color(0xFF9333EA), fontSize: 10),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '+\$8,567',
                      style: TextStyle(
                        color: Colors.purple[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
