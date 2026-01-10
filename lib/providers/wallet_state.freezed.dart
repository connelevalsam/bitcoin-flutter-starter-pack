// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WalletState {

/// Is the wallet currently initializing?
 bool get isInitializing;/// Is the wallet currently syncing with blockchain?
 bool get isSyncing;/// Has the wallet been initialized?
 bool get isInitialized;/// Current receiving address
 String? get currentAddress;/// Total balance in satoshis
 int get totalBalance;/// Confirmed balance in satoshis
 int get confirmedBalance;/// Pending balance in satoshis
 int get pendingBalance;/// Error message if something went wrong
 String? get error;/// Last sync timestamp
 DateTime? get lastSyncTime;
/// Create a copy of WalletState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletStateCopyWith<WalletState> get copyWith => _$WalletStateCopyWithImpl<WalletState>(this as WalletState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletState&&(identical(other.isInitializing, isInitializing) || other.isInitializing == isInitializing)&&(identical(other.isSyncing, isSyncing) || other.isSyncing == isSyncing)&&(identical(other.isInitialized, isInitialized) || other.isInitialized == isInitialized)&&(identical(other.currentAddress, currentAddress) || other.currentAddress == currentAddress)&&(identical(other.totalBalance, totalBalance) || other.totalBalance == totalBalance)&&(identical(other.confirmedBalance, confirmedBalance) || other.confirmedBalance == confirmedBalance)&&(identical(other.pendingBalance, pendingBalance) || other.pendingBalance == pendingBalance)&&(identical(other.error, error) || other.error == error)&&(identical(other.lastSyncTime, lastSyncTime) || other.lastSyncTime == lastSyncTime));
}


@override
int get hashCode => Object.hash(runtimeType,isInitializing,isSyncing,isInitialized,currentAddress,totalBalance,confirmedBalance,pendingBalance,error,lastSyncTime);

@override
String toString() {
  return 'WalletState(isInitializing: $isInitializing, isSyncing: $isSyncing, isInitialized: $isInitialized, currentAddress: $currentAddress, totalBalance: $totalBalance, confirmedBalance: $confirmedBalance, pendingBalance: $pendingBalance, error: $error, lastSyncTime: $lastSyncTime)';
}


}

/// @nodoc
abstract mixin class $WalletStateCopyWith<$Res>  {
  factory $WalletStateCopyWith(WalletState value, $Res Function(WalletState) _then) = _$WalletStateCopyWithImpl;
@useResult
$Res call({
 bool isInitializing, bool isSyncing, bool isInitialized, String? currentAddress, int totalBalance, int confirmedBalance, int pendingBalance, String? error, DateTime? lastSyncTime
});




}
/// @nodoc
class _$WalletStateCopyWithImpl<$Res>
    implements $WalletStateCopyWith<$Res> {
  _$WalletStateCopyWithImpl(this._self, this._then);

  final WalletState _self;
  final $Res Function(WalletState) _then;

/// Create a copy of WalletState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isInitializing = null,Object? isSyncing = null,Object? isInitialized = null,Object? currentAddress = freezed,Object? totalBalance = null,Object? confirmedBalance = null,Object? pendingBalance = null,Object? error = freezed,Object? lastSyncTime = freezed,}) {
  return _then(_self.copyWith(
isInitializing: null == isInitializing ? _self.isInitializing : isInitializing // ignore: cast_nullable_to_non_nullable
as bool,isSyncing: null == isSyncing ? _self.isSyncing : isSyncing // ignore: cast_nullable_to_non_nullable
as bool,isInitialized: null == isInitialized ? _self.isInitialized : isInitialized // ignore: cast_nullable_to_non_nullable
as bool,currentAddress: freezed == currentAddress ? _self.currentAddress : currentAddress // ignore: cast_nullable_to_non_nullable
as String?,totalBalance: null == totalBalance ? _self.totalBalance : totalBalance // ignore: cast_nullable_to_non_nullable
as int,confirmedBalance: null == confirmedBalance ? _self.confirmedBalance : confirmedBalance // ignore: cast_nullable_to_non_nullable
as int,pendingBalance: null == pendingBalance ? _self.pendingBalance : pendingBalance // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,lastSyncTime: freezed == lastSyncTime ? _self.lastSyncTime : lastSyncTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [WalletState].
extension WalletStatePatterns on WalletState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletState value)  $default,){
final _that = this;
switch (_that) {
case _WalletState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletState value)?  $default,){
final _that = this;
switch (_that) {
case _WalletState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isInitializing,  bool isSyncing,  bool isInitialized,  String? currentAddress,  int totalBalance,  int confirmedBalance,  int pendingBalance,  String? error,  DateTime? lastSyncTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletState() when $default != null:
return $default(_that.isInitializing,_that.isSyncing,_that.isInitialized,_that.currentAddress,_that.totalBalance,_that.confirmedBalance,_that.pendingBalance,_that.error,_that.lastSyncTime);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isInitializing,  bool isSyncing,  bool isInitialized,  String? currentAddress,  int totalBalance,  int confirmedBalance,  int pendingBalance,  String? error,  DateTime? lastSyncTime)  $default,) {final _that = this;
switch (_that) {
case _WalletState():
return $default(_that.isInitializing,_that.isSyncing,_that.isInitialized,_that.currentAddress,_that.totalBalance,_that.confirmedBalance,_that.pendingBalance,_that.error,_that.lastSyncTime);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isInitializing,  bool isSyncing,  bool isInitialized,  String? currentAddress,  int totalBalance,  int confirmedBalance,  int pendingBalance,  String? error,  DateTime? lastSyncTime)?  $default,) {final _that = this;
switch (_that) {
case _WalletState() when $default != null:
return $default(_that.isInitializing,_that.isSyncing,_that.isInitialized,_that.currentAddress,_that.totalBalance,_that.confirmedBalance,_that.pendingBalance,_that.error,_that.lastSyncTime);case _:
  return null;

}
}

}

