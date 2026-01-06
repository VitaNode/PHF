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
mixin _$OcrElement {

 String get text;@JsonKey(readValue: _readX) double get x;@JsonKey(readValue: _readY) double get y;@JsonKey(readValue: _readW) double get w;@JsonKey(readValue: _readH) double get h; double get confidence; OcrSemanticType get type;
/// Create a copy of OcrElement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OcrElementCopyWith<OcrElement> get copyWith => _$OcrElementCopyWithImpl<OcrElement>(this as OcrElement, _$identity);

  /// Serializes this OcrElement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OcrElement&&(identical(other.text, text) || other.text == text)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.w, w) || other.w == w)&&(identical(other.h, h) || other.h == h)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,x,y,w,h,confidence,type);

@override
String toString() {
  return 'OcrElement(text: $text, x: $x, y: $y, w: $w, h: $h, confidence: $confidence, type: $type)';
}


}

/// @nodoc
abstract mixin class $OcrElementCopyWith<$Res>  {
  factory $OcrElementCopyWith(OcrElement value, $Res Function(OcrElement) _then) = _$OcrElementCopyWithImpl;
@useResult
$Res call({
 String text,@JsonKey(readValue: _readX) double x,@JsonKey(readValue: _readY) double y,@JsonKey(readValue: _readW) double w,@JsonKey(readValue: _readH) double h, double confidence, OcrSemanticType type
});




}
/// @nodoc
class _$OcrElementCopyWithImpl<$Res>
    implements $OcrElementCopyWith<$Res> {
  _$OcrElementCopyWithImpl(this._self, this._then);

  final OcrElement _self;
  final $Res Function(OcrElement) _then;

/// Create a copy of OcrElement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? x = null,Object? y = null,Object? w = null,Object? h = null,Object? confidence = null,Object? type = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,w: null == w ? _self.w : w // ignore: cast_nullable_to_non_nullable
as double,h: null == h ? _self.h : h // ignore: cast_nullable_to_non_nullable
as double,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as OcrSemanticType,
  ));
}

}


