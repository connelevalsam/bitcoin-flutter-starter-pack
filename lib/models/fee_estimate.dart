/*
* Created by Connel Asikong on 25/01/2026
*
*/

/// Represents a fee estimation for a transaction
class FeeEstimate {
  /// Fee amount in satoshis
  final int feeSats;

  /// Fee rate in sats/vByte
  final double feeRate;

  /// Estimated transaction size in vBytes
  final int txSize;

  /// Estimated confirmation time
  final FeeSpeed speed;

  const FeeEstimate({
    required this.feeSats,
    required this.feeRate,
    required this.txSize,
    required this.speed,
  });

  /// Get fee in BTC
  double get feeBTC => feeSats / 100000000;

  /// Get description
  String get description => speed.description;
}

/// Fee speed options
enum FeeSpeed {
  slow(1.0, 'Slow', '~2 hours'),
  normal(5.0, 'Normal', '~30 minutes'),
  fast(10.0, 'Fast', '~10 minutes');

  final double satsPerVByte;
  final String label;
  final String estimatedTime;

  const FeeSpeed(this.satsPerVByte, this.label, this.estimatedTime);

  String get description => '$label ($estimatedTime)';
}
