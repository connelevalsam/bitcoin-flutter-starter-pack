/*
* Created by Connel Asikong on 25/01/2026
*
*/

import 'package:flutter/material.dart';

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool monospace;
  final bool bold;

  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.monospace = false,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: monospace ? 'monospace' : null,
                fontSize: monospace ? 11 : null,
                fontWeight: bold ? FontWeight.bold : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
