// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'extracted_medical_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExtractedMedicalData {
  DateTime? get visitDate;
  String? get hospitalName;
  double get confidenceScore;

  /// Create a copy of ExtractedMedicalData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ExtractedMedicalDataCopyWith<ExtractedMedicalData> get copyWith =>
      _$ExtractedMedicalDataCopyWithImpl<ExtractedMedicalData>(
          this as ExtractedMedicalData, _$identity);

  /// Serializes this ExtractedMedicalData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ExtractedMedicalData &&
            (identical(other.visitDate, visitDate) ||
                other.visitDate == visitDate) &&
            (identical(other.hospitalName, hospitalName) ||
                other.hospitalName == hospitalName) &&
            (identical(other.confidenceScore, confidenceScore) ||
                other.confidenceScore == confidenceScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, visitDate, hospitalName, confidenceScore);

  @override
  String toString() {
    return 'ExtractedMedicalData(visitDate: $visitDate, hospitalName: $hospitalName, confidenceScore: $confidenceScore)';
  }
}

/// @nodoc
abstract mixin class $ExtractedMedicalDataCopyWith<$Res> {
  factory $ExtractedMedicalDataCopyWith(ExtractedMedicalData value,
          $Res Function(ExtractedMedicalData) _then) =
      _$ExtractedMedicalDataCopyWithImpl;
  @useResult
  $Res call(
      {DateTime? visitDate, String? hospitalName, double confidenceScore});
}

/// @nodoc
class _$ExtractedMedicalDataCopyWithImpl<$Res>
    implements $ExtractedMedicalDataCopyWith<$Res> {
  _$ExtractedMedicalDataCopyWithImpl(this._self, this._then);

  final ExtractedMedicalData _self;
  final $Res Function(ExtractedMedicalData) _then;

  /// Create a copy of ExtractedMedicalData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? visitDate = freezed,
    Object? hospitalName = freezed,
    Object? confidenceScore = null,
  }) {
    return _then(_self.copyWith(
      visitDate: freezed == visitDate
          ? _self.visitDate
          : visitDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      hospitalName: freezed == hospitalName
          ? _self.hospitalName
          : hospitalName // ignore: cast_nullable_to_non_nullable
              as String?,
      confidenceScore: null == confidenceScore
          ? _self.confidenceScore
          : confidenceScore // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [ExtractedMedicalData].
extension ExtractedMedicalDataPatterns on ExtractedMedicalData {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ExtractedMedicalData value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ExtractedMedicalData() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ExtractedMedicalData value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExtractedMedicalData():
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ExtractedMedicalData value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExtractedMedicalData() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            DateTime? visitDate, String? hospitalName, double confidenceScore)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ExtractedMedicalData() when $default != null:
        return $default(
            _that.visitDate, _that.hospitalName, _that.confidenceScore);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            DateTime? visitDate, String? hospitalName, double confidenceScore)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExtractedMedicalData():
        return $default(
            _that.visitDate, _that.hospitalName, _that.confidenceScore);
      case _:
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            DateTime? visitDate, String? hospitalName, double confidenceScore)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExtractedMedicalData() when $default != null:
        return $default(
            _that.visitDate, _that.hospitalName, _that.confidenceScore);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ExtractedMedicalData implements ExtractedMedicalData {
  const _ExtractedMedicalData(
      {this.visitDate, this.hospitalName, this.confidenceScore = 0.0});
  factory _ExtractedMedicalData.fromJson(Map<String, dynamic> json) =>
      _$ExtractedMedicalDataFromJson(json);

  @override
  final DateTime? visitDate;
  @override
  final String? hospitalName;
  @override
  @JsonKey()
  final double confidenceScore;

  /// Create a copy of ExtractedMedicalData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ExtractedMedicalDataCopyWith<_ExtractedMedicalData> get copyWith =>
      __$ExtractedMedicalDataCopyWithImpl<_ExtractedMedicalData>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ExtractedMedicalDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ExtractedMedicalData &&
            (identical(other.visitDate, visitDate) ||
                other.visitDate == visitDate) &&
            (identical(other.hospitalName, hospitalName) ||
                other.hospitalName == hospitalName) &&
            (identical(other.confidenceScore, confidenceScore) ||
                other.confidenceScore == confidenceScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, visitDate, hospitalName, confidenceScore);

  @override
  String toString() {
    return 'ExtractedMedicalData(visitDate: $visitDate, hospitalName: $hospitalName, confidenceScore: $confidenceScore)';
  }
}

/// @nodoc
abstract mixin class _$ExtractedMedicalDataCopyWith<$Res>
    implements $ExtractedMedicalDataCopyWith<$Res> {
  factory _$ExtractedMedicalDataCopyWith(_ExtractedMedicalData value,
          $Res Function(_ExtractedMedicalData) _then) =
      __$ExtractedMedicalDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {DateTime? visitDate, String? hospitalName, double confidenceScore});
}

/// @nodoc
class __$ExtractedMedicalDataCopyWithImpl<$Res>
    implements _$ExtractedMedicalDataCopyWith<$Res> {
  __$ExtractedMedicalDataCopyWithImpl(this._self, this._then);

  final _ExtractedMedicalData _self;
  final $Res Function(_ExtractedMedicalData) _then;

  /// Create a copy of ExtractedMedicalData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? visitDate = freezed,
    Object? hospitalName = freezed,
    Object? confidenceScore = null,
  }) {
    return _then(_ExtractedMedicalData(
      visitDate: freezed == visitDate
          ? _self.visitDate
          : visitDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      hospitalName: freezed == hospitalName
          ? _self.hospitalName
          : hospitalName // ignore: cast_nullable_to_non_nullable
              as String?,
      confidenceScore: null == confidenceScore
          ? _self.confidenceScore
          : confidenceScore // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
