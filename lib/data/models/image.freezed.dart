// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MedicalImage {
  String get id;
  String get recordId;
  String get encryptionKey;
  String get thumbnailEncryptionKey;
  String get filePath;
  String get thumbnailPath;
  String get mimeType;
  int get fileSize;
  int get displayOrder;
  int? get width;
  int? get height; // OCR Results
  String? get ocrText;
  String? get ocrRawJson;
  double? get ocrConfidence;
  DateTime get createdAt;
  String? get hospitalName;
  DateTime? get visitDate;

  /// 数据库存储的 Tag IDs (JSON List from DB)
  List<String> get tagIds;

  /// 内存关联字段，不直接参与数据库简单序列化
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Tag> get tags;

  /// Create a copy of MedicalImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MedicalImageCopyWith<MedicalImage> get copyWith =>
      _$MedicalImageCopyWithImpl<MedicalImage>(
          this as MedicalImage, _$identity);

  /// Serializes this MedicalImage to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MedicalImage &&
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
            (identical(other.ocrText, ocrText) || other.ocrText == ocrText) &&
            (identical(other.ocrRawJson, ocrRawJson) ||
                other.ocrRawJson == ocrRawJson) &&
            (identical(other.ocrConfidence, ocrConfidence) ||
                other.ocrConfidence == ocrConfidence) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.hospitalName, hospitalName) ||
                other.hospitalName == hospitalName) &&
            (identical(other.visitDate, visitDate) ||
                other.visitDate == visitDate) &&
            const DeepCollectionEquality().equals(other.tagIds, tagIds) &&
            const DeepCollectionEquality().equals(other.tags, tags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
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
        ocrText,
        ocrRawJson,
        ocrConfidence,
        createdAt,
        hospitalName,
        visitDate,
        const DeepCollectionEquality().hash(tagIds),
        const DeepCollectionEquality().hash(tags)
      ]);

  @override
  String toString() {
    return 'MedicalImage(id: $id, recordId: $recordId, encryptionKey: $encryptionKey, thumbnailEncryptionKey: $thumbnailEncryptionKey, filePath: $filePath, thumbnailPath: $thumbnailPath, mimeType: $mimeType, fileSize: $fileSize, displayOrder: $displayOrder, width: $width, height: $height, ocrText: $ocrText, ocrRawJson: $ocrRawJson, ocrConfidence: $ocrConfidence, createdAt: $createdAt, hospitalName: $hospitalName, visitDate: $visitDate, tagIds: $tagIds, tags: $tags)';
  }
}

/// @nodoc
abstract mixin class $MedicalImageCopyWith<$Res> {
  factory $MedicalImageCopyWith(
          MedicalImage value, $Res Function(MedicalImage) _then) =
      _$MedicalImageCopyWithImpl;
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
      String? ocrText,
      String? ocrRawJson,
      double? ocrConfidence,
      DateTime createdAt,
      String? hospitalName,
      DateTime? visitDate,
      List<String> tagIds,
      @JsonKey(includeFromJson: false, includeToJson: false) List<Tag> tags});
}

/// @nodoc
class _$MedicalImageCopyWithImpl<$Res> implements $MedicalImageCopyWith<$Res> {
  _$MedicalImageCopyWithImpl(this._self, this._then);

  final MedicalImage _self;
  final $Res Function(MedicalImage) _then;

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
    Object? ocrText = freezed,
    Object? ocrRawJson = freezed,
    Object? ocrConfidence = freezed,
    Object? createdAt = null,
    Object? hospitalName = freezed,
    Object? visitDate = freezed,
    Object? tagIds = null,
    Object? tags = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      recordId: null == recordId
          ? _self.recordId
          : recordId // ignore: cast_nullable_to_non_nullable
              as String,
      encryptionKey: null == encryptionKey
          ? _self.encryptionKey
          : encryptionKey // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailEncryptionKey: null == thumbnailEncryptionKey
          ? _self.thumbnailEncryptionKey
          : thumbnailEncryptionKey // ignore: cast_nullable_to_non_nullable
              as String,
      filePath: null == filePath
          ? _self.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailPath: null == thumbnailPath
          ? _self.thumbnailPath
          : thumbnailPath // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _self.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      fileSize: null == fileSize
          ? _self.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int,
      displayOrder: null == displayOrder
          ? _self.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
      width: freezed == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as int?,
      height: freezed == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as int?,
      ocrText: freezed == ocrText
          ? _self.ocrText
          : ocrText // ignore: cast_nullable_to_non_nullable
              as String?,
      ocrRawJson: freezed == ocrRawJson
          ? _self.ocrRawJson
          : ocrRawJson // ignore: cast_nullable_to_non_nullable
              as String?,
      ocrConfidence: freezed == ocrConfidence
          ? _self.ocrConfidence
          : ocrConfidence // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      hospitalName: freezed == hospitalName
          ? _self.hospitalName
          : hospitalName // ignore: cast_nullable_to_non_nullable
              as String?,
      visitDate: freezed == visitDate
          ? _self.visitDate
          : visitDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tagIds: null == tagIds
          ? _self.tagIds
          : tagIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      tags: null == tags
          ? _self.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<Tag>,
    ));
  }
}

