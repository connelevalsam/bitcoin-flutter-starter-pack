/*
* Created by Connel Asikong on 11/01/2026
*
*/

import 'package:flutter/material.dart';

/// Getting started instructions
class GettingStartedCard extends StatelessWidget {
  const GettingStartedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Getting Started',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text('1. Tap "Receive" to get your Bitcoin address'),
            SizedBox(height: 6),
            Text('2. Get testnet BTC from a faucet:'),
            Text(
              '   • testnet-faucet.com',
              style: TextStyle(fontFamily: 'monospace'),
            ),
            Text(
              '   • bitcoinfaucet.uo1.net',
              style: TextStyle(fontFamily: 'monospace'),
            ),
            SizedBox(height: 6),
            Text('3. Wait 10-30 minutes for confirmation'),
            SizedBox(height: 6),
            Text('4. Pull down to refresh your balance'),
          ],
        ),
      ),
    );
  }
}
