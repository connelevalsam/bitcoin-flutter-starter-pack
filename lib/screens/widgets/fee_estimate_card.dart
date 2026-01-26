/*
* Created by Connel Asikong on 25/01/2026
*
*/

import 'package:flutter/material.dart';

import '../../models/fee_estimate.dart';
import 'detail_row.dart';

class FeeEstimateCard extends StatelessWidget {
  final FeeEstimate estimate;

  const FeeEstimateCard({super.key, required this.estimate});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fee Estimate',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            DetailRow(label: 'Fee', value: '${estimate.feeSats} sats'),
            DetailRow(label: 'Rate', value: '${estimate.feeRate} sats/vByte'),
            DetailRow(label: 'Size', value: '~${estimate.txSize} vBytes'),
            DetailRow(label: 'Speed', value: estimate.description),
          ],
        ),
      ),
    );
  }
}
