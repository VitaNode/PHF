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
mixin _$OCRTextElement {

 String get text;@JsonKey(readValue: _readX) double get x;@JsonKey(readValue: _readY) double get y;@JsonKey(readValue: _readW) double get w;@JsonKey(readValue: _readH) double get h; double get confidence;
/// Create a copy of OCRTextElement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OCRTextElementCopyWith<OCRTextElement> get copyWith => _$OCRTextElementCopyWithImpl<OCRTextElement>(this as OCRTextElement, _$identity);

  /// Serializes this OCRTextElement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OCRTextElement&&(identical(other.text, text) || other.text == text)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.w, w) || other.w == w)&&(identical(other.h, h) || other.h == h)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,x,y,w,h,confidence);

@override
String toString() {
  return 'OCRTextElement(text: $text, x: $x, y: $y, w: $w, h: $h, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class $OCRTextElementCopyWith<$Res>  {
  factory $OCRTextElementCopyWith(OCRTextElement value, $Res Function(OCRTextElement) _then) = _$OCRTextElementCopyWithImpl;
@useResult
$Res call({
 String text,@JsonKey(readValue: _readX) double x,@JsonKey(readValue: _readY) double y,@JsonKey(readValue: _readW) double w,@JsonKey(readValue: _readH) double h, double confidence
});




}
/// @nodoc
class _$OCRTextElementCopyWithImpl<$Res>
    implements $OCRTextElementCopyWith<$Res> {
  _$OCRTextElementCopyWithImpl(this._self, this._then);

  final OCRTextElement _self;
  final $Res Function(OCRTextElement) _then;

/// Create a copy of OCRTextElement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? x = null,Object? y = null,Object? w = null,Object? h = null,Object? confidence = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,w: null == w ? _self.w : w // ignore: cast_nullable_to_non_nullable
as double,h: null == h ? _self.h : h // ignore: cast_nullable_to_non_nullable
as double,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [OCRTextElement].
extension OCRTextElementPatterns on OCRTextElement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OCRTextElement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OCRTextElement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OCRTextElement value)  $default,){
final _that = this;
switch (_that) {
case _OCRTextElement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OCRTextElement value)?  $default,){
final _that = this;
switch (_that) {
case _OCRTextElement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text, @JsonKey(readValue: _readX)  double x, @JsonKey(readValue: _readY)  double y, @JsonKey(readValue: _readW)  double w, @JsonKey(readValue: _readH)  double h,  double confidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OCRTextElement() when $default != null:
return $default(_that.text,_that.x,_that.y,_that.w,_that.h,_that.confidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text, @JsonKey(readValue: _readX)  double x, @JsonKey(readValue: _readY)  double y, @JsonKey(readValue: _readW)  double w, @JsonKey(readValue: _readH)  double h,  double confidence)  $default,) {final _that = this;
switch (_that) {
case _OCRTextElement():
return $default(_that.text,_that.x,_that.y,_that.w,_that.h,_that.confidence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text, @JsonKey(readValue: _readX)  double x, @JsonKey(readValue: _readY)  double y, @JsonKey(readValue: _readW)  double w, @JsonKey(readValue: _readH)  double h,  double confidence)?  $default,) {final _that = this;
switch (_that) {
case _OCRTextElement() when $default != null:
return $default(_that.text,_that.x,_that.y,_that.w,_that.h,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OCRTextElement implements OCRTextElement {
  const _OCRTextElement({required this.text, @JsonKey(readValue: _readX) required this.x, @JsonKey(readValue: _readY) required this.y, @JsonKey(readValue: _readW) required this.w, @JsonKey(readValue: _readH) required this.h, this.confidence = 0.0});
  factory _OCRTextElement.fromJson(Map<String, dynamic> json) => _$OCRTextElementFromJson(json);

@override final  String text;
@override@JsonKey(readValue: _readX) final  double x;
@override@JsonKey(readValue: _readY) final  double y;
@override@JsonKey(readValue: _readW) final  double w;
@override@JsonKey(readValue: _readH) final  double h;
@override@JsonKey() final  double confidence;

/// Create a copy of OCRTextElement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OCRTextElementCopyWith<_OCRTextElement> get copyWith => __$OCRTextElementCopyWithImpl<_OCRTextElement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OCRTextElementToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OCRTextElement&&(identical(other.text, text) || other.text == text)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.w, w) || other.w == w)&&(identical(other.h, h) || other.h == h)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,x,y,w,h,confidence);

@override
String toString() {
  return 'OCRTextElement(text: $text, x: $x, y: $y, w: $w, h: $h, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$OCRTextElementCopyWith<$Res> implements $OCRTextElementCopyWith<$Res> {
  factory _$OCRTextElementCopyWith(_OCRTextElement value, $Res Function(_OCRTextElement) _then) = __$OCRTextElementCopyWithImpl;
@override @useResult
$Res call({
 String text,@JsonKey(readValue: _readX) double x,@JsonKey(readValue: _readY) double y,@JsonKey(readValue: _readW) double w,@JsonKey(readValue: _readH) double h, double confidence
});




}
/// @nodoc
class __$OCRTextElementCopyWithImpl<$Res>
    implements _$OCRTextElementCopyWith<$Res> {
  __$OCRTextElementCopyWithImpl(this._self, this._then);

  final _OCRTextElement _self;
  final $Res Function(_OCRTextElement) _then;

/// Create a copy of OCRTextElement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? x = null,Object? y = null,Object? w = null,Object? h = null,Object? confidence = null,}) {
  return _then(_OCRTextElement(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,w: null == w ? _self.w : w // ignore: cast_nullable_to_non_nullable
as double,h: null == h ? _self.h : h // ignore: cast_nullable_to_non_nullable
as double,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$OCRLine {

 String get text;@JsonKey(readValue: _readX) double get x;@JsonKey(readValue: _readY) double get y;@JsonKey(readValue: _readW) double get w;@JsonKey(readValue: _readH) double get h; List<OCRTextElement> get elements; double get confidence;
/// Create a copy of OCRLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OCRLineCopyWith<OCRLine> get copyWith => _$OCRLineCopyWithImpl<OCRLine>(this as OCRLine, _$identity);

  /// Serializes this OCRLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OCRLine&&(identical(other.text, text) || other.text == text)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.w, w) || other.w == w)&&(identical(other.h, h) || other.h == h)&&const DeepCollectionEquality().equals(other.elements, elements)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,x,y,w,h,const DeepCollectionEquality().hash(elements),confidence);

@override
String toString() {
  return 'OCRLine(text: $text, x: $x, y: $y, w: $w, h: $h, elements: $elements, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class $OCRLineCopyWith<$Res>  {
  factory $OCRLineCopyWith(OCRLine value, $Res Function(OCRLine) _then) = _$OCRLineCopyWithImpl;
@useResult
$Res call({
 String text,@JsonKey(readValue: _readX) double x,@JsonKey(readValue: _readY) double y,@JsonKey(readValue: _readW) double w,@JsonKey(readValue: _readH) double h, List<OCRTextElement> elements, double confidence
});




}
/// @nodoc
class _$OCRLineCopyWithImpl<$Res>
    implements $OCRLineCopyWith<$Res> {
  _$OCRLineCopyWithImpl(this._self, this._then);

  final OCRLine _self;
  final $Res Function(OCRLine) _then;

/// Create a copy of OCRLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? x = null,Object? y = null,Object? w = null,Object? h = null,Object? elements = null,Object? confidence = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,w: null == w ? _self.w : w // ignore: cast_nullable_to_non_nullable
as double,h: null == h ? _self.h : h // ignore: cast_nullable_to_non_nullable
as double,elements: null == elements ? _self.elements : elements // ignore: cast_nullable_to_non_nullable
as List<OCRTextElement>,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [OCRLine].
extension OCRLinePatterns on OCRLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OCRLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OCRLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OCRLine value)  $default,){
final _that = this;
switch (_that) {
case _OCRLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OCRLine value)?  $default,){
final _that = this;
switch (_that) {
case _OCRLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text, @JsonKey(readValue: _readX)  double x, @JsonKey(readValue: _readY)  double y, @JsonKey(readValue: _readW)  double w, @JsonKey(readValue: _readH)  double h,  List<OCRTextElement> elements,  double confidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OCRLine() when $default != null:
return $default(_that.text,_that.x,_that.y,_that.w,_that.h,_that.elements,_that.confidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text, @JsonKey(readValue: _readX)  double x, @JsonKey(readValue: _readY)  double y, @JsonKey(readValue: _readW)  double w, @JsonKey(readValue: _readH)  double h,  List<OCRTextElement> elements,  double confidence)  $default,) {final _that = this;
switch (_that) {
case _OCRLine():
return $default(_that.text,_that.x,_that.y,_that.w,_that.h,_that.elements,_that.confidence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text, @JsonKey(readValue: _readX)  double x, @JsonKey(readValue: _readY)  double y, @JsonKey(readValue: _readW)  double w, @JsonKey(readValue: _readH)  double h,  List<OCRTextElement> elements,  double confidence)?  $default,) {final _that = this;
switch (_that) {
case _OCRLine() when $default != null:
return $default(_that.text,_that.x,_that.y,_that.w,_that.h,_that.elements,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _OCRLine implements OCRLine {
  const _OCRLine({required this.text, @JsonKey(readValue: _readX) required this.x, @JsonKey(readValue: _readY) required this.y, @JsonKey(readValue: _readW) required this.w, @JsonKey(readValue: _readH) required this.h, final  List<OCRTextElement> elements = const [], this.confidence = 0.0}): _elements = elements;
  factory _OCRLine.fromJson(Map<String, dynamic> json) => _$OCRLineFromJson(json);

@override final  String text;
@override@JsonKey(readValue: _readX) final  double x;
@override@JsonKey(readValue: _readY) final  double y;
@override@JsonKey(readValue: _readW) final  double w;
@override@JsonKey(readValue: _readH) final  double h;
 final  List<OCRTextElement> _elements;
@override@JsonKey() List<OCRTextElement> get elements {
  if (_elements is EqualUnmodifiableListView) return _elements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_elements);
}

@override@JsonKey() final  double confidence;

/// Create a copy of OCRLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OCRLineCopyWith<_OCRLine> get copyWith => __$OCRLineCopyWithImpl<_OCRLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OCRLineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OCRLine&&(identical(other.text, text) || other.text == text)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.w, w) || other.w == w)&&(identical(other.h, h) || other.h == h)&&const DeepCollectionEquality().equals(other._elements, _elements)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,x,y,w,h,const DeepCollectionEquality().hash(_elements),confidence);

@override
String toString() {
  return 'OCRLine(text: $text, x: $x, y: $y, w: $w, h: $h, elements: $elements, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$OCRLineCopyWith<$Res> implements $OCRLineCopyWith<$Res> {
  factory _$OCRLineCopyWith(_OCRLine value, $Res Function(_OCRLine) _then) = __$OCRLineCopyWithImpl;
@override @useResult
$Res call({
 String text,@JsonKey(readValue: _readX) double x,@JsonKey(readValue: _readY) double y,@JsonKey(readValue: _readW) double w,@JsonKey(readValue: _readH) double h, List<OCRTextElement> elements, double confidence
});




}
/// @nodoc
class __$OCRLineCopyWithImpl<$Res>
    implements _$OCRLineCopyWith<$Res> {
  __$OCRLineCopyWithImpl(this._self, this._then);

  final _OCRLine _self;
  final $Res Function(_OCRLine) _then;

/// Create a copy of OCRLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? x = null,Object? y = null,Object? w = null,Object? h = null,Object? elements = null,Object? confidence = null,}) {
  return _then(_OCRLine(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,w: null == w ? _self.w : w // ignore: cast_nullable_to_non_nullable
as double,h: null == h ? _self.h : h // ignore: cast_nullable_to_non_nullable
as double,elements: null == elements ? _self._elements : elements // ignore: cast_nullable_to_non_nullable
as List<OCRTextElement>,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$OCRBlock {

 String get text;@JsonKey(readValue: _readX) double get x;@JsonKey(readValue: _readY) double get y;@JsonKey(readValue: _readW) double get w;@JsonKey(readValue: _readH) double get h; List<OCRLine> get lines;
/// Create a copy of OCRBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OCRBlockCopyWith<OCRBlock> get copyWith => _$OCRBlockCopyWithImpl<OCRBlock>(this as OCRBlock, _$identity);

  /// Serializes this OCRBlock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OCRBlock&&(identical(other.text, text) || other.text == text)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.w, w) || other.w == w)&&(identical(other.h, h) || other.h == h)&&const DeepCollectionEquality().equals(other.lines, lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,x,y,w,h,const DeepCollectionEquality().hash(lines));

@override
String toString() {
  return 'OCRBlock(text: $text, x: $x, y: $y, w: $w, h: $h, lines: $lines)';
}


}

/// @nodoc
abstract mixin class $OCRBlockCopyWith<$Res>  {
  factory $OCRBlockCopyWith(OCRBlock value, $Res Function(OCRBlock) _then) = _$OCRBlockCopyWithImpl;
@useResult
$Res call({
 String text,@JsonKey(readValue: _readX) double x,@JsonKey(readValue: _readY) double y,@JsonKey(readValue: _readW) double w,@JsonKey(readValue: _readH) double h, List<OCRLine> lines
});




}
/// @nodoc
class _$OCRBlockCopyWithImpl<$Res>
    implements $OCRBlockCopyWith<$Res> {
  _$OCRBlockCopyWithImpl(this._self, this._then);

  final OCRBlock _self;
  final $Res Function(OCRBlock) _then;

/// Create a copy of OCRBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? x = null,Object? y = null,Object? w = null,Object? h = null,Object? lines = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,w: null == w ? _self.w : w // ignore: cast_nullable_to_non_nullable
as double,h: null == h ? _self.h : h // ignore: cast_nullable_to_non_nullable
as double,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<OCRLine>,
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OCRBlock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OCRBlock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OCRBlock value)  $default,){
final _that = this;
switch (_that) {
case _OCRBlock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OCRBlock value)?  $default,){
final _that = this;
switch (_that) {
case _OCRBlock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text, @JsonKey(readValue: _readX)  double x, @JsonKey(readValue: _readY)  double y, @JsonKey(readValue: _readW)  double w, @JsonKey(readValue: _readH)  double h,  List<OCRLine> lines)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OCRBlock() when $default != null:
return $default(_that.text,_that.x,_that.y,_that.w,_that.h,_that.lines);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text, @JsonKey(readValue: _readX)  double x, @JsonKey(readValue: _readY)  double y, @JsonKey(readValue: _readW)  double w, @JsonKey(readValue: _readH)  double h,  List<OCRLine> lines)  $default,) {final _that = this;
switch (_that) {
case _OCRBlock():
return $default(_that.text,_that.x,_that.y,_that.w,_that.h,_that.lines);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text, @JsonKey(readValue: _readX)  double x, @JsonKey(readValue: _readY)  double y, @JsonKey(readValue: _readW)  double w, @JsonKey(readValue: _readH)  double h,  List<OCRLine> lines)?  $default,) {final _that = this;
switch (_that) {
case _OCRBlock() when $default != null:
return $default(_that.text,_that.x,_that.y,_that.w,_that.h,_that.lines);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _OCRBlock implements OCRBlock {
  const _OCRBlock({required this.text, @JsonKey(readValue: _readX) required this.x, @JsonKey(readValue: _readY) required this.y, @JsonKey(readValue: _readW) required this.w, @JsonKey(readValue: _readH) required this.h, final  List<OCRLine> lines = const []}): _lines = lines;
  factory _OCRBlock.fromJson(Map<String, dynamic> json) => _$OCRBlockFromJson(json);

@override final  String text;
@override@JsonKey(readValue: _readX) final  double x;
@override@JsonKey(readValue: _readY) final  double y;
@override@JsonKey(readValue: _readW) final  double w;
@override@JsonKey(readValue: _readH) final  double h;
 final  List<OCRLine> _lines;
@override@JsonKey() List<OCRLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}


/// Create a copy of OCRBlock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OCRBlockCopyWith<_OCRBlock> get copyWith => __$OCRBlockCopyWithImpl<_OCRBlock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OCRBlockToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OCRBlock&&(identical(other.text, text) || other.text == text)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.w, w) || other.w == w)&&(identical(other.h, h) || other.h == h)&&const DeepCollectionEquality().equals(other._lines, _lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,x,y,w,h,const DeepCollectionEquality().hash(_lines));

@override
String toString() {
  return 'OCRBlock(text: $text, x: $x, y: $y, w: $w, h: $h, lines: $lines)';
}


}

/// @nodoc
abstract mixin class _$OCRBlockCopyWith<$Res> implements $OCRBlockCopyWith<$Res> {
  factory _$OCRBlockCopyWith(_OCRBlock value, $Res Function(_OCRBlock) _then) = __$OCRBlockCopyWithImpl;
@override @useResult
$Res call({
 String text,@JsonKey(readValue: _readX) double x,@JsonKey(readValue: _readY) double y,@JsonKey(readValue: _readW) double w,@JsonKey(readValue: _readH) double h, List<OCRLine> lines
});




}
/// @nodoc
class __$OCRBlockCopyWithImpl<$Res>
    implements _$OCRBlockCopyWith<$Res> {
  __$OCRBlockCopyWithImpl(this._self, this._then);

  final _OCRBlock _self;
  final $Res Function(_OCRBlock) _then;

/// Create a copy of OCRBlock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? x = null,Object? y = null,Object? w = null,Object? h = null,Object? lines = null,}) {
  return _then(_OCRBlock(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,w: null == w ? _self.w : w // ignore: cast_nullable_to_non_nullable
as double,h: null == h ? _self.h : h // ignore: cast_nullable_to_non_nullable
as double,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<OCRLine>,
  ));
}


}


/// @nodoc
mixin _$OCRResult {

 String get text; List<OCRBlock> get blocks; double get confidence;// Metadata (V2)
 String get source;// e.g., 'ios_vision', 'google_mlkit'
 String get language; DateTime? get timestamp; int get version;
/// Create a copy of OCRResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OCRResultCopyWith<OCRResult> get copyWith => _$OCRResultCopyWithImpl<OCRResult>(this as OCRResult, _$identity);

  /// Serializes this OCRResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OCRResult&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other.blocks, blocks)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.source, source) || other.source == source)&&(identical(other.language, language) || other.language == language)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,const DeepCollectionEquality().hash(blocks),confidence,source,language,timestamp,version);

@override
String toString() {
  return 'OCRResult(text: $text, blocks: $blocks, confidence: $confidence, source: $source, language: $language, timestamp: $timestamp, version: $version)';
}


}

/// @nodoc
abstract mixin class $OCRResultCopyWith<$Res>  {
  factory $OCRResultCopyWith(OCRResult value, $Res Function(OCRResult) _then) = _$OCRResultCopyWithImpl;
@useResult
$Res call({
 String text, List<OCRBlock> blocks, double confidence, String source, String language, DateTime? timestamp, int version
});




}
/// @nodoc
class _$OCRResultCopyWithImpl<$Res>
    implements $OCRResultCopyWith<$Res> {
  _$OCRResultCopyWithImpl(this._self, this._then);

  final OCRResult _self;
  final $Res Function(OCRResult) _then;

/// Create a copy of OCRResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? blocks = null,Object? confidence = null,Object? source = null,Object? language = null,Object? timestamp = freezed,Object? version = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,blocks: null == blocks ? _self.blocks : blocks // ignore: cast_nullable_to_non_nullable
as List<OCRBlock>,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OCRResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OCRResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OCRResult value)  $default,){
final _that = this;
switch (_that) {
case _OCRResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OCRResult value)?  $default,){
final _that = this;
switch (_that) {
case _OCRResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  List<OCRBlock> blocks,  double confidence,  String source,  String language,  DateTime? timestamp,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OCRResult() when $default != null:
return $default(_that.text,_that.blocks,_that.confidence,_that.source,_that.language,_that.timestamp,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  List<OCRBlock> blocks,  double confidence,  String source,  String language,  DateTime? timestamp,  int version)  $default,) {final _that = this;
switch (_that) {
case _OCRResult():
return $default(_that.text,_that.blocks,_that.confidence,_that.source,_that.language,_that.timestamp,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  List<OCRBlock> blocks,  double confidence,  String source,  String language,  DateTime? timestamp,  int version)?  $default,) {final _that = this;
switch (_that) {
case _OCRResult() when $default != null:
return $default(_that.text,_that.blocks,_that.confidence,_that.source,_that.language,_that.timestamp,_that.version);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _OCRResult implements OCRResult {
  const _OCRResult({required this.text, final  List<OCRBlock> blocks = const [], this.confidence = 0.0, this.source = 'unknown', this.language = 'auto', this.timestamp, this.version = 1}): _blocks = blocks;
  factory _OCRResult.fromJson(Map<String, dynamic> json) => _$OCRResultFromJson(json);

@override final  String text;
 final  List<OCRBlock> _blocks;
@override@JsonKey() List<OCRBlock> get blocks {
  if (_blocks is EqualUnmodifiableListView) return _blocks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_blocks);
}

@override@JsonKey() final  double confidence;
// Metadata (V2)
@override@JsonKey() final  String source;
// e.g., 'ios_vision', 'google_mlkit'
@override@JsonKey() final  String language;
@override final  DateTime? timestamp;
@override@JsonKey() final  int version;

/// Create a copy of OCRResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OCRResultCopyWith<_OCRResult> get copyWith => __$OCRResultCopyWithImpl<_OCRResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OCRResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OCRResult&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other._blocks, _blocks)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.source, source) || other.source == source)&&(identical(other.language, language) || other.language == language)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,const DeepCollectionEquality().hash(_blocks),confidence,source,language,timestamp,version);

@override
String toString() {
  return 'OCRResult(text: $text, blocks: $blocks, confidence: $confidence, source: $source, language: $language, timestamp: $timestamp, version: $version)';
}


}

/// @nodoc
abstract mixin class _$OCRResultCopyWith<$Res> implements $OCRResultCopyWith<$Res> {
  factory _$OCRResultCopyWith(_OCRResult value, $Res Function(_OCRResult) _then) = __$OCRResultCopyWithImpl;
@override @useResult
$Res call({
 String text, List<OCRBlock> blocks, double confidence, String source, String language, DateTime? timestamp, int version
});




}
/// @nodoc
class __$OCRResultCopyWithImpl<$Res>
    implements _$OCRResultCopyWith<$Res> {
  __$OCRResultCopyWithImpl(this._self, this._then);

  final _OCRResult _self;
  final $Res Function(_OCRResult) _then;

/// Create a copy of OCRResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? blocks = null,Object? confidence = null,Object? source = null,Object? language = null,Object? timestamp = freezed,Object? version = null,}) {
  return _then(_OCRResult(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,blocks: null == blocks ? _self._blocks : blocks // ignore: cast_nullable_to_non_nullable
as List<OCRBlock>,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
