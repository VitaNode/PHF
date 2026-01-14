// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ingestion_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$IngestionState {

 List<XFile> get rawImages; List<int> get rotations;// 90, 180, 270 (degrees)
 DateTime? get visitDate; String? get hospitalName; String? get notes; IngestionStatus get status; String? get errorMessage; List<String> get selectedTagIds; bool get isGroupedReport;
/// Create a copy of IngestionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IngestionStateCopyWith<IngestionState> get copyWith => _$IngestionStateCopyWithImpl<IngestionState>(this as IngestionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IngestionState&&const DeepCollectionEquality().equals(other.rawImages, rawImages)&&const DeepCollectionEquality().equals(other.rotations, rotations)&&(identical(other.visitDate, visitDate) || other.visitDate == visitDate)&&(identical(other.hospitalName, hospitalName) || other.hospitalName == hospitalName)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other.selectedTagIds, selectedTagIds)&&(identical(other.isGroupedReport, isGroupedReport) || other.isGroupedReport == isGroupedReport));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(rawImages),const DeepCollectionEquality().hash(rotations),visitDate,hospitalName,notes,status,errorMessage,const DeepCollectionEquality().hash(selectedTagIds),isGroupedReport);

@override
String toString() {
  return 'IngestionState(rawImages: $rawImages, rotations: $rotations, visitDate: $visitDate, hospitalName: $hospitalName, notes: $notes, status: $status, errorMessage: $errorMessage, selectedTagIds: $selectedTagIds, isGroupedReport: $isGroupedReport)';
}


}

/// @nodoc
abstract mixin class $IngestionStateCopyWith<$Res>  {
  factory $IngestionStateCopyWith(IngestionState value, $Res Function(IngestionState) _then) = _$IngestionStateCopyWithImpl;
@useResult
$Res call({
 List<XFile> rawImages, List<int> rotations, DateTime? visitDate, String? hospitalName, String? notes, IngestionStatus status, String? errorMessage, List<String> selectedTagIds, bool isGroupedReport
});




}
/// @nodoc
class _$IngestionStateCopyWithImpl<$Res>
    implements $IngestionStateCopyWith<$Res> {
  _$IngestionStateCopyWithImpl(this._self, this._then);

  final IngestionState _self;
  final $Res Function(IngestionState) _then;

/// Create a copy of IngestionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rawImages = null,Object? rotations = null,Object? visitDate = freezed,Object? hospitalName = freezed,Object? notes = freezed,Object? status = null,Object? errorMessage = freezed,Object? selectedTagIds = null,Object? isGroupedReport = null,}) {
  return _then(_self.copyWith(
rawImages: null == rawImages ? _self.rawImages : rawImages // ignore: cast_nullable_to_non_nullable
as List<XFile>,rotations: null == rotations ? _self.rotations : rotations // ignore: cast_nullable_to_non_nullable
as List<int>,visitDate: freezed == visitDate ? _self.visitDate : visitDate // ignore: cast_nullable_to_non_nullable
as DateTime?,hospitalName: freezed == hospitalName ? _self.hospitalName : hospitalName // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as IngestionStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,selectedTagIds: null == selectedTagIds ? _self.selectedTagIds : selectedTagIds // ignore: cast_nullable_to_non_nullable
as List<String>,isGroupedReport: null == isGroupedReport ? _self.isGroupedReport : isGroupedReport // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [IngestionState].
extension IngestionStatePatterns on IngestionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IngestionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IngestionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IngestionState value)  $default,){
final _that = this;
switch (_that) {
case _IngestionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IngestionState value)?  $default,){
final _that = this;
switch (_that) {
case _IngestionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<XFile> rawImages,  List<int> rotations,  DateTime? visitDate,  String? hospitalName,  String? notes,  IngestionStatus status,  String? errorMessage,  List<String> selectedTagIds,  bool isGroupedReport)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IngestionState() when $default != null:
return $default(_that.rawImages,_that.rotations,_that.visitDate,_that.hospitalName,_that.notes,_that.status,_that.errorMessage,_that.selectedTagIds,_that.isGroupedReport);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<XFile> rawImages,  List<int> rotations,  DateTime? visitDate,  String? hospitalName,  String? notes,  IngestionStatus status,  String? errorMessage,  List<String> selectedTagIds,  bool isGroupedReport)  $default,) {final _that = this;
switch (_that) {
case _IngestionState():
return $default(_that.rawImages,_that.rotations,_that.visitDate,_that.hospitalName,_that.notes,_that.status,_that.errorMessage,_that.selectedTagIds,_that.isGroupedReport);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<XFile> rawImages,  List<int> rotations,  DateTime? visitDate,  String? hospitalName,  String? notes,  IngestionStatus status,  String? errorMessage,  List<String> selectedTagIds,  bool isGroupedReport)?  $default,) {final _that = this;
switch (_that) {
case _IngestionState() when $default != null:
return $default(_that.rawImages,_that.rotations,_that.visitDate,_that.hospitalName,_that.notes,_that.status,_that.errorMessage,_that.selectedTagIds,_that.isGroupedReport);case _:
  return null;

}
}

}

