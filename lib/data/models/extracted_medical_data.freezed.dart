// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'extracted_medical_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExtractedMedicalData _$ExtractedMedicalDataFromJson(Map<String, dynamic> json) {
  return _ExtractedMedicalData.fromJson(json);
}

/// @nodoc
mixin _$ExtractedMedicalData {
  DateTime? get visitDate => throw _privateConstructorUsedError;
  String? get hospitalName => throw _privateConstructorUsedError;
  double get confidenceScore => throw _privateConstructorUsedError;

  /// Serializes this ExtractedMedicalData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExtractedMedicalData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExtractedMedicalDataCopyWith<ExtractedMedicalData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExtractedMedicalDataCopyWith<$Res> {
  factory $ExtractedMedicalDataCopyWith(ExtractedMedicalData value,
          $Res Function(ExtractedMedicalData) then) =
      _$ExtractedMedicalDataCopyWithImpl<$Res, ExtractedMedicalData>;
  @useResult
  $Res call(
      {DateTime? visitDate, String? hospitalName, double confidenceScore});
}

/// @nodoc
class _$ExtractedMedicalDataCopyWithImpl<$Res,
        $Val extends ExtractedMedicalData>
    implements $ExtractedMedicalDataCopyWith<$Res> {
  _$ExtractedMedicalDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExtractedMedicalData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? visitDate = freezed,
    Object? hospitalName = freezed,
    Object? confidenceScore = null,
  }) {
    return _then(_value.copyWith(
      visitDate: freezed == visitDate
          ? _value.visitDate
          : visitDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      hospitalName: freezed == hospitalName
          ? _value.hospitalName
          : hospitalName // ignore: cast_nullable_to_non_nullable
              as String?,
      confidenceScore: null == confidenceScore
          ? _value.confidenceScore
          : confidenceScore // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExtractedMedicalDataImplCopyWith<$Res>
    implements $ExtractedMedicalDataCopyWith<$Res> {
  factory _$$ExtractedMedicalDataImplCopyWith(_$ExtractedMedicalDataImpl value,
          $Res Function(_$ExtractedMedicalDataImpl) then) =
      __$$ExtractedMedicalDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime? visitDate, String? hospitalName, double confidenceScore});
}

/// @nodoc
class __$$ExtractedMedicalDataImplCopyWithImpl<$Res>
    extends _$ExtractedMedicalDataCopyWithImpl<$Res, _$ExtractedMedicalDataImpl>
    implements _$$ExtractedMedicalDataImplCopyWith<$Res> {
  __$$ExtractedMedicalDataImplCopyWithImpl(_$ExtractedMedicalDataImpl _value,
      $Res Function(_$ExtractedMedicalDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExtractedMedicalData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? visitDate = freezed,
    Object? hospitalName = freezed,
    Object? confidenceScore = null,
  }) {
    return _then(_$ExtractedMedicalDataImpl(
      visitDate: freezed == visitDate
          ? _value.visitDate
          : visitDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      hospitalName: freezed == hospitalName
          ? _value.hospitalName
          : hospitalName // ignore: cast_nullable_to_non_nullable
              as String?,
      confidenceScore: null == confidenceScore
          ? _value.confidenceScore
          : confidenceScore // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExtractedMedicalDataImpl implements _ExtractedMedicalData {
  const _$ExtractedMedicalDataImpl(
      {this.visitDate, this.hospitalName, this.confidenceScore = 0.0});

  factory _$ExtractedMedicalDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExtractedMedicalDataImplFromJson(json);

  @override
  final DateTime? visitDate;
  @override
  final String? hospitalName;
  @override
  @JsonKey()
  final double confidenceScore;

  @override
  String toString() {
    return 'ExtractedMedicalData(visitDate: $visitDate, hospitalName: $hospitalName, confidenceScore: $confidenceScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExtractedMedicalDataImpl &&
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

  /// Create a copy of ExtractedMedicalData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExtractedMedicalDataImplCopyWith<_$ExtractedMedicalDataImpl>
      get copyWith =>
          __$$ExtractedMedicalDataImplCopyWithImpl<_$ExtractedMedicalDataImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExtractedMedicalDataImplToJson(
      this,
    );
  }
}

abstract class _ExtractedMedicalData implements ExtractedMedicalData {
  const factory _ExtractedMedicalData(
      {final DateTime? visitDate,
      final String? hospitalName,
      final double confidenceScore}) = _$ExtractedMedicalDataImpl;

  factory _ExtractedMedicalData.fromJson(Map<String, dynamic> json) =
      _$ExtractedMedicalDataImpl.fromJson;

  @override
  DateTime? get visitDate;
  @override
  String? get hospitalName;
  @override
  double get confidenceScore;

  /// Create a copy of ExtractedMedicalData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExtractedMedicalDataImplCopyWith<_$ExtractedMedicalDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
