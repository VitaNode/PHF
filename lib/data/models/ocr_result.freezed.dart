// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ocr_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OCRBlock {
  String get text;
  double get left;
  double get top;
  double get width;
  double get height;

  /// Create a copy of OCRBlock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OCRBlockCopyWith<OCRBlock> get copyWith =>
      _$OCRBlockCopyWithImpl<OCRBlock>(this as OCRBlock, _$identity);

  /// Serializes this OCRBlock to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OCRBlock &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.left, left) || other.left == left) &&
            (identical(other.top, top) || other.top == top) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, text, left, top, width, height);

  @override
  String toString() {
    return 'OCRBlock(text: $text, left: $left, top: $top, width: $width, height: $height)';
  }
}

/// @nodoc
abstract mixin class $OCRBlockCopyWith<$Res> {
  factory $OCRBlockCopyWith(OCRBlock value, $Res Function(OCRBlock) _then) =
      _$OCRBlockCopyWithImpl;
  @useResult
  $Res call(
      {String text, double left, double top, double width, double height});
}

/// @nodoc
class _$OCRBlockCopyWithImpl<$Res> implements $OCRBlockCopyWith<$Res> {
  _$OCRBlockCopyWithImpl(this._self, this._then);

  final OCRBlock _self;
  final $Res Function(OCRBlock) _then;

  /// Create a copy of OCRBlock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? left = null,
    Object? top = null,
    Object? width = null,
    Object? height = null,
  }) {
    return _then(_self.copyWith(
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      left: null == left
          ? _self.left
          : left // ignore: cast_nullable_to_non_nullable
              as double,
      top: null == top
          ? _self.top
          : top // ignore: cast_nullable_to_non_nullable
              as double,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [OCRBlock].
extension OCRBlockPatterns on OCRBlock {
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
    TResult Function(_OCRBlock value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OCRBlock() when $default != null:
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
    TResult Function(_OCRBlock value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OCRBlock():
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
    TResult? Function(_OCRBlock value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OCRBlock() when $default != null:
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
            String text, double left, double top, double width, double height)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OCRBlock() when $default != null:
        return $default(
            _that.text, _that.left, _that.top, _that.width, _that.height);
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
            String text, double left, double top, double width, double height)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OCRBlock():
        return $default(
            _that.text, _that.left, _that.top, _that.width, _that.height);
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
            String text, double left, double top, double width, double height)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OCRBlock() when $default != null:
        return $default(
            _that.text, _that.left, _that.top, _that.width, _that.height);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _OCRBlock implements OCRBlock {
  const _OCRBlock(
      {required this.text,
      required this.left,
      required this.top,
      required this.width,
      required this.height});
  factory _OCRBlock.fromJson(Map<String, dynamic> json) =>
      _$OCRBlockFromJson(json);

  @override
  final String text;
  @override
  final double left;
  @override
  final double top;
  @override
  final double width;
  @override
  final double height;

  /// Create a copy of OCRBlock
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OCRBlockCopyWith<_OCRBlock> get copyWith =>
      __$OCRBlockCopyWithImpl<_OCRBlock>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OCRBlockToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OCRBlock &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.left, left) || other.left == left) &&
            (identical(other.top, top) || other.top == top) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, text, left, top, width, height);

  @override
  String toString() {
    return 'OCRBlock(text: $text, left: $left, top: $top, width: $width, height: $height)';
  }
}

/// @nodoc
abstract mixin class _$OCRBlockCopyWith<$Res>
    implements $OCRBlockCopyWith<$Res> {
  factory _$OCRBlockCopyWith(_OCRBlock value, $Res Function(_OCRBlock) _then) =
      __$OCRBlockCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String text, double left, double top, double width, double height});
}

/// @nodoc
class __$OCRBlockCopyWithImpl<$Res> implements _$OCRBlockCopyWith<$Res> {
  __$OCRBlockCopyWithImpl(this._self, this._then);

  final _OCRBlock _self;
  final $Res Function(_OCRBlock) _then;

