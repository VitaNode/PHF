// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ocr_queue_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OCRQueueItem {
  String get id;
  String get imageId;
  OCRJobStatus get status;
  int get retryCount;
  String? get lastError;
  DateTime get createdAt;
  DateTime get updatedAt;

  /// Create a copy of OCRQueueItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OCRQueueItemCopyWith<OCRQueueItem> get copyWith =>
      _$OCRQueueItemCopyWithImpl<OCRQueueItem>(
          this as OCRQueueItem, _$identity);

  /// Serializes this OCRQueueItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OCRQueueItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.imageId, imageId) || other.imageId == imageId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.retryCount, retryCount) ||
                other.retryCount == retryCount) &&
            (identical(other.lastError, lastError) ||
                other.lastError == lastError) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, imageId, status, retryCount,
      lastError, createdAt, updatedAt);

  @override
  String toString() {
    return 'OCRQueueItem(id: $id, imageId: $imageId, status: $status, retryCount: $retryCount, lastError: $lastError, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $OCRQueueItemCopyWith<$Res> {
  factory $OCRQueueItemCopyWith(
          OCRQueueItem value, $Res Function(OCRQueueItem) _then) =
      _$OCRQueueItemCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String imageId,
      OCRJobStatus status,
      int retryCount,
      String? lastError,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$OCRQueueItemCopyWithImpl<$Res> implements $OCRQueueItemCopyWith<$Res> {
  _$OCRQueueItemCopyWithImpl(this._self, this._then);

  final OCRQueueItem _self;
  final $Res Function(OCRQueueItem) _then;

  /// Create a copy of OCRQueueItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageId = null,
    Object? status = null,
    Object? retryCount = null,
    Object? lastError = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      imageId: null == imageId
          ? _self.imageId
          : imageId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as OCRJobStatus,
      retryCount: null == retryCount
          ? _self.retryCount
          : retryCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastError: freezed == lastError
          ? _self.lastError
          : lastError // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [OCRQueueItem].
extension OCRQueueItemPatterns on OCRQueueItem {
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
    TResult Function(_OCRQueueItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OCRQueueItem() when $default != null:
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
    TResult Function(_OCRQueueItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OCRQueueItem():
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
    TResult? Function(_OCRQueueItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OCRQueueItem() when $default != null:
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
            String imageId,
            OCRJobStatus status,
            int retryCount,
            String? lastError,
            DateTime createdAt,
            DateTime updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OCRQueueItem() when $default != null:
        return $default(_that.id, _that.imageId, _that.status, _that.retryCount,
            _that.lastError, _that.createdAt, _that.updatedAt);
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
            String imageId,
            OCRJobStatus status,
            int retryCount,
            String? lastError,
            DateTime createdAt,
            DateTime updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OCRQueueItem():
        return $default(_that.id, _that.imageId, _that.status, _that.retryCount,
            _that.lastError, _that.createdAt, _that.updatedAt);
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
            String imageId,
            OCRJobStatus status,
            int retryCount,
            String? lastError,
            DateTime createdAt,
            DateTime updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OCRQueueItem() when $default != null:
        return $default(_that.id, _that.imageId, _that.status, _that.retryCount,
            _that.lastError, _that.createdAt, _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _OCRQueueItem implements OCRQueueItem {
  const _OCRQueueItem(
      {required this.id,
      required this.imageId,
      this.status = OCRJobStatus.pending,
      this.retryCount = 0,
      this.lastError,
      required this.createdAt,
      required this.updatedAt});
  factory _OCRQueueItem.fromJson(Map<String, dynamic> json) =>
      _$OCRQueueItemFromJson(json);

  @override
  final String id;
  @override
  final String imageId;
  @override
  @JsonKey()
  final OCRJobStatus status;
  @override
  @JsonKey()
  final int retryCount;
  @override
  final String? lastError;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  /// Create a copy of OCRQueueItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OCRQueueItemCopyWith<_OCRQueueItem> get copyWith =>
      __$OCRQueueItemCopyWithImpl<_OCRQueueItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OCRQueueItemToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OCRQueueItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.imageId, imageId) || other.imageId == imageId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.retryCount, retryCount) ||
                other.retryCount == retryCount) &&
            (identical(other.lastError, lastError) ||
                other.lastError == lastError) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, imageId, status, retryCount,
      lastError, createdAt, updatedAt);

  @override
  String toString() {
    return 'OCRQueueItem(id: $id, imageId: $imageId, status: $status, retryCount: $retryCount, lastError: $lastError, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$OCRQueueItemCopyWith<$Res>
    implements $OCRQueueItemCopyWith<$Res> {
  factory _$OCRQueueItemCopyWith(
          _OCRQueueItem value, $Res Function(_OCRQueueItem) _then) =
      __$OCRQueueItemCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String imageId,
      OCRJobStatus status,
      int retryCount,
      String? lastError,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$OCRQueueItemCopyWithImpl<$Res>
    implements _$OCRQueueItemCopyWith<$Res> {
  __$OCRQueueItemCopyWithImpl(this._self, this._then);

  final _OCRQueueItem _self;
  final $Res Function(_OCRQueueItem) _then;

  /// Create a copy of OCRQueueItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? imageId = null,
    Object? status = null,
    Object? retryCount = null,
    Object? lastError = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_OCRQueueItem(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      imageId: null == imageId
          ? _self.imageId
          : imageId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as OCRJobStatus,
      retryCount: null == retryCount
          ? _self.retryCount
          : retryCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastError: freezed == lastError
          ? _self.lastError
          : lastError // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
