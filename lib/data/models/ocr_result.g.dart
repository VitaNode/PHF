// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocr_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OCRBlock _$OCRBlockFromJson(Map<String, dynamic> json) => _OCRBlock(
      text: json['text'] as String,
      left: (json['left'] as num).toDouble(),
      top: (json['top'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
    );

Map<String, dynamic> _$OCRBlockToJson(_OCRBlock instance) => <String, dynamic>{
      'text': instance.text,
      'left': instance.left,
      'top': instance.top,
      'width': instance.width,
      'height': instance.height,
    };

_OCRResult _$OCRResultFromJson(Map<String, dynamic> json) => _OCRResult(
      text: json['text'] as String,
      blocks: (json['blocks'] as List<dynamic>?)
              ?.map((e) => OCRBlock.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$OCRResultToJson(_OCRResult instance) =>
    <String, dynamic>{
      'text': instance.text,
      'blocks': instance.blocks.map((e) => e.toJson()).toList(),
      'confidence': instance.confidence,
    };
