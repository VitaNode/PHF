// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MedicalRecord {
  String get id;
  String get personId;
  String? get hospitalName;
  String? get notes;
  DateTime get notedAt;
  DateTime? get visitEndDate;
  DateTime get createdAt;
  DateTime get updatedAt;
  RecordStatus get status;
  String? get tagsCache;

  /// 内存关联字段
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<MedicalImage> get images;

  /// Create a copy of MedicalRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MedicalRecordCopyWith<MedicalRecord> get copyWith =>
      _$MedicalRecordCopyWithImpl<MedicalRecord>(
          this as MedicalRecord, _$identity);

  /// Serializes this MedicalRecord to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MedicalRecord &&
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
            const DeepCollectionEquality().equals(other.images, images));
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
      const DeepCollectionEquality().hash(images));

  @override
  String toString() {
    return 'MedicalRecord(id: $id, personId: $personId, hospitalName: $hospitalName, notes: $notes, notedAt: $notedAt, visitEndDate: $visitEndDate, createdAt: $createdAt, updatedAt: $updatedAt, status: $status, tagsCache: $tagsCache, images: $images)';
  }
}

/// @nodoc
abstract mixin class $MedicalRecordCopyWith<$Res> {
  factory $MedicalRecordCopyWith(
          MedicalRecord value, $Res Function(MedicalRecord) _then) =
      _$MedicalRecordCopyWithImpl;
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
class _$MedicalRecordCopyWithImpl<$Res>
    implements $MedicalRecordCopyWith<$Res> {
  _$MedicalRecordCopyWithImpl(this._self, this._then);

  final MedicalRecord _self;
  final $Res Function(MedicalRecord) _then;

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
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      personId: null == personId
          ? _self.personId
          : personId // ignore: cast_nullable_to_non_nullable
              as String,
      hospitalName: freezed == hospitalName
          ? _self.hospitalName
          : hospitalName // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      notedAt: null == notedAt
          ? _self.notedAt
          : notedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      visitEndDate: freezed == visitEndDate
          ? _self.visitEndDate
          : visitEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as RecordStatus,
      tagsCache: freezed == tagsCache
          ? _self.tagsCache
          : tagsCache // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _self.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<MedicalImage>,
    ));
  }
}

/// Adds pattern-matching-related methods to [MedicalRecord].
extension MedicalRecordPatterns on MedicalRecord {
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
    TResult Function(_MedicalRecord value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicalRecord() when $default != null:
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
    TResult Function(_MedicalRecord value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicalRecord():
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
    TResult? Function(_MedicalRecord value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicalRecord() when $default != null:
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
            List<MedicalImage> images)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicalRecord() when $default != null:
        return $default(
            _that.id,
            _that.personId,
            _that.hospitalName,
            _that.notes,
            _that.notedAt,
            _that.visitEndDate,
            _that.createdAt,
            _that.updatedAt,
            _that.status,
            _that.tagsCache,
            _that.images);
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
            List<MedicalImage> images)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicalRecord():
        return $default(
            _that.id,
            _that.personId,
            _that.hospitalName,
            _that.notes,
            _that.notedAt,
            _that.visitEndDate,
            _that.createdAt,
            _that.updatedAt,
            _that.status,
            _that.tagsCache,
            _that.images);
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
            List<MedicalImage> images)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicalRecord() when $default != null:
        return $default(
            _that.id,
            _that.personId,
            _that.hospitalName,
            _that.notes,
            _that.notedAt,
            _that.visitEndDate,
            _that.createdAt,
            _that.updatedAt,
            _that.status,
            _that.tagsCache,
            _that.images);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MedicalRecord implements MedicalRecord {
  const _MedicalRecord(
      {required this.id,
      required this.personId,
      this.hospitalName,
      this.notes,
      required this.notedAt,
      this.visitEndDate,
      required this.createdAt,
      required this.updatedAt,
      this.status = RecordStatus.processing,
      this.tagsCache,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final List<MedicalImage> images = const []})
      : _images = images;
  factory _MedicalRecord.fromJson(Map<String, dynamic> json) =>
      _$MedicalRecordFromJson(json);

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

  /// Create a copy of MedicalRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MedicalRecordCopyWith<_MedicalRecord> get copyWith =>
      __$MedicalRecordCopyWithImpl<_MedicalRecord>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MedicalRecordToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MedicalRecord &&
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

  @override
  String toString() {
    return 'MedicalRecord(id: $id, personId: $personId, hospitalName: $hospitalName, notes: $notes, notedAt: $notedAt, visitEndDate: $visitEndDate, createdAt: $createdAt, updatedAt: $updatedAt, status: $status, tagsCache: $tagsCache, images: $images)';
  }
}

/// @nodoc
abstract mixin class _$MedicalRecordCopyWith<$Res>
    implements $MedicalRecordCopyWith<$Res> {
  factory _$MedicalRecordCopyWith(
          _MedicalRecord value, $Res Function(_MedicalRecord) _then) =
      __$MedicalRecordCopyWithImpl;
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
class __$MedicalRecordCopyWithImpl<$Res>
    implements _$MedicalRecordCopyWith<$Res> {
  __$MedicalRecordCopyWithImpl(this._self, this._then);

  final _MedicalRecord _self;
  final $Res Function(_MedicalRecord) _then;

  /// Create a copy of MedicalRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
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
    return _then(_MedicalRecord(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      personId: null == personId
          ? _self.personId
          : personId // ignore: cast_nullable_to_non_nullable
              as String,
      hospitalName: freezed == hospitalName
          ? _self.hospitalName
          : hospitalName // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      notedAt: null == notedAt
          ? _self.notedAt
          : notedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      visitEndDate: freezed == visitEndDate
          ? _self.visitEndDate
          : visitEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as RecordStatus,
      tagsCache: freezed == tagsCache
          ? _self.tagsCache
          : tagsCache // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _self._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<MedicalImage>,
    ));
  }
}

// dart format on
