// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'slm_data_block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SLMDataBlock {

 String get rawText; String? get normalizedText; double get confidence;/// Normalized coordinates [x, y, w, h] (0.0 - 1.0)
 List<double> get boundingBox; bool get isPIIMasked; String? get semanticLabel;
/// Create a copy of SLMDataBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SLMDataBlockCopyWith<SLMDataBlock> get copyWith => _$SLMDataBlockCopyWithImpl<SLMDataBlock>(this as SLMDataBlock, _$identity);

  /// Serializes this SLMDataBlock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SLMDataBlock&&(identical(other.rawText, rawText) || other.rawText == rawText)&&(identical(other.normalizedText, normalizedText) || other.normalizedText == normalizedText)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&const DeepCollectionEquality().equals(other.boundingBox, boundingBox)&&(identical(other.isPIIMasked, isPIIMasked) || other.isPIIMasked == isPIIMasked)&&(identical(other.semanticLabel, semanticLabel) || other.semanticLabel == semanticLabel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rawText,normalizedText,confidence,const DeepCollectionEquality().hash(boundingBox),isPIIMasked,semanticLabel);

@override
String toString() {
  return 'SLMDataBlock(rawText: $rawText, normalizedText: $normalizedText, confidence: $confidence, boundingBox: $boundingBox, isPIIMasked: $isPIIMasked, semanticLabel: $semanticLabel)';
}


}

