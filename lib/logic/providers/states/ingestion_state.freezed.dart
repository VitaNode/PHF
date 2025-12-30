// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ingestion_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$IngestionState {
  List<XFile> get rawImages => throw _privateConstructorUsedError;
  List<int> get rotations =>
      throw _privateConstructorUsedError; // 90, 180, 270 (degrees)
  DateTime? get visitDate => throw _privateConstructorUsedError;
  String? get hospitalName => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  IngestionStatus get status => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  List<String> get selectedTagIds => throw _privateConstructorUsedError;

  /// Create a copy of IngestionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IngestionStateCopyWith<IngestionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IngestionStateCopyWith<$Res> {
  factory $IngestionStateCopyWith(
          IngestionState value, $Res Function(IngestionState) then) =
      _$IngestionStateCopyWithImpl<$Res, IngestionState>;
  @useResult
  $Res call(
      {List<XFile> rawImages,
      List<int> rotations,
      DateTime? visitDate,
      String? hospitalName,
      String? notes,
      IngestionStatus status,
      String? errorMessage,
      List<String> selectedTagIds});
}

/// @nodoc
class _$IngestionStateCopyWithImpl<$Res, $Val extends IngestionState>
    implements $IngestionStateCopyWith<$Res> {
  _$IngestionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IngestionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rawImages = null,
    Object? rotations = null,
    Object? visitDate = freezed,
    Object? hospitalName = freezed,
    Object? notes = freezed,
    Object? status = null,
    Object? errorMessage = freezed,
    Object? selectedTagIds = null,
  }) {
    return _then(_value.copyWith(
      rawImages: null == rawImages
          ? _value.rawImages
          : rawImages // ignore: cast_nullable_to_non_nullable
              as List<XFile>,
      rotations: null == rotations
          ? _value.rotations
          : rotations // ignore: cast_nullable_to_non_nullable
              as List<int>,
      visitDate: freezed == visitDate
          ? _value.visitDate
          : visitDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      hospitalName: freezed == hospitalName
          ? _value.hospitalName
          : hospitalName // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as IngestionStatus,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedTagIds: null == selectedTagIds
          ? _value.selectedTagIds
          : selectedTagIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IngestionStateImplCopyWith<$Res>
    implements $IngestionStateCopyWith<$Res> {
  factory _$$IngestionStateImplCopyWith(_$IngestionStateImpl value,
          $Res Function(_$IngestionStateImpl) then) =
      __$$IngestionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<XFile> rawImages,
      List<int> rotations,
      DateTime? visitDate,
      String? hospitalName,
      String? notes,
      IngestionStatus status,
      String? errorMessage,
      List<String> selectedTagIds});
}

/// @nodoc
class __$$IngestionStateImplCopyWithImpl<$Res>
    extends _$IngestionStateCopyWithImpl<$Res, _$IngestionStateImpl>
    implements _$$IngestionStateImplCopyWith<$Res> {
  __$$IngestionStateImplCopyWithImpl(
      _$IngestionStateImpl _value, $Res Function(_$IngestionStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of IngestionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rawImages = null,
    Object? rotations = null,
    Object? visitDate = freezed,
    Object? hospitalName = freezed,
    Object? notes = freezed,
    Object? status = null,
    Object? errorMessage = freezed,
    Object? selectedTagIds = null,
  }) {
    return _then(_$IngestionStateImpl(
      rawImages: null == rawImages
          ? _value._rawImages
          : rawImages // ignore: cast_nullable_to_non_nullable
              as List<XFile>,
      rotations: null == rotations
          ? _value._rotations
          : rotations // ignore: cast_nullable_to_non_nullable
              as List<int>,
      visitDate: freezed == visitDate
          ? _value.visitDate
          : visitDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      hospitalName: freezed == hospitalName
          ? _value.hospitalName
          : hospitalName // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as IngestionStatus,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedTagIds: null == selectedTagIds
          ? _value._selectedTagIds
          : selectedTagIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$IngestionStateImpl implements _IngestionState {
  const _$IngestionStateImpl(
      {final List<XFile> rawImages = const [],
      final List<int> rotations = const [],
      this.visitDate,
      this.hospitalName,
      this.notes,
      this.status = IngestionStatus.idle,
      this.errorMessage,
      final List<String> selectedTagIds = const []})
      : _rawImages = rawImages,
        _rotations = rotations,
        _selectedTagIds = selectedTagIds;

  final List<XFile> _rawImages;
  @override
  @JsonKey()
  List<XFile> get rawImages {
    if (_rawImages is EqualUnmodifiableListView) return _rawImages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rawImages);
  }

  final List<int> _rotations;
  @override
  @JsonKey()
  List<int> get rotations {
    if (_rotations is EqualUnmodifiableListView) return _rotations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rotations);
  }

// 90, 180, 270 (degrees)
  @override
  final DateTime? visitDate;
  @override
  final String? hospitalName;
  @override
  final String? notes;
  @override
  @JsonKey()
  final IngestionStatus status;
  @override
  final String? errorMessage;
  final List<String> _selectedTagIds;
  @override
  @JsonKey()
  List<String> get selectedTagIds {
    if (_selectedTagIds is EqualUnmodifiableListView) return _selectedTagIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedTagIds);
  }

  @override
  String toString() {
    return 'IngestionState(rawImages: $rawImages, rotations: $rotations, visitDate: $visitDate, hospitalName: $hospitalName, notes: $notes, status: $status, errorMessage: $errorMessage, selectedTagIds: $selectedTagIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IngestionStateImpl &&
            const DeepCollectionEquality()
                .equals(other._rawImages, _rawImages) &&
            const DeepCollectionEquality()
                .equals(other._rotations, _rotations) &&
            (identical(other.visitDate, visitDate) ||
                other.visitDate == visitDate) &&
            (identical(other.hospitalName, hospitalName) ||
                other.hospitalName == hospitalName) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality()
                .equals(other._selectedTagIds, _selectedTagIds));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_rawImages),
      const DeepCollectionEquality().hash(_rotations),
      visitDate,
      hospitalName,
      notes,
      status,
      errorMessage,
      const DeepCollectionEquality().hash(_selectedTagIds));

  /// Create a copy of IngestionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IngestionStateImplCopyWith<_$IngestionStateImpl> get copyWith =>
      __$$IngestionStateImplCopyWithImpl<_$IngestionStateImpl>(
          this, _$identity);
}

abstract class _IngestionState implements IngestionState {
  const factory _IngestionState(
      {final List<XFile> rawImages,
      final List<int> rotations,
      final DateTime? visitDate,
      final String? hospitalName,
      final String? notes,
      final IngestionStatus status,
      final String? errorMessage,
      final List<String> selectedTagIds}) = _$IngestionStateImpl;

  @override
  List<XFile> get rawImages;
  @override
  List<int> get rotations; // 90, 180, 270 (degrees)
  @override
  DateTime? get visitDate;
  @override
  String? get hospitalName;
  @override
  String? get notes;
  @override
  IngestionStatus get status;
  @override
  String? get errorMessage;
  @override
  List<String> get selectedTagIds;

  /// Create a copy of IngestionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IngestionStateImplCopyWith<_$IngestionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