/// @nodoc


class _WalletState extends WalletState {
  const _WalletState({this.isInitializing = false, this.isSyncing = false, this.isInitialized = false, this.currentAddress, this.totalBalance = 0, this.confirmedBalance = 0, this.pendingBalance = 0, this.error, this.lastSyncTime}): super._();
  

/// Is the wallet currently initializing?
@override@JsonKey() final  bool isInitializing;
/// Is the wallet currently syncing with blockchain?
@override@JsonKey() final  bool isSyncing;
/// Has the wallet been initialized?
@override@JsonKey() final  bool isInitialized;
/// Current receiving address
@override final  String? currentAddress;
/// Total balance in satoshis
@override@JsonKey() final  int totalBalance;
/// Confirmed balance in satoshis
@override@JsonKey() final  int confirmedBalance;
/// Pending balance in satoshis
@override@JsonKey() final  int pendingBalance;
/// Error message if something went wrong
@override final  String? error;
/// Last sync timestamp
@override final  DateTime? lastSyncTime;

/// Create a copy of WalletState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletStateCopyWith<_WalletState> get copyWith => __$WalletStateCopyWithImpl<_WalletState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletState&&(identical(other.isInitializing, isInitializing) || other.isInitializing == isInitializing)&&(identical(other.isSyncing, isSyncing) || other.isSyncing == isSyncing)&&(identical(other.isInitialized, isInitialized) || other.isInitialized == isInitialized)&&(identical(other.currentAddress, currentAddress) || other.currentAddress == currentAddress)&&(identical(other.totalBalance, totalBalance) || other.totalBalance == totalBalance)&&(identical(other.confirmedBalance, confirmedBalance) || other.confirmedBalance == confirmedBalance)&&(identical(other.pendingBalance, pendingBalance) || other.pendingBalance == pendingBalance)&&(identical(other.error, error) || other.error == error)&&(identical(other.lastSyncTime, lastSyncTime) || other.lastSyncTime == lastSyncTime));
}


@override
int get hashCode => Object.hash(runtimeType,isInitializing,isSyncing,isInitialized,currentAddress,totalBalance,confirmedBalance,pendingBalance,error,lastSyncTime);

@override
String toString() {
  return 'WalletState(isInitializing: $isInitializing, isSyncing: $isSyncing, isInitialized: $isInitialized, currentAddress: $currentAddress, totalBalance: $totalBalance, confirmedBalance: $confirmedBalance, pendingBalance: $pendingBalance, error: $error, lastSyncTime: $lastSyncTime)';
}


}

/// @nodoc
abstract mixin class _$WalletStateCopyWith<$Res> implements $WalletStateCopyWith<$Res> {
  factory _$WalletStateCopyWith(_WalletState value, $Res Function(_WalletState) _then) = __$WalletStateCopyWithImpl;
@override @useResult
$Res call({
 bool isInitializing, bool isSyncing, bool isInitialized, String? currentAddress, int totalBalance, int confirmedBalance, int pendingBalance, String? error, DateTime? lastSyncTime
});




}
/// @nodoc
class __$WalletStateCopyWithImpl<$Res>
    implements _$WalletStateCopyWith<$Res> {
  __$WalletStateCopyWithImpl(this._self, this._then);

  final _WalletState _self;
  final $Res Function(_WalletState) _then;

/// Create a copy of WalletState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isInitializing = null,Object? isSyncing = null,Object? isInitialized = null,Object? currentAddress = freezed,Object? totalBalance = null,Object? confirmedBalance = null,Object? pendingBalance = null,Object? error = freezed,Object? lastSyncTime = freezed,}) {
  return _then(_WalletState(
isInitializing: null == isInitializing ? _self.isInitializing : isInitializing // ignore: cast_nullable_to_non_nullable
as bool,isSyncing: null == isSyncing ? _self.isSyncing : isSyncing // ignore: cast_nullable_to_non_nullable
as bool,isInitialized: null == isInitialized ? _self.isInitialized : isInitialized // ignore: cast_nullable_to_non_nullable
as bool,currentAddress: freezed == currentAddress ? _self.currentAddress : currentAddress // ignore: cast_nullable_to_non_nullable
as String?,totalBalance: null == totalBalance ? _self.totalBalance : totalBalance // ignore: cast_nullable_to_non_nullable
as int,confirmedBalance: null == confirmedBalance ? _self.confirmedBalance : confirmedBalance // ignore: cast_nullable_to_non_nullable
as int,pendingBalance: null == pendingBalance ? _self.pendingBalance : pendingBalance // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,lastSyncTime: freezed == lastSyncTime ? _self.lastSyncTime : lastSyncTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
