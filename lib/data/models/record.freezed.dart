// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MedicalRecord _$MedicalRecordFromJson(Map<String, dynamic> json) {
  return _MedicalRecord.fromJson(json);
}

/// @nodoc
mixin _$MedicalRecord {
  String get id => throw _privateConstructorUsedError;
  String get personId => throw _privateConstructorUsedError;
  String? get hospitalName => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime get notedAt => throw _privateConstructorUsedError;
  DateTime? get visitEndDate => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  RecordStatus get status => throw _privateConstructorUsedError;
  String? get tagsCache => throw _privateConstructorUsedError;

  /// 内存关联字段
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<MedicalImage> get images => throw _privateConstructorUsedError;

  /// Serializes this MedicalRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MedicalRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicalRecordCopyWith<MedicalRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicalRecordCopyWith<$Res> {
  factory $MedicalRecordCopyWith(
          MedicalRecord value, $Res Function(MedicalRecord) then) =
      _$MedicalRecordCopyWithImpl<$Res, MedicalRecord>;
  @useResult
  $Res call(
      {String id,
      String personId,
      String? hospitalName,
      String? notes,
      DateTime notedAt,
      DateTime? visitEndDate,
      DateTime createdAt,
      DateTime updatedAt,
      RecordStatus status,
      String? tagsCache,
      @JsonKey(includeFromJson: false, includeToJson: false)
      List<MedicalImage> images});
}

/// @nodoc
class _$MedicalRecordCopyWithImpl<$Res, $Val extends MedicalRecord>
    implements $MedicalRecordCopyWith<$Res> {
  _$MedicalRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicalRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? personId = null,
    Object? hospitalName = freezed,
    Object? notes = freezed,
    Object? notedAt = null,
    Object? visitEndDate = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? status = null,
    Object? tagsCache = freezed,
    Object? images = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      personId: null == personId
          ? _value.personId
          : personId // ignore: cast_nullable_to_non_nullable
              as String,
      hospitalName: freezed == hospitalName
          ? _value.hospitalName
          : hospitalName // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      notedAt: null == notedAt
          ? _value.notedAt
          : notedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      visitEndDate: freezed == visitEndDate
          ? _value.visitEndDate
          : visitEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RecordStatus,
      tagsCache: freezed == tagsCache
          ? _value.tagsCache
          : tagsCache // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<MedicalImage>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MedicalRecordImplCopyWith<$Res>
    implements $MedicalRecordCopyWith<$Res> {
  factory _$$MedicalRecordImplCopyWith(
          _$MedicalRecordImpl value, $Res Function(_$MedicalRecordImpl) then) =
      __$$MedicalRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String personId,
      String? hospitalName,
      String? notes,
      DateTime notedAt,
      DateTime? visitEndDate,
      DateTime createdAt,
      DateTime updatedAt,
      RecordStatus status,
      String? tagsCache,
      @JsonKey(includeFromJson: false, includeToJson: false)
      List<MedicalImage> images});
}

/// @nodoc
class __$$MedicalRecordImplCopyWithImpl<$Res>
    extends _$MedicalRecordCopyWithImpl<$Res, _$MedicalRecordImpl>
    implements _$$MedicalRecordImplCopyWith<$Res> {
  __$$MedicalRecordImplCopyWithImpl(
      _$MedicalRecordImpl _value, $Res Function(_$MedicalRecordImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicalRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? personId = null,
    Object? hospitalName = freezed,
    Object? notes = freezed,
    Object? notedAt = null,
    Object? visitEndDate = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? status = null,
    Object? tagsCache = freezed,
    Object? images = null,
  }) {
    return _then(_$MedicalRecordImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      personId: null == personId
          ? _value.personId
          : personId // ignore: cast_nullable_to_non_nullable
              as String,
      hospitalName: freezed == hospitalName
          ? _value.hospitalName
          : hospitalName // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      notedAt: null == notedAt
          ? _value.notedAt
          : notedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      visitEndDate: freezed == visitEndDate
          ? _value.visitEndDate
          : visitEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RecordStatus,
      tagsCache: freezed == tagsCache
          ? _value.tagsCache
          : tagsCache // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<MedicalImage>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MedicalRecordImpl implements _MedicalRecord {
  const _$MedicalRecordImpl(
      {required this.id,
      required this.personId,
      this.hospitalName,
      this.notes,
      required this.notedAt,
      this.visitEndDate,
      required this.createdAt,
      required this.updatedAt,
      this.status = RecordStatus.archived,
      this.tagsCache,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final List<MedicalImage> images = const []})
      : _images = images;

  factory _$MedicalRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$MedicalRecordImplFromJson(json);

  @override
  final String id;
  @override
  final String personId;
  @override
  final String? hospitalName;
  @override
  final String? notes;
  @override
  final DateTime notedAt;
  @override
  final DateTime? visitEndDate;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  @JsonKey()
  final RecordStatus status;
  @override
  final String? tagsCache;

  /// 内存关联字段
  final List<MedicalImage> _images;

  /// 内存关联字段
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<MedicalImage> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  String toString() {
    return 'MedicalRecord(id: $id, personId: $personId, hospitalName: $hospitalName, notes: $notes, notedAt: $notedAt, visitEndDate: $visitEndDate, createdAt: $createdAt, updatedAt: $updatedAt, status: $status, tagsCache: $tagsCache, images: $images)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicalRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.personId, personId) ||
                other.personId == personId) &&
            (identical(other.hospitalName, hospitalName) ||
                other.hospitalName == hospitalName) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.notedAt, notedAt) || other.notedAt == notedAt) &&
            (identical(other.visitEndDate, visitEndDate) ||
                other.visitEndDate == visitEndDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.tagsCache, tagsCache) ||
                other.tagsCache == tagsCache) &&
            const DeepCollectionEquality().equals(other._images, _images));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      personId,
      hospitalName,
      notes,
      notedAt,
      visitEndDate,
      createdAt,
      updatedAt,
      status,
      tagsCache,
      const DeepCollectionEquality().hash(_images));

  /// Create a copy of MedicalRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicalRecordImplCopyWith<_$MedicalRecordImpl> get copyWith =>
      __$$MedicalRecordImplCopyWithImpl<_$MedicalRecordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MedicalRecordImplToJson(
      this,
    );
  }
}

abstract class _MedicalRecord implements MedicalRecord {
  const factory _MedicalRecord(
      {required final String id,
      required final String personId,
      final String? hospitalName,
      final String? notes,
      required final DateTime notedAt,
      final DateTime? visitEndDate,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final RecordStatus status,
      final String? tagsCache,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final List<MedicalImage> images}) = _$MedicalRecordImpl;

  factory _MedicalRecord.fromJson(Map<String, dynamic> json) =
      _$MedicalRecordImpl.fromJson;

  @override
  String get id;
  @override
  String get personId;
  @override
  String? get hospitalName;
  @override
  String? get notes;
  @override
  DateTime get notedAt;
  @override
  DateTime? get visitEndDate;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  RecordStatus get status;
  @override
  String? get tagsCache;

  /// 内存关联字段
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<MedicalImage> get images;

  /// Create a copy of MedicalRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicalRecordImplCopyWith<_$MedicalRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
