// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slm_data_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SLMDataBlock _$SLMDataBlockFromJson(Map<String, dynamic> json) =>
    _SLMDataBlock(
      rawText: json['rawText'] as String,
      normalizedText: json['normalizedText'] as String?,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 1.0,
      boundingBox:
          (json['boundingBox'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          const [0.0, 0.0, 0.0, 0.0],
      isPIIMasked: json['isPIIMasked'] as bool? ?? false,
      semanticLabel: json['semanticLabel'] as String?,
    );

Map<String, dynamic> _$SLMDataBlockToJson(_SLMDataBlock instance) =>
    <String, dynamic>{
      'rawText': instance.rawText,
      'normalizedText': instance.normalizedText,
      'confidence': instance.confidence,
      'boundingBox': instance.boundingBox,
      'isPIIMasked': instance.isPIIMasked,
      'semanticLabel': instance.semanticLabel,
    };
