import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/record.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default([]) List<MedicalRecord> records,
    @Default(0) int pendingCount,
  }) = _HomeState;
}
