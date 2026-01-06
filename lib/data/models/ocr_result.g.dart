// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocr_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OCRTextElement _$OCRTextElementFromJson(Map<String, dynamic> json) =>
    _OCRTextElement(
      text: json['text'] as String,
      x: (_readX(json, 'x') as num).toDouble(),
      y: (_readY(json, 'y') as num).toDouble(),
      w: (_readW(json, 'w') as num).toDouble(),
      h: (_readH(json, 'h') as num).toDouble(),
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$OCRTextElementToJson(_OCRTextElement instance) =>
    <String, dynamic>{
      'text': instance.text,
      'x': instance.x,
      'y': instance.y,
      'w': instance.w,
      'h': instance.h,
      'confidence': instance.confidence,
    };

_OCRLine _$OCRLineFromJson(Map<String, dynamic> json) => _OCRLine(
  text: json['text'] as String,
  x: (_readX(json, 'x') as num).toDouble(),
  y: (_readY(json, 'y') as num).toDouble(),
  w: (_readW(json, 'w') as num).toDouble(),
  h: (_readH(json, 'h') as num).toDouble(),
  elements:
      (json['elements'] as List<dynamic>?)
          ?.map((e) => OCRTextElement.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$OCRLineToJson(_OCRLine instance) => <String, dynamic>{
  'text': instance.text,
  'x': instance.x,
  'y': instance.y,
  'w': instance.w,
  'h': instance.h,
  'elements': instance.elements.map((e) => e.toJson()).toList(),
  'confidence': instance.confidence,
};

_OCRBlock _$OCRBlockFromJson(Map<String, dynamic> json) => _OCRBlock(
  text: json['text'] as String,
  x: (_readX(json, 'x') as num).toDouble(),
  y: (_readY(json, 'y') as num).toDouble(),
  w: (_readW(json, 'w') as num).toDouble(),
  h: (_readH(json, 'h') as num).toDouble(),
  lines:
      (json['lines'] as List<dynamic>?)
          ?.map((e) => OCRLine.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$OCRBlockToJson(_OCRBlock instance) => <String, dynamic>{
  'text': instance.text,
  'x': instance.x,
  'y': instance.y,
  'w': instance.w,
  'h': instance.h,
  'lines': instance.lines.map((e) => e.toJson()).toList(),
};

_OCRResult _$OCRResultFromJson(Map<String, dynamic> json) => _OCRResult(
  text: json['text'] as String,
  blocks:
      (json['blocks'] as List<dynamic>?)
          ?.map((e) => OCRBlock.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
  source: json['source'] as String? ?? 'unknown',
  language: json['language'] as String? ?? 'auto',
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
  version: (json['version'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$OCRResultToJson(_OCRResult instance) =>
    <String, dynamic>{
      'text': instance.text,
      'blocks': instance.blocks.map((e) => e.toJson()).toList(),
      'confidence': instance.confidence,
      'source': instance.source,
      'language': instance.language,
      'timestamp': instance.timestamp?.toIso8601String(),
      'version': instance.version,
    };