/// Adds pattern-matching-related methods to [OcrElement].
extension OcrElementPatterns on OcrElement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OcrElement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OcrElement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OcrElement value)  $default,){
final _that = this;
switch (_that) {
case _OcrElement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OcrElement value)?  $default,){
final _that = this;
switch (_that) {
case _OcrElement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text, @JsonKey(readValue: _readX)  double x, @JsonKey(readValue: _readY)  double y, @JsonKey(readValue: _readW)  double w, @JsonKey(readValue: _readH)  double h,  double confidence,  OcrSemanticType type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OcrElement() when $default != null:
return $default(_that.text,_that.x,_that.y,_that.w,_that.h,_that.confidence,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text, @JsonKey(readValue: _readX)  double x, @JsonKey(readValue: _readY)  double y, @JsonKey(readValue: _readW)  double w, @JsonKey(readValue: _readH)  double h,  double confidence,  OcrSemanticType type)  $default,) {final _that = this;
switch (_that) {
case _OcrElement():
return $default(_that.text,_that.x,_that.y,_that.w,_that.h,_that.confidence,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text, @JsonKey(readValue: _readX)  double x, @JsonKey(readValue: _readY)  double y, @JsonKey(readValue: _readW)  double w, @JsonKey(readValue: _readH)  double h,  double confidence,  OcrSemanticType type)?  $default,) {final _that = this;
switch (_that) {
case _OcrElement() when $default != null:
return $default(_that.text,_that.x,_that.y,_that.w,_that.h,_that.confidence,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OcrElement implements OcrElement {
  const _OcrElement({required this.text, @JsonKey(readValue: _readX) required this.x, @JsonKey(readValue: _readY) required this.y, @JsonKey(readValue: _readW) required this.w, @JsonKey(readValue: _readH) required this.h, this.confidence = 0.0, this.type = OcrSemanticType.normal});
  factory _OcrElement.fromJson(Map<String, dynamic> json) => _$OcrElementFromJson(json);

@override final  String text;
@override@JsonKey(readValue: _readX) final  double x;
@override@JsonKey(readValue: _readY) final  double y;
@override@JsonKey(readValue: _readW) final  double w;
@override@JsonKey(readValue: _readH) final  double h;
@override@JsonKey() final  double confidence;
@override@JsonKey() final  OcrSemanticType type;

/// Create a copy of OcrElement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OcrElementCopyWith<_OcrElement> get copyWith => __$OcrElementCopyWithImpl<_OcrElement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OcrElementToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OcrElement&&(identical(other.text, text) || other.text == text)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.w, w) || other.w == w)&&(identical(other.h, h) || other.h == h)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,x,y,w,h,confidence,type);

@override
String toString() {
  return 'OcrElement(text: $text, x: $x, y: $y, w: $w, h: $h, confidence: $confidence, type: $type)';
}


}

/// @nodoc
abstract mixin class _$OcrElementCopyWith<$Res> implements $OcrElementCopyWith<$Res> {
  factory _$OcrElementCopyWith(_OcrElement value, $Res Function(_OcrElement) _then) = __$OcrElementCopyWithImpl;
@override @useResult
$Res call({
 String text,@JsonKey(readValue: _readX) double x,@JsonKey(readValue: _readY) double y,@JsonKey(readValue: _readW) double w,@JsonKey(readValue: _readH) double h, double confidence, OcrSemanticType type
});




}
/// @nodoc
class __$OcrElementCopyWithImpl<$Res>
    implements _$OcrElementCopyWith<$Res> {
  __$OcrElementCopyWithImpl(this._self, this._then);

  final _OcrElement _self;
  final $Res Function(_OcrElement) _then;

/// Create a copy of OcrElement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? x = null,Object? y = null,Object? w = null,Object? h = null,Object? confidence = null,Object? type = null,}) {
  return _then(_OcrElement(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,w: null == w ? _self.w : w // ignore: cast_nullable_to_non_nullable
as double,h: null == h ? _self.h : h // ignore: cast_nullable_to_non_nullable
as double,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as OcrSemanticType,
  ));
}


}


/// @nodoc
mixin _$OcrLine {

 String get text;@JsonKey(readValue: _readX) double get x;@JsonKey(readValue: _readY) double get y;@JsonKey(readValue: _readW) double get w;@JsonKey(readValue: _readH) double get h; List<OcrElement> get elements; double get confidence; OcrSemanticType get type;
/// Create a copy of OcrLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OcrLineCopyWith<OcrLine> get copyWith => _$OcrLineCopyWithImpl<OcrLine>(this as OcrLine, _$identity);

  /// Serializes this OcrLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OcrLine&&(identical(other.text, text) || other.text == text)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.w, w) || other.w == w)&&(identical(other.h, h) || other.h == h)&&const DeepCollectionEquality().equals(other.elements, elements)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,x,y,w,h,const DeepCollectionEquality().hash(elements),confidence,type);

@override
String toString() {
  return 'OcrLine(text: $text, x: $x, y: $y, w: $w, h: $h, elements: $elements, confidence: $confidence, type: $type)';
}


}

/// @nodoc
abstract mixin class $OcrLineCopyWith<$Res>  {
  factory $OcrLineCopyWith(OcrLine value, $Res Function(OcrLine) _then) = _$OcrLineCopyWithImpl;
@useResult
$Res call({
 String text,@JsonKey(readValue: _readX) double x,@JsonKey(readValue: _readY) double y,@JsonKey(readValue: _readW) double w,@JsonKey(readValue: _readH) double h, List<OcrElement> elements, double confidence, OcrSemanticType type
});




}
/// @nodoc
class _$OcrLineCopyWithImpl<$Res>
    implements $OcrLineCopyWith<$Res> {
  _$OcrLineCopyWithImpl(this._self, this._then);

  final OcrLine _self;
  final $Res Function(OcrLine) _then;

/// Create a copy of OcrLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? x = null,Object? y = null,Object? w = null,Object? h = null,Object? elements = null,Object? confidence = null,Object? type = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,w: null == w ? _self.w : w // ignore: cast_nullable_to_non_nullable
as double,h: null == h ? _self.h : h // ignore: cast_nullable_to_non_nullable
as double,elements: null == elements ? _self.elements : elements // ignore: cast_nullable_to_non_nullable
as List<OcrElement>,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as OcrSemanticType,
  ));
}

}


/// Adds pattern-matching-related methods to [OcrLine].
extension OcrLinePatterns on OcrLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OcrLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OcrLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OcrLine value)  $default,){
final _that = this;
switch (_that) {
case _OcrLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OcrLine value)?  $default,){
final _that = this;
switch (_that) {
case _OcrLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text, @JsonKey(readValue: _readX)  double x, @JsonKey(readValue: _readY)  double y, @JsonKey(readValue: _readW)  double w, @JsonKey(readValue: _readH)  double h,  List<OcrElement> elements,  double confidence,  OcrSemanticType type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OcrLine() when $default != null:
return $default(_that.text,_that.x,_that.y,_that.w,_that.h,_that.elements,_that.confidence,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text, @JsonKey(readValue: _readX)  double x, @JsonKey(readValue: _readY)  double y, @JsonKey(readValue: _readW)  double w, @JsonKey(readValue: _readH)  double h,  List<OcrElement> elements,  double confidence,  OcrSemanticType type)  $default,) {final _that = this;
switch (_that) {
case _OcrLine():
return $default(_that.text,_that.x,_that.y,_that.w,_that.h,_that.elements,_that.confidence,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text, @JsonKey(readValue: _readX)  double x, @JsonKey(readValue: _readY)  double y, @JsonKey(readValue: _readW)  double w, @JsonKey(readValue: _readH)  double h,  List<OcrElement> elements,  double confidence,  OcrSemanticType type)?  $default,) {final _that = this;
switch (_that) {
case _OcrLine() when $default != null:
return $default(_that.text,_that.x,_that.y,_that.w,_that.h,_that.elements,_that.confidence,_that.type);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _OcrLine implements OcrLine {
  const _OcrLine({required this.text, @JsonKey(readValue: _readX) required this.x, @JsonKey(readValue: _readY) required this.y, @JsonKey(readValue: _readW) required this.w, @JsonKey(readValue: _readH) required this.h, final  List<OcrElement> elements = const [], this.confidence = 0.0, this.type = OcrSemanticType.normal}): _elements = elements;
  factory _OcrLine.fromJson(Map<String, dynamic> json) => _$OcrLineFromJson(json);

@override final  String text;
@override@JsonKey(readValue: _readX) final  double x;
@override@JsonKey(readValue: _readY) final  double y;
@override@JsonKey(readValue: _readW) final  double w;
@override@JsonKey(readValue: _readH) final  double h;
 final  List<OcrElement> _elements;
@override@JsonKey() List<OcrElement> get elements {
  if (_elements is EqualUnmodifiableListView) return _elements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_elements);
}

@override@JsonKey() final  double confidence;
@override@JsonKey() final  OcrSemanticType type;

/// Create a copy of OcrLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OcrLineCopyWith<_OcrLine> get copyWith => __$OcrLineCopyWithImpl<_OcrLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OcrLineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OcrLine&&(identical(other.text, text) || other.text == text)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.w, w) || other.w == w)&&(identical(other.h, h) || other.h == h)&&const DeepCollectionEquality().equals(other._elements, _elements)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,x,y,w,h,const DeepCollectionEquality().hash(_elements),confidence,type);

@override
String toString() {
  return 'OcrLine(text: $text, x: $x, y: $y, w: $w, h: $h, elements: $elements, confidence: $confidence, type: $type)';
}


}

/// @nodoc
abstract mixin class _$OcrLineCopyWith<$Res> implements $OcrLineCopyWith<$Res> {
  factory _$OcrLineCopyWith(_OcrLine value, $Res Function(_OcrLine) _then) = __$OcrLineCopyWithImpl;
@override @useResult
$Res call({
 String text,@JsonKey(readValue: _readX) double x,@JsonKey(readValue: _readY) double y,@JsonKey(readValue: _readW) double w,@JsonKey(readValue: _readH) double h, List<OcrElement> elements, double confidence, OcrSemanticType type
});




}
/// @nodoc
class __$OcrLineCopyWithImpl<$Res>
    implements _$OcrLineCopyWith<$Res> {
  __$OcrLineCopyWithImpl(this._self, this._then);

  final _OcrLine _self;
  final $Res Function(_OcrLine) _then;

/// Create a copy of OcrLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? x = null,Object? y = null,Object? w = null,Object? h = null,Object? elements = null,Object? confidence = null,Object? type = null,}) {
  return _then(_OcrLine(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,w: null == w ? _self.w : w // ignore: cast_nullable_to_non_nullable
as double,h: null == h ? _self.h : h // ignore: cast_nullable_to_non_nullable
as double,elements: null == elements ? _self._elements : elements // ignore: cast_nullable_to_non_nullable
as List<OcrElement>,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as OcrSemanticType,
  ));
}


}


/// @nodoc
mixin _$OcrBlock {

 String get text;@JsonKey(readValue: _readX) double get x;@JsonKey(readValue: _readY) double get y;@JsonKey(readValue: _readW) double get w;@JsonKey(readValue: _readH) double get h; List<OcrLine> get lines; double get confidence; OcrSemanticType get type;
/// Create a copy of OcrBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OcrBlockCopyWith<OcrBlock> get copyWith => _$OcrBlockCopyWithImpl<OcrBlock>(this as OcrBlock, _$identity);

  /// Serializes this OcrBlock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OcrBlock&&(identical(other.text, text) || other.text == text)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.w, w) || other.w == w)&&(identical(other.h, h) || other.h == h)&&const DeepCollectionEquality().equals(other.lines, lines)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,x,y,w,h,const DeepCollectionEquality().hash(lines),confidence,type);

@override
String toString() {
  return 'OcrBlock(text: $text, x: $x, y: $y, w: $w, h: $h, lines: $lines, confidence: $confidence, type: $type)';
}


}

/// @nodoc
abstract mixin class $OcrBlockCopyWith<$Res>  {
  factory $OcrBlockCopyWith(OcrBlock value, $Res Function(OcrBlock) _then) = _$OcrBlockCopyWithImpl;
@useResult
$Res call({
 String text,@JsonKey(readValue: _readX) double x,@JsonKey(readValue: _readY) double y,@JsonKey(readValue: _readW) double w,@JsonKey(readValue: _readH) double h, List<OcrLine> lines, double confidence, OcrSemanticType type
});




}
/// @nodoc
class _$OcrBlockCopyWithImpl<$Res>
    implements $OcrBlockCopyWith<$Res> {
  _$OcrBlockCopyWithImpl(this._self, this._then);

  final OcrBlock _self;
  final $Res Function(OcrBlock) _then;

/// Create a copy of OcrBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? x = null,Object? y = null,Object? w = null,Object? h = null,Object? lines = null,Object? confidence = null,Object? type = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,w: null == w ? _self.w : w // ignore: cast_nullable_to_non_nullable
as double,h: null == h ? _self.h : h // ignore: cast_nullable_to_non_nullable
as double,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<OcrLine>,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as OcrSemanticType,
  ));
}

}


