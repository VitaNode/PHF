import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

part 'ingestion_state.freezed.dart';

enum IngestionStatus { idle, processing, saving, success, error }

@freezed
abstract class IngestionState with _$IngestionState {
  const factory IngestionState({
    @Default([]) List<XFile> rawImages,
    @Default([]) List<int> rotations, // 90, 180, 270 (degrees)
    DateTime? visitDate,
    String? hospitalName,
    String? notes,
    @Default(IngestionStatus.idle) IngestionStatus status,
    String? errorMessage,
    @Default([]) List<String> selectedTagIds,
    @Default(false) bool isGroupedReport,
  }) = _IngestionState;
}
