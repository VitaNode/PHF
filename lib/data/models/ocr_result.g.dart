// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocr_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OcrElement _$OcrElementFromJson(Map<String, dynamic> json) => _OcrElement(
  text: json['text'] as String,
  x: (_readX(json, 'x') as num).toDouble(),
  y: (_readY(json, 'y') as num).toDouble(),
  w: (_readW(json, 'w') as num).toDouble(),
  h: (_readH(json, 'h') as num).toDouble(),
  confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
  type:
      $enumDecodeNullable(_$OcrSemanticTypeEnumMap, json['type']) ??
      OcrSemanticType.normal,
);

Map<String, dynamic> _$OcrElementToJson(_OcrElement instance) =>
    <String, dynamic>{
      'text': instance.text,
      'x': instance.x,
      'y': instance.y,
      'w': instance.w,
      'h': instance.h,
      'confidence': instance.confidence,
      'type': _$OcrSemanticTypeEnumMap[instance.type]!,
    };

const _$OcrSemanticTypeEnumMap = {
  OcrSemanticType.normal: 'normal',
  OcrSemanticType.label: 'label',
  OcrSemanticType.value: 'value',
  OcrSemanticType.sectionTitle: 'section_title',
};

_OcrLine _$OcrLineFromJson(Map<String, dynamic> json) => _OcrLine(
  text: json['text'] as String,
  x: (_readX(json, 'x') as num).toDouble(),
  y: (_readY(json, 'y') as num).toDouble(),
  w: (_readW(json, 'w') as num).toDouble(),
  h: (_readH(json, 'h') as num).toDouble(),
  elements:
      (json['elements'] as List<dynamic>?)
          ?.map((e) => OcrElement.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
  type:
      $enumDecodeNullable(_$OcrSemanticTypeEnumMap, json['type']) ??
      OcrSemanticType.normal,
);

Map<String, dynamic> _$OcrLineToJson(_OcrLine instance) => <String, dynamic>{
  'text': instance.text,
  'x': instance.x,
  'y': instance.y,
  'w': instance.w,
  'h': instance.h,
  'elements': instance.elements.map((e) => e.toJson()).toList(),
  'confidence': instance.confidence,
  'type': _$OcrSemanticTypeEnumMap[instance.type]!,
};

_OcrBlock _$OcrBlockFromJson(Map<String, dynamic> json) => _OcrBlock(
  text: json['text'] as String,
  x: (_readX(json, 'x') as num).toDouble(),
  y: (_readY(json, 'y') as num).toDouble(),
  w: (_readW(json, 'w') as num).toDouble(),
  h: (_readH(json, 'h') as num).toDouble(),
  lines:
      (json['lines'] as List<dynamic>?)
          ?.map((e) => OcrLine.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
  type:
      $enumDecodeNullable(_$OcrSemanticTypeEnumMap, json['type']) ??
      OcrSemanticType.normal,
);

Map<String, dynamic> _$OcrBlockToJson(_OcrBlock instance) => <String, dynamic>{
  'text': instance.text,
  'x': instance.x,
  'y': instance.y,
  'w': instance.w,
  'h': instance.h,
  'lines': instance.lines.map((e) => e.toJson()).toList(),
  'confidence': instance.confidence,
  'type': _$OcrSemanticTypeEnumMap[instance.type]!,
};

_OcrPage _$OcrPageFromJson(Map<String, dynamic> json) => _OcrPage(
  pageNumber: (json['pageNumber'] as num?)?.toInt() ?? 0,
  blocks:
      (json['blocks'] as List<dynamic>?)
          ?.map((e) => OcrBlock.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
  width: (json['width'] as num?)?.toDouble() ?? 0.0,
  height: (json['height'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$OcrPageToJson(_OcrPage instance) => <String, dynamic>{
  'pageNumber': instance.pageNumber,
  'blocks': instance.blocks.map((e) => e.toJson()).toList(),
  'confidence': instance.confidence,
  'width': instance.width,
  'height': instance.height,
};

_OcrResult _$OcrResultFromJson(Map<String, dynamic> json) => _OcrResult(
  text: json['text'] as String,
  pages:
      (_readPages(json, 'pages') as List<dynamic>?)
          ?.map((e) => OcrPage.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
  source: json['source'] as String? ?? 'unknown',
  language: json['language'] as String? ?? 'auto',
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
  version: (json['version'] as num?)?.toInt() ?? 2,
);

Map<String, dynamic> _$OcrResultToJson(_OcrResult instance) =>
    <String, dynamic>{
      'text': instance.text,
      'pages': instance.pages.map((e) => e.toJson()).toList(),
      'confidence': instance.confidence,
      'source': instance.source,
      'language': instance.language,
      'timestamp': instance.timestamp?.toIso8601String(),
      'version': instance.version,
    };