/// Adds pattern-matching-related methods to [OcrBlock].
extension OcrBlockPatterns on OcrBlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OcrBlock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OcrBlock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OcrBlock value)  $default,){
final _that = this;
switch (_that) {
case _OcrBlock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OcrBlock value)?  $default,){
final _that = this;
switch (_that) {
case _OcrBlock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text, @JsonKey(readValue: _readX)  double x, @JsonKey(readValue: _readY)  double y, @JsonKey(readValue: _readW)  double w, @JsonKey(readValue: _readH)  double h,  List<OcrLine> lines,  double confidence,  OcrSemanticType type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OcrBlock() when $default != null:
return $default(_that.text,_that.x,_that.y,_that.w,_that.h,_that.lines,_that.confidence,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text, @JsonKey(readValue: _readX)  double x, @JsonKey(readValue: _readY)  double y, @JsonKey(readValue: _readW)  double w, @JsonKey(readValue: _readH)  double h,  List<OcrLine> lines,  double confidence,  OcrSemanticType type)  $default,) {final _that = this;
switch (_that) {
case _OcrBlock():
return $default(_that.text,_that.x,_that.y,_that.w,_that.h,_that.lines,_that.confidence,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text, @JsonKey(readValue: _readX)  double x, @JsonKey(readValue: _readY)  double y, @JsonKey(readValue: _readW)  double w, @JsonKey(readValue: _readH)  double h,  List<OcrLine> lines,  double confidence,  OcrSemanticType type)?  $default,) {final _that = this;
switch (_that) {
case _OcrBlock() when $default != null:
return $default(_that.text,_that.x,_that.y,_that.w,_that.h,_that.lines,_that.confidence,_that.type);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _OcrBlock implements OcrBlock {
  const _OcrBlock({required this.text, @JsonKey(readValue: _readX) required this.x, @JsonKey(readValue: _readY) required this.y, @JsonKey(readValue: _readW) required this.w, @JsonKey(readValue: _readH) required this.h, final  List<OcrLine> lines = const [], this.confidence = 0.0, this.type = OcrSemanticType.normal}): _lines = lines;
  factory _OcrBlock.fromJson(Map<String, dynamic> json) => _$OcrBlockFromJson(json);

@override final  String text;
@override@JsonKey(readValue: _readX) final  double x;
@override@JsonKey(readValue: _readY) final  double y;
@override@JsonKey(readValue: _readW) final  double w;
@override@JsonKey(readValue: _readH) final  double h;
 final  List<OcrLine> _lines;
@override@JsonKey() List<OcrLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

@override@JsonKey() final  double confidence;
@override@JsonKey() final  OcrSemanticType type;

/// Create a copy of OcrBlock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OcrBlockCopyWith<_OcrBlock> get copyWith => __$OcrBlockCopyWithImpl<_OcrBlock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OcrBlockToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OcrBlock&&(identical(other.text, text) || other.text == text)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.w, w) || other.w == w)&&(identical(other.h, h) || other.h == h)&&const DeepCollectionEquality().equals(other._lines, _lines)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,x,y,w,h,const DeepCollectionEquality().hash(_lines),confidence,type);

@override
String toString() {
  return 'OcrBlock(text: $text, x: $x, y: $y, w: $w, h: $h, lines: $lines, confidence: $confidence, type: $type)';
}


}

/// @nodoc
abstract mixin class _$OcrBlockCopyWith<$Res> implements $OcrBlockCopyWith<$Res> {
  factory _$OcrBlockCopyWith(_OcrBlock value, $Res Function(_OcrBlock) _then) = __$OcrBlockCopyWithImpl;
@override @useResult
$Res call({
 String text,@JsonKey(readValue: _readX) double x,@JsonKey(readValue: _readY) double y,@JsonKey(readValue: _readW) double w,@JsonKey(readValue: _readH) double h, List<OcrLine> lines, double confidence, OcrSemanticType type
});




}
/// @nodoc
class __$OcrBlockCopyWithImpl<$Res>
    implements _$OcrBlockCopyWith<$Res> {
  __$OcrBlockCopyWithImpl(this._self, this._then);

  final _OcrBlock _self;
  final $Res Function(_OcrBlock) _then;

/// Create a copy of OcrBlock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? x = null,Object? y = null,Object? w = null,Object? h = null,Object? lines = null,Object? confidence = null,Object? type = null,}) {
  return _then(_OcrBlock(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,w: null == w ? _self.w : w // ignore: cast_nullable_to_non_nullable
as double,h: null == h ? _self.h : h // ignore: cast_nullable_to_non_nullable
as double,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<OcrLine>,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as OcrSemanticType,
  ));
}


}


/// @nodoc
mixin _$OcrPage {

 int get pageNumber; List<OcrBlock> get blocks; double get confidence; double get width; double get height;
/// Create a copy of OcrPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OcrPageCopyWith<OcrPage> get copyWith => _$OcrPageCopyWithImpl<OcrPage>(this as OcrPage, _$identity);

  /// Serializes this OcrPage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OcrPage&&(identical(other.pageNumber, pageNumber) || other.pageNumber == pageNumber)&&const DeepCollectionEquality().equals(other.blocks, blocks)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pageNumber,const DeepCollectionEquality().hash(blocks),confidence,width,height);

@override
String toString() {
  return 'OcrPage(pageNumber: $pageNumber, blocks: $blocks, confidence: $confidence, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class $OcrPageCopyWith<$Res>  {
  factory $OcrPageCopyWith(OcrPage value, $Res Function(OcrPage) _then) = _$OcrPageCopyWithImpl;
@useResult
$Res call({
 int pageNumber, List<OcrBlock> blocks, double confidence, double width, double height
});




}
/// @nodoc
class _$OcrPageCopyWithImpl<$Res>
    implements $OcrPageCopyWith<$Res> {
  _$OcrPageCopyWithImpl(this._self, this._then);

  final OcrPage _self;
  final $Res Function(OcrPage) _then;

/// Create a copy of OcrPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pageNumber = null,Object? blocks = null,Object? confidence = null,Object? width = null,Object? height = null,}) {
  return _then(_self.copyWith(
pageNumber: null == pageNumber ? _self.pageNumber : pageNumber // ignore: cast_nullable_to_non_nullable
as int,blocks: null == blocks ? _self.blocks : blocks // ignore: cast_nullable_to_non_nullable
as List<OcrBlock>,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [OcrPage].
extension OcrPagePatterns on OcrPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OcrPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OcrPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OcrPage value)  $default,){
final _that = this;
switch (_that) {
case _OcrPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OcrPage value)?  $default,){
final _that = this;
switch (_that) {
case _OcrPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int pageNumber,  List<OcrBlock> blocks,  double confidence,  double width,  double height)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OcrPage() when $default != null:
return $default(_that.pageNumber,_that.blocks,_that.confidence,_that.width,_that.height);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int pageNumber,  List<OcrBlock> blocks,  double confidence,  double width,  double height)  $default,) {final _that = this;
switch (_that) {
case _OcrPage():
return $default(_that.pageNumber,_that.blocks,_that.confidence,_that.width,_that.height);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int pageNumber,  List<OcrBlock> blocks,  double confidence,  double width,  double height)?  $default,) {final _that = this;
switch (_that) {
case _OcrPage() when $default != null:
return $default(_that.pageNumber,_that.blocks,_that.confidence,_that.width,_that.height);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _OcrPage implements OcrPage {
  const _OcrPage({this.pageNumber = 0, final  List<OcrBlock> blocks = const [], this.confidence = 0.0, this.width = 0.0, this.height = 0.0}): _blocks = blocks;
  factory _OcrPage.fromJson(Map<String, dynamic> json) => _$OcrPageFromJson(json);

@override@JsonKey() final  int pageNumber;
 final  List<OcrBlock> _blocks;
@override@JsonKey() List<OcrBlock> get blocks {
  if (_blocks is EqualUnmodifiableListView) return _blocks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_blocks);
}

@override@JsonKey() final  double confidence;
@override@JsonKey() final  double width;
@override@JsonKey() final  double height;

/// Create a copy of OcrPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OcrPageCopyWith<_OcrPage> get copyWith => __$OcrPageCopyWithImpl<_OcrPage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OcrPageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OcrPage&&(identical(other.pageNumber, pageNumber) || other.pageNumber == pageNumber)&&const DeepCollectionEquality().equals(other._blocks, _blocks)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pageNumber,const DeepCollectionEquality().hash(_blocks),confidence,width,height);

@override
String toString() {
  return 'OcrPage(pageNumber: $pageNumber, blocks: $blocks, confidence: $confidence, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class _$OcrPageCopyWith<$Res> implements $OcrPageCopyWith<$Res> {
  factory _$OcrPageCopyWith(_OcrPage value, $Res Function(_OcrPage) _then) = __$OcrPageCopyWithImpl;
@override @useResult
$Res call({
 int pageNumber, List<OcrBlock> blocks, double confidence, double width, double height
});




}
/// @nodoc
class __$OcrPageCopyWithImpl<$Res>
    implements _$OcrPageCopyWith<$Res> {
  __$OcrPageCopyWithImpl(this._self, this._then);

  final _OcrPage _self;
  final $Res Function(_OcrPage) _then;

/// Create a copy of OcrPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pageNumber = null,Object? blocks = null,Object? confidence = null,Object? width = null,Object? height = null,}) {
  return _then(_OcrPage(
pageNumber: null == pageNumber ? _self.pageNumber : pageNumber // ignore: cast_nullable_to_non_nullable
as int,blocks: null == blocks ? _self._blocks : blocks // ignore: cast_nullable_to_non_nullable
as List<OcrBlock>,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$OcrResult {

 String get text;@JsonKey(readValue: _readPages) List<OcrPage> get pages; double get confidence;// Metadata (V2)
 String get source;// e.g., 'ios_vision', 'google_mlkit'
 String get language; DateTime? get timestamp; int get version;
/// Create a copy of OcrResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OcrResultCopyWith<OcrResult> get copyWith => _$OcrResultCopyWithImpl<OcrResult>(this as OcrResult, _$identity);

  /// Serializes this OcrResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OcrResult&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other.pages, pages)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.source, source) || other.source == source)&&(identical(other.language, language) || other.language == language)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,const DeepCollectionEquality().hash(pages),confidence,source,language,timestamp,version);

@override
String toString() {
  return 'OcrResult(text: $text, pages: $pages, confidence: $confidence, source: $source, language: $language, timestamp: $timestamp, version: $version)';
}


}

/// @nodoc
abstract mixin class $OcrResultCopyWith<$Res>  {
  factory $OcrResultCopyWith(OcrResult value, $Res Function(OcrResult) _then) = _$OcrResultCopyWithImpl;
@useResult
$Res call({
 String text,@JsonKey(readValue: _readPages) List<OcrPage> pages, double confidence, String source, String language, DateTime? timestamp, int version
});




}
/// @nodoc
class _$OcrResultCopyWithImpl<$Res>
    implements $OcrResultCopyWith<$Res> {
  _$OcrResultCopyWithImpl(this._self, this._then);

  final OcrResult _self;
  final $Res Function(OcrResult) _then;

/// Create a copy of OcrResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? pages = null,Object? confidence = null,Object? source = null,Object? language = null,Object? timestamp = freezed,Object? version = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as List<OcrPage>,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OcrResult].
extension OcrResultPatterns on OcrResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OcrResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OcrResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OcrResult value)  $default,){
final _that = this;
switch (_that) {
case _OcrResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OcrResult value)?  $default,){
final _that = this;
switch (_that) {
case _OcrResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text, @JsonKey(readValue: _readPages)  List<OcrPage> pages,  double confidence,  String source,  String language,  DateTime? timestamp,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OcrResult() when $default != null:
return $default(_that.text,_that.pages,_that.confidence,_that.source,_that.language,_that.timestamp,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text, @JsonKey(readValue: _readPages)  List<OcrPage> pages,  double confidence,  String source,  String language,  DateTime? timestamp,  int version)  $default,) {final _that = this;
switch (_that) {
case _OcrResult():
return $default(_that.text,_that.pages,_that.confidence,_that.source,_that.language,_that.timestamp,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text, @JsonKey(readValue: _readPages)  List<OcrPage> pages,  double confidence,  String source,  String language,  DateTime? timestamp,  int version)?  $default,) {final _that = this;
switch (_that) {
case _OcrResult() when $default != null:
return $default(_that.text,_that.pages,_that.confidence,_that.source,_that.language,_that.timestamp,_that.version);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _OcrResult extends OcrResult {
  const _OcrResult({required this.text, @JsonKey(readValue: _readPages) final  List<OcrPage> pages = const [], this.confidence = 0.0, this.source = 'unknown', this.language = 'auto', this.timestamp, this.version = 2}): _pages = pages,super._();
  factory _OcrResult.fromJson(Map<String, dynamic> json) => _$OcrResultFromJson(json);

@override final  String text;
 final  List<OcrPage> _pages;
@override@JsonKey(readValue: _readPages) List<OcrPage> get pages {
  if (_pages is EqualUnmodifiableListView) return _pages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pages);
}

@override@JsonKey() final  double confidence;
// Metadata (V2)
@override@JsonKey() final  String source;
// e.g., 'ios_vision', 'google_mlkit'
@override@JsonKey() final  String language;
@override final  DateTime? timestamp;
@override@JsonKey() final  int version;

/// Create a copy of OcrResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OcrResultCopyWith<_OcrResult> get copyWith => __$OcrResultCopyWithImpl<_OcrResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OcrResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OcrResult&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other._pages, _pages)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.source, source) || other.source == source)&&(identical(other.language, language) || other.language == language)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,const DeepCollectionEquality().hash(_pages),confidence,source,language,timestamp,version);

@override
String toString() {
  return 'OcrResult(text: $text, pages: $pages, confidence: $confidence, source: $source, language: $language, timestamp: $timestamp, version: $version)';
}


}

/// @nodoc
abstract mixin class _$OcrResultCopyWith<$Res> implements $OcrResultCopyWith<$Res> {
  factory _$OcrResultCopyWith(_OcrResult value, $Res Function(_OcrResult) _then) = __$OcrResultCopyWithImpl;
@override @useResult
$Res call({
 String text,@JsonKey(readValue: _readPages) List<OcrPage> pages, double confidence, String source, String language, DateTime? timestamp, int version
});




}
/// @nodoc
class __$OcrResultCopyWithImpl<$Res>
    implements _$OcrResultCopyWith<$Res> {
  __$OcrResultCopyWithImpl(this._self, this._then);

  final _OcrResult _self;
  final $Res Function(_OcrResult) _then;

/// Create a copy of OcrResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? pages = null,Object? confidence = null,Object? source = null,Object? language = null,Object? timestamp = freezed,Object? version = null,}) {
  return _then(_OcrResult(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,pages: null == pages ? _self._pages : pages // ignore: cast_nullable_to_non_nullable
as List<OcrPage>,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
