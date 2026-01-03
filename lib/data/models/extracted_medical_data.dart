import 'package:freezed_annotation/freezed_annotation.dart';

part 'extracted_medical_data.freezed.dart';
part 'extracted_medical_data.g.dart';

@freezed
abstract class ExtractedMedicalData with _$ExtractedMedicalData {
  const factory ExtractedMedicalData({
    DateTime? visitDate,
    String? hospitalName,
    @Default(0.0) double confidenceScore,
  }) = _ExtractedMedicalData;

  factory ExtractedMedicalData.fromJson(Map<String, dynamic> json) =>
      _$ExtractedMedicalDataFromJson(json);
}
