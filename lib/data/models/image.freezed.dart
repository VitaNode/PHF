// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MedicalImage _$MedicalImageFromJson(Map<String, dynamic> json) {
  return _MedicalImage.fromJson(json);
}

/// @nodoc
mixin _$MedicalImage {
  String get id => throw _privateConstructorUsedError;
  String get recordId => throw _privateConstructorUsedError;
  String get encryptionKey => throw _privateConstructorUsedError;
  String get thumbnailEncryptionKey => throw _privateConstructorUsedError;
  String get filePath => throw _privateConstructorUsedError;
  String get thumbnailPath => throw _privateConstructorUsedError;
  String get mimeType => throw _privateConstructorUsedError;
  int get fileSize => throw _privateConstructorUsedError;
  int get displayOrder => throw _privateConstructorUsedError;
  int? get width => throw _privateConstructorUsedError;
  int? get height => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get hospitalName => throw _privateConstructorUsedError;
  DateTime? get visitDate => throw _privateConstructorUsedError;

  /// 数据库存储的 Tag IDs (JSON List from DB)
  List<String> get tagIds => throw _privateConstructorUsedError;

  /// 内存关联字段，不直接参与数据库简单序列化
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Tag> get tags => throw _privateConstructorUsedError;

  /// Serializes this MedicalImage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MedicalImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicalImageCopyWith<MedicalImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicalImageCopyWith<$Res> {
  factory $MedicalImageCopyWith(
          MedicalImage value, $Res Function(MedicalImage) then) =
      _$MedicalImageCopyWithImpl<$Res, MedicalImage>;
  @useResult
  $Res call(
      {String id,
      String recordId,
      String encryptionKey,
      String thumbnailEncryptionKey,
      String filePath,
      String thumbnailPath,
      String mimeType,
      int fileSize,
      int displayOrder,
      int? width,
      int? height,
      DateTime createdAt,
      String? hospitalName,
      DateTime? visitDate,
      List<String> tagIds,
      @JsonKey(includeFromJson: false, includeToJson: false) List<Tag> tags});
}

/// @nodoc
class _$MedicalImageCopyWithImpl<$Res, $Val extends MedicalImage>
    implements $MedicalImageCopyWith<$Res> {
  _$MedicalImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicalImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? recordId = null,
    Object? encryptionKey = null,
    Object? thumbnailEncryptionKey = null,
    Object? filePath = null,
    Object? thumbnailPath = null,
    Object? mimeType = null,
    Object? fileSize = null,
    Object? displayOrder = null,
    Object? width = freezed,
    Object? height = freezed,
    Object? createdAt = null,
    Object? hospitalName = freezed,
    Object? visitDate = freezed,
    Object? tagIds = null,
    Object? tags = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      recordId: null == recordId
          ? _value.recordId
          : recordId // ignore: cast_nullable_to_non_nullable
              as String,
      encryptionKey: null == encryptionKey
          ? _value.encryptionKey
          : encryptionKey // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailEncryptionKey: null == thumbnailEncryptionKey
          ? _value.thumbnailEncryptionKey
          : thumbnailEncryptionKey // ignore: cast_nullable_to_non_nullable
              as String,
      filePath: null == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailPath: null == thumbnailPath
          ? _value.thumbnailPath
          : thumbnailPath // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      fileSize: null == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int,
      displayOrder: null == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      hospitalName: freezed == hospitalName
          ? _value.hospitalName
          : hospitalName // ignore: cast_nullable_to_non_nullable
              as String?,
      visitDate: freezed == visitDate
          ? _value.visitDate
          : visitDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tagIds: null == tagIds
          ? _value.tagIds
          : tagIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<Tag>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MedicalImageImplCopyWith<$Res>
    implements $MedicalImageCopyWith<$Res> {
  factory _$$MedicalImageImplCopyWith(
          _$MedicalImageImpl value, $Res Function(_$MedicalImageImpl) then) =
      __$$MedicalImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String recordId,
      String encryptionKey,
      String thumbnailEncryptionKey,
      String filePath,
      String thumbnailPath,
      String mimeType,
      int fileSize,
      int displayOrder,
      int? width,
      int? height,
      DateTime createdAt,
      String? hospitalName,
      DateTime? visitDate,
      List<String> tagIds,
      @JsonKey(includeFromJson: false, includeToJson: false) List<Tag> tags});
}

