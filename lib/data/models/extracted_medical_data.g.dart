// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extracted_medical_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExtractedMedicalDataImpl _$$ExtractedMedicalDataImplFromJson(
        Map<String, dynamic> json) =>
    _$ExtractedMedicalDataImpl(
      visitDate: json['visitDate'] == null
          ? null
          : DateTime.parse(json['visitDate'] as String),
      hospitalName: json['hospitalName'] as String?,
      confidenceScore: (json['confidenceScore'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$ExtractedMedicalDataImplToJson(
        _$ExtractedMedicalDataImpl instance) =>
    <String, dynamic>{
      'visitDate': instance.visitDate?.toIso8601String(),
      'hospitalName': instance.hospitalName,
      'confidenceScore': instance.confidenceScore,
    };