/// Adds pattern-matching-related methods to [MedicalImage].
extension MedicalImagePatterns on MedicalImage {
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
    TResult Function(_MedicalImage value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicalImage() when $default != null:
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
    TResult Function(_MedicalImage value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicalImage():
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
    TResult? Function(_MedicalImage value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicalImage() when $default != null:
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
            String id,
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
            String? ocrText,
            String? ocrRawJson,
            double? ocrConfidence,
            DateTime createdAt,
            String? hospitalName,
            DateTime? visitDate,
            List<String> tagIds,
            @JsonKey(includeFromJson: false, includeToJson: false)
            List<Tag> tags)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicalImage() when $default != null:
        return $default(
            _that.id,
            _that.recordId,
            _that.encryptionKey,
            _that.thumbnailEncryptionKey,
            _that.filePath,
            _that.thumbnailPath,
            _that.mimeType,
            _that.fileSize,
            _that.displayOrder,
            _that.width,
            _that.height,
            _that.ocrText,
            _that.ocrRawJson,
            _that.ocrConfidence,
            _that.createdAt,
            _that.hospitalName,
            _that.visitDate,
            _that.tagIds,
            _that.tags);
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
            String id,
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
            String? ocrText,
            String? ocrRawJson,
            double? ocrConfidence,
            DateTime createdAt,
            String? hospitalName,
            DateTime? visitDate,
            List<String> tagIds,
            @JsonKey(includeFromJson: false, includeToJson: false)
            List<Tag> tags)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicalImage():
        return $default(
            _that.id,
            _that.recordId,
            _that.encryptionKey,
            _that.thumbnailEncryptionKey,
            _that.filePath,
            _that.thumbnailPath,
            _that.mimeType,
            _that.fileSize,
            _that.displayOrder,
            _that.width,
            _that.height,
            _that.ocrText,
            _that.ocrRawJson,
            _that.ocrConfidence,
            _that.createdAt,
            _that.hospitalName,
            _that.visitDate,
            _that.tagIds,
            _that.tags);
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
            String id,
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
            String? ocrText,
            String? ocrRawJson,
            double? ocrConfidence,
            DateTime createdAt,
            String? hospitalName,
            DateTime? visitDate,
            List<String> tagIds,
            @JsonKey(includeFromJson: false, includeToJson: false)
            List<Tag> tags)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicalImage() when $default != null:
        return $default(
            _that.id,
            _that.recordId,
            _that.encryptionKey,
            _that.thumbnailEncryptionKey,
            _that.filePath,
            _that.thumbnailPath,
            _that.mimeType,
            _that.fileSize,
            _that.displayOrder,
            _that.width,
            _that.height,
            _that.ocrText,
            _that.ocrRawJson,
            _that.ocrConfidence,
            _that.createdAt,
            _that.hospitalName,
            _that.visitDate,
            _that.tagIds,
            _that.tags);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MedicalImage implements MedicalImage {
  const _MedicalImage(
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
      this.ocrText,
      this.ocrRawJson,
      this.ocrConfidence,
      required this.createdAt,
      this.hospitalName,
      this.visitDate,
      final List<String> tagIds = const [],
      @JsonKey(includeFromJson: false, includeToJson: false)
      final List<Tag> tags = const []})
      : _tagIds = tagIds,
        _tags = tags;
  factory _MedicalImage.fromJson(Map<String, dynamic> json) =>
      _$MedicalImageFromJson(json);

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
// OCR Results
  @override
  final String? ocrText;
  @override
  final String? ocrRawJson;
  @override
  final double? ocrConfidence;
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