/// @nodoc
class __$$MedicalImageImplCopyWithImpl<$Res>
    extends _$MedicalImageCopyWithImpl<$Res, _$MedicalImageImpl>
    implements _$$MedicalImageImplCopyWith<$Res> {
  __$$MedicalImageImplCopyWithImpl(
      _$MedicalImageImpl _value, $Res Function(_$MedicalImageImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicalImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? recordId = null,
    Object? encryptionKey = null,
    Object? thumbnailEncryptionKey = null,
    Object? filePath = null,
    Object? thumbnailPath = null,
    Object? mimeType = null,
    Object? fileSize = null,
    Object? displayOrder = null,
    Object? width = freezed,
    Object? height = freezed,
    Object? createdAt = null,
    Object? hospitalName = freezed,
    Object? visitDate = freezed,
    Object? tagIds = null,
    Object? tags = null,
  }) {
    return _then(_$MedicalImageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      recordId: null == recordId
          ? _value.recordId
          : recordId // ignore: cast_nullable_to_non_nullable
              as String,
      encryptionKey: null == encryptionKey
          ? _value.encryptionKey
          : encryptionKey // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailEncryptionKey: null == thumbnailEncryptionKey
          ? _value.thumbnailEncryptionKey
          : thumbnailEncryptionKey // ignore: cast_nullable_to_non_nullable
              as String,
      filePath: null == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailPath: null == thumbnailPath
          ? _value.thumbnailPath
          : thumbnailPath // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      fileSize: null == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int,
      displayOrder: null == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      hospitalName: freezed == hospitalName
          ? _value.hospitalName
          : hospitalName // ignore: cast_nullable_to_non_nullable
              as String?,
      visitDate: freezed == visitDate
          ? _value.visitDate
          : visitDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tagIds: null == tagIds
          ? _value._tagIds
          : tagIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<Tag>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MedicalImageImpl implements _MedicalImage {
  const _$MedicalImageImpl(
      {required this.id,
      required this.recordId,
      required this.encryptionKey,
      required this.thumbnailEncryptionKey,
      required this.filePath,
      required this.thumbnailPath,
      this.mimeType = 'image/jpeg',
      this.fileSize = 0,
      this.displayOrder = 0,
      this.width,
      this.height,
      required this.createdAt,
      this.hospitalName,
      this.visitDate,
      final List<String> tagIds = const [],
      @JsonKey(includeFromJson: false, includeToJson: false)
      final List<Tag> tags = const []})
      : _tagIds = tagIds,
        _tags = tags;

  factory _$MedicalImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$MedicalImageImplFromJson(json);

  @override
  final String id;
  @override
  final String recordId;
  @override
  final String encryptionKey;
  @override
  final String thumbnailEncryptionKey;
  @override
  final String filePath;
  @override
  final String thumbnailPath;
  @override
  @JsonKey()
  final String mimeType;
  @override
  @JsonKey()
  final int fileSize;
  @override
  @JsonKey()
  final int displayOrder;
  @override
  final int? width;
  @override
  final int? height;
  @override
  final DateTime createdAt;
  @override
  final String? hospitalName;
  @override
  final DateTime? visitDate;

  /// 数据库存储的 Tag IDs (JSON List from DB)
  final List<String> _tagIds;

  /// 数据库存储的 Tag IDs (JSON List from DB)
  @override
  @JsonKey()
  List<String> get tagIds {
    if (_tagIds is EqualUnmodifiableListView) return _tagIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tagIds);
  }

  /// 内存关联字段，不直接参与数据库简单序列化
  final List<Tag> _tags;

  /// 内存关联字段，不直接参与数据库简单序列化
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Tag> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  String toString() {
    return 'MedicalImage(id: $id, recordId: $recordId, encryptionKey: $encryptionKey, thumbnailEncryptionKey: $thumbnailEncryptionKey, filePath: $filePath, thumbnailPath: $thumbnailPath, mimeType: $mimeType, fileSize: $fileSize, displayOrder: $displayOrder, width: $width, height: $height, createdAt: $createdAt, hospitalName: $hospitalName, visitDate: $visitDate, tagIds: $tagIds, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicalImageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.recordId, recordId) ||
                other.recordId == recordId) &&
            (identical(other.encryptionKey, encryptionKey) ||
                other.encryptionKey == encryptionKey) &&
            (identical(other.thumbnailEncryptionKey, thumbnailEncryptionKey) ||
                other.thumbnailEncryptionKey == thumbnailEncryptionKey) &&
            (identical(other.filePath, filePath) ||
                other.filePath == filePath) &&
            (identical(other.thumbnailPath, thumbnailPath) ||
                other.thumbnailPath == thumbnailPath) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.hospitalName, hospitalName) ||
                other.hospitalName == hospitalName) &&
            (identical(other.visitDate, visitDate) ||
                other.visitDate == visitDate) &&
            const DeepCollectionEquality().equals(other._tagIds, _tagIds) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      recordId,
      encryptionKey,
      thumbnailEncryptionKey,
      filePath,
      thumbnailPath,
      mimeType,
      fileSize,
      displayOrder,
      width,
      height,
      createdAt,
      hospitalName,
      visitDate,
      const DeepCollectionEquality().hash(_tagIds),
      const DeepCollectionEquality().hash(_tags));

  /// Create a copy of MedicalImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicalImageImplCopyWith<_$MedicalImageImpl> get copyWith =>
      __$$MedicalImageImplCopyWithImpl<_$MedicalImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MedicalImageImplToJson(
      this,
    );
  }
}

abstract class _MedicalImage implements MedicalImage {
  const factory _MedicalImage(
      {required final String id,
      required final String recordId,
      required final String encryptionKey,
      required final String thumbnailEncryptionKey,
      required final String filePath,
      required final String thumbnailPath,
      final String mimeType,
      final int fileSize,
      final int displayOrder,
      final int? width,
      final int? height,
      required final DateTime createdAt,
      final String? hospitalName,
      final DateTime? visitDate,
      final List<String> tagIds,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final List<Tag> tags}) = _$MedicalImageImpl;

  factory _MedicalImage.fromJson(Map<String, dynamic> json) =
      _$MedicalImageImpl.fromJson;

  @override
  String get id;
  @override
  String get recordId;
  @override
  String get encryptionKey;
  @override
  String get thumbnailEncryptionKey;
  @override
  String get filePath;
  @override
  String get thumbnailPath;
  @override
  String get mimeType;
  @override
  int get fileSize;
  @override
  int get displayOrder;
  @override
  int? get width;
  @override
  int? get height;
  @override
  DateTime get createdAt;
  @override
  String? get hospitalName;
  @override
  DateTime? get visitDate;

  /// 数据库存储的 Tag IDs (JSON List from DB)
  @override
  List<String> get tagIds;

  /// 内存关联字段，不直接参与数据库简单序列化
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Tag> get tags;

  /// Create a copy of MedicalImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicalImageImplCopyWith<_$MedicalImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