  /// Create a copy of OCRBlock
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? text = null,
    Object? left = null,
    Object? top = null,
    Object? width = null,
    Object? height = null,
  }) {
    return _then(_OCRBlock(
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      left: null == left
          ? _self.left
          : left // ignore: cast_nullable_to_non_nullable
              as double,
      top: null == top
          ? _self.top
          : top // ignore: cast_nullable_to_non_nullable
              as double,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
mixin _$OCRResult {
  String get text;
  List<OCRBlock> get blocks;
  double get confidence;

  /// Create a copy of OCRResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OCRResultCopyWith<OCRResult> get copyWith =>
      _$OCRResultCopyWithImpl<OCRResult>(this as OCRResult, _$identity);

  /// Serializes this OCRResult to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OCRResult &&
            (identical(other.text, text) || other.text == text) &&
            const DeepCollectionEquality().equals(other.blocks, blocks) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, text,
      const DeepCollectionEquality().hash(blocks), confidence);

  @override
  String toString() {
    return 'OCRResult(text: $text, blocks: $blocks, confidence: $confidence)';
  }
}

/// @nodoc
abstract mixin class $OCRResultCopyWith<$Res> {
  factory $OCRResultCopyWith(OCRResult value, $Res Function(OCRResult) _then) =
      _$OCRResultCopyWithImpl;
  @useResult
  $Res call({String text, List<OCRBlock> blocks, double confidence});
}

/// @nodoc
class _$OCRResultCopyWithImpl<$Res> implements $OCRResultCopyWith<$Res> {
  _$OCRResultCopyWithImpl(this._self, this._then);

  final OCRResult _self;
  final $Res Function(OCRResult) _then;

  /// Create a copy of OCRResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? blocks = null,
    Object? confidence = null,
  }) {
    return _then(_self.copyWith(
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      blocks: null == blocks
          ? _self.blocks
          : blocks // ignore: cast_nullable_to_non_nullable
              as List<OCRBlock>,
      confidence: null == confidence
          ? _self.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [OCRResult].
extension OCRResultPatterns on OCRResult {
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
    TResult Function(_OCRResult value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OCRResult() when $default != null:
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
    TResult Function(_OCRResult value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OCRResult():
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
    TResult? Function(_OCRResult value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OCRResult() when $default != null:
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
    TResult Function(String text, List<OCRBlock> blocks, double confidence)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OCRResult() when $default != null:
        return $default(_that.text, _that.blocks, _that.confidence);
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
    TResult Function(String text, List<OCRBlock> blocks, double confidence)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OCRResult():
        return $default(_that.text, _that.blocks, _that.confidence);
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
    TResult? Function(String text, List<OCRBlock> blocks, double confidence)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OCRResult() when $default != null:
        return $default(_that.text, _that.blocks, _that.confidence);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _OCRResult implements OCRResult {
  const _OCRResult(
      {required this.text,
      final List<OCRBlock> blocks = const [],
      this.confidence = 0.0})
      : _blocks = blocks;
  factory _OCRResult.fromJson(Map<String, dynamic> json) =>
      _$OCRResultFromJson(json);

  @override
  final String text;
  final List<OCRBlock> _blocks;
  @override
  @JsonKey()
  List<OCRBlock> get blocks {
    if (_blocks is EqualUnmodifiableListView) return _blocks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_blocks);
  }

  @override
  @JsonKey()
  final double confidence;

  /// Create a copy of OCRResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OCRResultCopyWith<_OCRResult> get copyWith =>
      __$OCRResultCopyWithImpl<_OCRResult>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OCRResultToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OCRResult &&
            (identical(other.text, text) || other.text == text) &&
            const DeepCollectionEquality().equals(other._blocks, _blocks) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, text,
      const DeepCollectionEquality().hash(_blocks), confidence);

  @override
  String toString() {
    return 'OCRResult(text: $text, blocks: $blocks, confidence: $confidence)';
  }
}

/// @nodoc
abstract mixin class _$OCRResultCopyWith<$Res>
    implements $OCRResultCopyWith<$Res> {
  factory _$OCRResultCopyWith(
          _OCRResult value, $Res Function(_OCRResult) _then) =
      __$OCRResultCopyWithImpl;
  @override
  @useResult
  $Res call({String text, List<OCRBlock> blocks, double confidence});
}

/// @nodoc
class __$OCRResultCopyWithImpl<$Res> implements _$OCRResultCopyWith<$Res> {
  __$OCRResultCopyWithImpl(this._self, this._then);

  final _OCRResult _self;
  final $Res Function(_OCRResult) _then;

  /// Create a copy of OCRResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? text = null,
    Object? blocks = null,
    Object? confidence = null,
  }) {
    return _then(_OCRResult(
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      blocks: null == blocks
          ? _self._blocks
          : blocks // ignore: cast_nullable_to_non_nullable
              as List<OCRBlock>,
      confidence: null == confidence
          ? _self.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