/// @nodoc


class _IngestionState implements IngestionState {
  const _IngestionState({final  List<XFile> rawImages = const [], final  List<int> rotations = const [], this.visitDate, this.hospitalName, this.notes, this.status = IngestionStatus.idle, this.errorMessage, final  List<String> selectedTagIds = const [], this.isGroupedReport = false}): _rawImages = rawImages,_rotations = rotations,_selectedTagIds = selectedTagIds;
  

 final  List<XFile> _rawImages;
@override@JsonKey() List<XFile> get rawImages {
  if (_rawImages is EqualUnmodifiableListView) return _rawImages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rawImages);
}

 final  List<int> _rotations;
@override@JsonKey() List<int> get rotations {
  if (_rotations is EqualUnmodifiableListView) return _rotations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rotations);
}

// 90, 180, 270 (degrees)
@override final  DateTime? visitDate;
@override final  String? hospitalName;
@override final  String? notes;
@override@JsonKey() final  IngestionStatus status;
@override final  String? errorMessage;
 final  List<String> _selectedTagIds;
@override@JsonKey() List<String> get selectedTagIds {
  if (_selectedTagIds is EqualUnmodifiableListView) return _selectedTagIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedTagIds);
}

@override@JsonKey() final  bool isGroupedReport;

/// Create a copy of IngestionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IngestionStateCopyWith<_IngestionState> get copyWith => __$IngestionStateCopyWithImpl<_IngestionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IngestionState&&const DeepCollectionEquality().equals(other._rawImages, _rawImages)&&const DeepCollectionEquality().equals(other._rotations, _rotations)&&(identical(other.visitDate, visitDate) || other.visitDate == visitDate)&&(identical(other.hospitalName, hospitalName) || other.hospitalName == hospitalName)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other._selectedTagIds, _selectedTagIds)&&(identical(other.isGroupedReport, isGroupedReport) || other.isGroupedReport == isGroupedReport));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_rawImages),const DeepCollectionEquality().hash(_rotations),visitDate,hospitalName,notes,status,errorMessage,const DeepCollectionEquality().hash(_selectedTagIds),isGroupedReport);

@override
String toString() {
  return 'IngestionState(rawImages: $rawImages, rotations: $rotations, visitDate: $visitDate, hospitalName: $hospitalName, notes: $notes, status: $status, errorMessage: $errorMessage, selectedTagIds: $selectedTagIds, isGroupedReport: $isGroupedReport)';
}


}

/// @nodoc
abstract mixin class _$IngestionStateCopyWith<$Res> implements $IngestionStateCopyWith<$Res> {
  factory _$IngestionStateCopyWith(_IngestionState value, $Res Function(_IngestionState) _then) = __$IngestionStateCopyWithImpl;
@override @useResult
$Res call({
 List<XFile> rawImages, List<int> rotations, DateTime? visitDate, String? hospitalName, String? notes, IngestionStatus status, String? errorMessage, List<String> selectedTagIds, bool isGroupedReport
});




}
/// @nodoc
class __$IngestionStateCopyWithImpl<$Res>
    implements _$IngestionStateCopyWith<$Res> {
  __$IngestionStateCopyWithImpl(this._self, this._then);

  final _IngestionState _self;
  final $Res Function(_IngestionState) _then;

/// Create a copy of IngestionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rawImages = null,Object? rotations = null,Object? visitDate = freezed,Object? hospitalName = freezed,Object? notes = freezed,Object? status = null,Object? errorMessage = freezed,Object? selectedTagIds = null,Object? isGroupedReport = null,}) {
  return _then(_IngestionState(
rawImages: null == rawImages ? _self._rawImages : rawImages // ignore: cast_nullable_to_non_nullable
as List<XFile>,rotations: null == rotations ? _self._rotations : rotations // ignore: cast_nullable_to_non_nullable
as List<int>,visitDate: freezed == visitDate ? _self.visitDate : visitDate // ignore: cast_nullable_to_non_nullable
as DateTime?,hospitalName: freezed == hospitalName ? _self.hospitalName : hospitalName // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as IngestionStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,selectedTagIds: null == selectedTagIds ? _self._selectedTagIds : selectedTagIds // ignore: cast_nullable_to_non_nullable
as List<String>,isGroupedReport: null == isGroupedReport ? _self.isGroupedReport : isGroupedReport // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
