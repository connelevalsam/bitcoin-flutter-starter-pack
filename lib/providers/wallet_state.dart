/*
* Created by Connel Asikong on 09/01/2026
*
*/

import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_state.freezed.dart';

/// Represents the current state of the wallet
@freezed
class WalletState with _$WalletState {
  const factory WalletState({
    /// Is the wallet currently initializing?
    @Default(false) bool isInitializing,

    /// Is the wallet currently syncing with blockchain?
    @Default(false) bool isSyncing,

    /// Has the wallet been initialized?
    @Default(false) bool isInitialized,

    /// Current receiving address
    String? currentAddress,

    /// Total balance in satoshis
    @Default(0) int totalBalance,

    /// Confirmed balance in satoshis
    @Default(0) int confirmedBalance,

    /// Pending balance in satoshis
    @Default(0) int pendingBalance,

    /// Error message if something went wrong
    String? error,

    /// Last sync timestamp
    DateTime? lastSyncTime,
  }) = _WalletState;

  const WalletState._();

  /// Helper: Is wallet ready to use?
  bool get isReady => isInitialized && !isInitializing && error == null;

  /// Helper: Format balance as BTC
  String get balanceInBTC => (totalBalance / 100000000).toStringAsFixed(8);

  /// Helper: Format balance as sats
  String get balanceInSats => '$totalBalance sats';

  @override
  // TODO: implement confirmedBalance
  int get confirmedBalance => throw UnimplementedError();

  @override
  // TODO: implement currentAddress
  String? get currentAddress => throw UnimplementedError();

  @override
  // TODO: implement error
  String? get error => throw UnimplementedError();

  @override
  // TODO: implement isInitialized
  bool get isInitialized => throw UnimplementedError();

  @override
  // TODO: implement isInitializing
  bool get isInitializing => throw UnimplementedError();

  @override
  // TODO: implement isSyncing
  bool get isSyncing => throw UnimplementedError();

  @override
  // TODO: implement lastSyncTime
  DateTime? get lastSyncTime => throw UnimplementedError();

  @override
  // TODO: implement pendingBalance
  int get pendingBalance => throw UnimplementedError();

  @override
  // TODO: implement totalBalance
  int get totalBalance => throw UnimplementedError();
}