  /// Create a copy of MedicalImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MedicalImageCopyWith<_MedicalImage> get copyWith =>
      __$MedicalImageCopyWithImpl<_MedicalImage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MedicalImageToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MedicalImage &&
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
            (identical(other.ocrText, ocrText) || other.ocrText == ocrText) &&
            (identical(other.ocrRawJson, ocrRawJson) ||
                other.ocrRawJson == ocrRawJson) &&
            (identical(other.ocrConfidence, ocrConfidence) ||
                other.ocrConfidence == ocrConfidence) &&
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
  int get hashCode => Object.hashAll([
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
        ocrText,
        ocrRawJson,
        ocrConfidence,
        createdAt,
        hospitalName,
        visitDate,
        const DeepCollectionEquality().hash(_tagIds),
        const DeepCollectionEquality().hash(_tags)
      ]);

  @override
  String toString() {
    return 'MedicalImage(id: $id, recordId: $recordId, encryptionKey: $encryptionKey, thumbnailEncryptionKey: $thumbnailEncryptionKey, filePath: $filePath, thumbnailPath: $thumbnailPath, mimeType: $mimeType, fileSize: $fileSize, displayOrder: $displayOrder, width: $width, height: $height, ocrText: $ocrText, ocrRawJson: $ocrRawJson, ocrConfidence: $ocrConfidence, createdAt: $createdAt, hospitalName: $hospitalName, visitDate: $visitDate, tagIds: $tagIds, tags: $tags)';
  }
}

/// @nodoc
abstract mixin class _$MedicalImageCopyWith<$Res>
    implements $MedicalImageCopyWith<$Res> {
  factory _$MedicalImageCopyWith(
          _MedicalImage value, $Res Function(_MedicalImage) _then) =
      __$MedicalImageCopyWithImpl;
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
      String? ocrText,
      String? ocrRawJson,
      double? ocrConfidence,
      DateTime createdAt,
      String? hospitalName,
      DateTime? visitDate,
      List<String> tagIds,
      @JsonKey(includeFromJson: false, includeToJson: false) List<Tag> tags});
}

/// @nodoc
class __$MedicalImageCopyWithImpl<$Res>
    implements _$MedicalImageCopyWith<$Res> {
  __$MedicalImageCopyWithImpl(this._self, this._then);

  final _MedicalImage _self;
  final $Res Function(_MedicalImage) _then;

  /// Create a copy of MedicalImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
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
    Object? ocrText = freezed,
    Object? ocrRawJson = freezed,
    Object? ocrConfidence = freezed,
    Object? createdAt = null,
    Object? hospitalName = freezed,
    Object? visitDate = freezed,
    Object? tagIds = null,
    Object? tags = null,
  }) {
    return _then(_MedicalImage(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      recordId: null == recordId
          ? _self.recordId
          : recordId // ignore: cast_nullable_to_non_nullable
              as String,
      encryptionKey: null == encryptionKey
          ? _self.encryptionKey
          : encryptionKey // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailEncryptionKey: null == thumbnailEncryptionKey
          ? _self.thumbnailEncryptionKey
          : thumbnailEncryptionKey // ignore: cast_nullable_to_non_nullable
              as String,
      filePath: null == filePath
          ? _self.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailPath: null == thumbnailPath
          ? _self.thumbnailPath
          : thumbnailPath // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _self.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      fileSize: null == fileSize
          ? _self.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int,
      displayOrder: null == displayOrder
          ? _self.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
      width: freezed == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as int?,
      height: freezed == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as int?,
      ocrText: freezed == ocrText
          ? _self.ocrText
          : ocrText // ignore: cast_nullable_to_non_nullable
              as String?,
      ocrRawJson: freezed == ocrRawJson
          ? _self.ocrRawJson
          : ocrRawJson // ignore: cast_nullable_to_non_nullable
              as String?,
      ocrConfidence: freezed == ocrConfidence
          ? _self.ocrConfidence
          : ocrConfidence // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      hospitalName: freezed == hospitalName
          ? _self.hospitalName
          : hospitalName // ignore: cast_nullable_to_non_nullable
              as String?,
      visitDate: freezed == visitDate
          ? _self.visitDate
          : visitDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tagIds: null == tagIds
          ? _self._tagIds
          : tagIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      tags: null == tags
          ? _self._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<Tag>,
    ));
  }
}

// dart format on
