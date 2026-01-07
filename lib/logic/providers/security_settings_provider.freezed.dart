// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'security_settings_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SecuritySettingsState {

 bool get hasPin; bool get isBiometricsEnabled; bool get canCheckBiometrics; bool get isLoading; int get lockTimeout;
/// Create a copy of SecuritySettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SecuritySettingsStateCopyWith<SecuritySettingsState> get copyWith => _$SecuritySettingsStateCopyWithImpl<SecuritySettingsState>(this as SecuritySettingsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SecuritySettingsState&&(identical(other.hasPin, hasPin) || other.hasPin == hasPin)&&(identical(other.isBiometricsEnabled, isBiometricsEnabled) || other.isBiometricsEnabled == isBiometricsEnabled)&&(identical(other.canCheckBiometrics, canCheckBiometrics) || other.canCheckBiometrics == canCheckBiometrics)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.lockTimeout, lockTimeout) || other.lockTimeout == lockTimeout));
}


@override
int get hashCode => Object.hash(runtimeType,hasPin,isBiometricsEnabled,canCheckBiometrics,isLoading,lockTimeout);

@override
String toString() {
  return 'SecuritySettingsState(hasPin: $hasPin, isBiometricsEnabled: $isBiometricsEnabled, canCheckBiometrics: $canCheckBiometrics, isLoading: $isLoading, lockTimeout: $lockTimeout)';
}


}

/// @nodoc
abstract mixin class $SecuritySettingsStateCopyWith<$Res>  {
  factory $SecuritySettingsStateCopyWith(SecuritySettingsState value, $Res Function(SecuritySettingsState) _then) = _$SecuritySettingsStateCopyWithImpl;
@useResult
$Res call({
 bool hasPin, bool isBiometricsEnabled, bool canCheckBiometrics, bool isLoading, int lockTimeout
});




}
/// @nodoc
class _$SecuritySettingsStateCopyWithImpl<$Res>
    implements $SecuritySettingsStateCopyWith<$Res> {
  _$SecuritySettingsStateCopyWithImpl(this._self, this._then);

  final SecuritySettingsState _self;
  final $Res Function(SecuritySettingsState) _then;

/// Create a copy of SecuritySettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hasPin = null,Object? isBiometricsEnabled = null,Object? canCheckBiometrics = null,Object? isLoading = null,Object? lockTimeout = null,}) {
  return _then(_self.copyWith(
hasPin: null == hasPin ? _self.hasPin : hasPin // ignore: cast_nullable_to_non_nullable
as bool,isBiometricsEnabled: null == isBiometricsEnabled ? _self.isBiometricsEnabled : isBiometricsEnabled // ignore: cast_nullable_to_non_nullable
as bool,canCheckBiometrics: null == canCheckBiometrics ? _self.canCheckBiometrics : canCheckBiometrics // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,lockTimeout: null == lockTimeout ? _self.lockTimeout : lockTimeout // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SecuritySettingsState].
extension SecuritySettingsStatePatterns on SecuritySettingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SecuritySettingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SecuritySettingsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SecuritySettingsState value)  $default,){
final _that = this;
switch (_that) {
case _SecuritySettingsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SecuritySettingsState value)?  $default,){
final _that = this;
switch (_that) {
case _SecuritySettingsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool hasPin,  bool isBiometricsEnabled,  bool canCheckBiometrics,  bool isLoading,  int lockTimeout)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SecuritySettingsState() when $default != null:
return $default(_that.hasPin,_that.isBiometricsEnabled,_that.canCheckBiometrics,_that.isLoading,_that.lockTimeout);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool hasPin,  bool isBiometricsEnabled,  bool canCheckBiometrics,  bool isLoading,  int lockTimeout)  $default,) {final _that = this;
switch (_that) {
case _SecuritySettingsState():
return $default(_that.hasPin,_that.isBiometricsEnabled,_that.canCheckBiometrics,_that.isLoading,_that.lockTimeout);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool hasPin,  bool isBiometricsEnabled,  bool canCheckBiometrics,  bool isLoading,  int lockTimeout)?  $default,) {final _that = this;
switch (_that) {
case _SecuritySettingsState() when $default != null:
return $default(_that.hasPin,_that.isBiometricsEnabled,_that.canCheckBiometrics,_that.isLoading,_that.lockTimeout);case _:
  return null;

}
}

}

/// @nodoc


class _SecuritySettingsState implements SecuritySettingsState {
  const _SecuritySettingsState({this.hasPin = false, this.isBiometricsEnabled = false, this.canCheckBiometrics = false, this.isLoading = false, this.lockTimeout = 60});
  

@override@JsonKey() final  bool hasPin;
@override@JsonKey() final  bool isBiometricsEnabled;
@override@JsonKey() final  bool canCheckBiometrics;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  int lockTimeout;

/// Create a copy of SecuritySettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SecuritySettingsStateCopyWith<_SecuritySettingsState> get copyWith => __$SecuritySettingsStateCopyWithImpl<_SecuritySettingsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SecuritySettingsState&&(identical(other.hasPin, hasPin) || other.hasPin == hasPin)&&(identical(other.isBiometricsEnabled, isBiometricsEnabled) || other.isBiometricsEnabled == isBiometricsEnabled)&&(identical(other.canCheckBiometrics, canCheckBiometrics) || other.canCheckBiometrics == canCheckBiometrics)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.lockTimeout, lockTimeout) || other.lockTimeout == lockTimeout));
}


@override
int get hashCode => Object.hash(runtimeType,hasPin,isBiometricsEnabled,canCheckBiometrics,isLoading,lockTimeout);

@override
String toString() {
  return 'SecuritySettingsState(hasPin: $hasPin, isBiometricsEnabled: $isBiometricsEnabled, canCheckBiometrics: $canCheckBiometrics, isLoading: $isLoading, lockTimeout: $lockTimeout)';
}


}

/// @nodoc
abstract mixin class _$SecuritySettingsStateCopyWith<$Res> implements $SecuritySettingsStateCopyWith<$Res> {
  factory _$SecuritySettingsStateCopyWith(_SecuritySettingsState value, $Res Function(_SecuritySettingsState) _then) = __$SecuritySettingsStateCopyWithImpl;
@override @useResult
$Res call({
 bool hasPin, bool isBiometricsEnabled, bool canCheckBiometrics, bool isLoading, int lockTimeout
});




}
/// @nodoc
class __$SecuritySettingsStateCopyWithImpl<$Res>
    implements _$SecuritySettingsStateCopyWith<$Res> {
  __$SecuritySettingsStateCopyWithImpl(this._self, this._then);

  final _SecuritySettingsState _self;
  final $Res Function(_SecuritySettingsState) _then;

/// Create a copy of SecuritySettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hasPin = null,Object? isBiometricsEnabled = null,Object? canCheckBiometrics = null,Object? isLoading = null,Object? lockTimeout = null,}) {
  return _then(_SecuritySettingsState(
hasPin: null == hasPin ? _self.hasPin : hasPin // ignore: cast_nullable_to_non_nullable
as bool,isBiometricsEnabled: null == isBiometricsEnabled ? _self.isBiometricsEnabled : isBiometricsEnabled // ignore: cast_nullable_to_non_nullable
as bool,canCheckBiometrics: null == canCheckBiometrics ? _self.canCheckBiometrics : canCheckBiometrics // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,lockTimeout: null == lockTimeout ? _self.lockTimeout : lockTimeout // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