/// @nodoc
abstract mixin class $SLMDataBlockCopyWith<$Res>  {
  factory $SLMDataBlockCopyWith(SLMDataBlock value, $Res Function(SLMDataBlock) _then) = _$SLMDataBlockCopyWithImpl;
@useResult
$Res call({
 String rawText, String? normalizedText, double confidence, List<double> boundingBox, bool isPIIMasked, String? semanticLabel
});




}
/// @nodoc
class _$SLMDataBlockCopyWithImpl<$Res>
    implements $SLMDataBlockCopyWith<$Res> {
  _$SLMDataBlockCopyWithImpl(this._self, this._then);

  final SLMDataBlock _self;
  final $Res Function(SLMDataBlock) _then;

/// Create a copy of SLMDataBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rawText = null,Object? normalizedText = freezed,Object? confidence = null,Object? boundingBox = null,Object? isPIIMasked = null,Object? semanticLabel = freezed,}) {
  return _then(_self.copyWith(
rawText: null == rawText ? _self.rawText : rawText // ignore: cast_nullable_to_non_nullable
as String,normalizedText: freezed == normalizedText ? _self.normalizedText : normalizedText // ignore: cast_nullable_to_non_nullable
as String?,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,boundingBox: null == boundingBox ? _self.boundingBox : boundingBox // ignore: cast_nullable_to_non_nullable
as List<double>,isPIIMasked: null == isPIIMasked ? _self.isPIIMasked : isPIIMasked // ignore: cast_nullable_to_non_nullable
as bool,semanticLabel: freezed == semanticLabel ? _self.semanticLabel : semanticLabel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SLMDataBlock].
extension SLMDataBlockPatterns on SLMDataBlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SLMDataBlock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SLMDataBlock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SLMDataBlock value)  $default,){
final _that = this;
switch (_that) {
case _SLMDataBlock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SLMDataBlock value)?  $default,){
final _that = this;
switch (_that) {
case _SLMDataBlock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String rawText,  String? normalizedText,  double confidence,  List<double> boundingBox,  bool isPIIMasked,  String? semanticLabel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SLMDataBlock() when $default != null:
return $default(_that.rawText,_that.normalizedText,_that.confidence,_that.boundingBox,_that.isPIIMasked,_that.semanticLabel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String rawText,  String? normalizedText,  double confidence,  List<double> boundingBox,  bool isPIIMasked,  String? semanticLabel)  $default,) {final _that = this;
switch (_that) {
case _SLMDataBlock():
return $default(_that.rawText,_that.normalizedText,_that.confidence,_that.boundingBox,_that.isPIIMasked,_that.semanticLabel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String rawText,  String? normalizedText,  double confidence,  List<double> boundingBox,  bool isPIIMasked,  String? semanticLabel)?  $default,) {final _that = this;
switch (_that) {
case _SLMDataBlock() when $default != null:
return $default(_that.rawText,_that.normalizedText,_that.confidence,_that.boundingBox,_that.isPIIMasked,_that.semanticLabel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SLMDataBlock implements SLMDataBlock {
  const _SLMDataBlock({required this.rawText, this.normalizedText, this.confidence = 1.0, final  List<double> boundingBox = const [0.0, 0.0, 0.0, 0.0], this.isPIIMasked = false, this.semanticLabel}): _boundingBox = boundingBox;
  factory _SLMDataBlock.fromJson(Map<String, dynamic> json) => _$SLMDataBlockFromJson(json);

@override final  String rawText;
@override final  String? normalizedText;
@override@JsonKey() final  double confidence;
/// Normalized coordinates [x, y, w, h] (0.0 - 1.0)
 final  List<double> _boundingBox;
/// Normalized coordinates [x, y, w, h] (0.0 - 1.0)
@override@JsonKey() List<double> get boundingBox {
  if (_boundingBox is EqualUnmodifiableListView) return _boundingBox;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_boundingBox);
}

@override@JsonKey() final  bool isPIIMasked;
@override final  String? semanticLabel;

/// Create a copy of SLMDataBlock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SLMDataBlockCopyWith<_SLMDataBlock> get copyWith => __$SLMDataBlockCopyWithImpl<_SLMDataBlock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SLMDataBlockToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SLMDataBlock&&(identical(other.rawText, rawText) || other.rawText == rawText)&&(identical(other.normalizedText, normalizedText) || other.normalizedText == normalizedText)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&const DeepCollectionEquality().equals(other._boundingBox, _boundingBox)&&(identical(other.isPIIMasked, isPIIMasked) || other.isPIIMasked == isPIIMasked)&&(identical(other.semanticLabel, semanticLabel) || other.semanticLabel == semanticLabel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rawText,normalizedText,confidence,const DeepCollectionEquality().hash(_boundingBox),isPIIMasked,semanticLabel);

@override
String toString() {
  return 'SLMDataBlock(rawText: $rawText, normalizedText: $normalizedText, confidence: $confidence, boundingBox: $boundingBox, isPIIMasked: $isPIIMasked, semanticLabel: $semanticLabel)';
}


}

/// @nodoc
abstract mixin class _$SLMDataBlockCopyWith<$Res> implements $SLMDataBlockCopyWith<$Res> {
  factory _$SLMDataBlockCopyWith(_SLMDataBlock value, $Res Function(_SLMDataBlock) _then) = __$SLMDataBlockCopyWithImpl;
@override @useResult
$Res call({
 String rawText, String? normalizedText, double confidence, List<double> boundingBox, bool isPIIMasked, String? semanticLabel
});




}
/// @nodoc
class __$SLMDataBlockCopyWithImpl<$Res>
    implements _$SLMDataBlockCopyWith<$Res> {
  __$SLMDataBlockCopyWithImpl(this._self, this._then);

  final _SLMDataBlock _self;
  final $Res Function(_SLMDataBlock) _then;

/// Create a copy of SLMDataBlock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rawText = null,Object? normalizedText = freezed,Object? confidence = null,Object? boundingBox = null,Object? isPIIMasked = null,Object? semanticLabel = freezed,}) {
  return _then(_SLMDataBlock(
rawText: null == rawText ? _self.rawText : rawText // ignore: cast_nullable_to_non_nullable
as String,normalizedText: freezed == normalizedText ? _self.normalizedText : normalizedText // ignore: cast_nullable_to_non_nullable
as String?,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,boundingBox: null == boundingBox ? _self._boundingBox : boundingBox // ignore: cast_nullable_to_non_nullable
as List<double>,isPIIMasked: null == isPIIMasked ? _self.isPIIMasked : isPIIMasked // ignore: cast_nullable_to_non_nullable
as bool,semanticLabel: freezed == semanticLabel ? _self.semanticLabel : semanticLabel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
