/// # OCR Result Model (Schema V2)
///
/// ## Description
/// 存储图片 OCR 识别的结果，支持多层级结构（Block -> Line -> Element）和坐标归一化。
///
/// ## Fields
/// - `text`: 识别出的完整文本.
/// - `blocks`: 结构化区块列表.
/// - `confidence`: 识别的总体置信度 (0.0 - 1.0).
/// - `source`: 识别引擎来源 (e.g., ios_vision, google_mlkit).
/// - `language`: 识别语言.
/// - `timestamp`: 识别发生的时间.
/// - `version`: 数据模型版本 (V1=Pixels, V2=Ratios).
///
/// ## Security
/// - 此对象通常作为 OCR 引擎的直接输出，用于后续的结构化提取及入库。
/// - 符合 `Constitution#VII. Coding Standards`。
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'ocr_result.freezed.dart';
part 'ocr_result.g.dart';

/// 坐标辅助读取函数，支持 Schema V1 (left, top, width, height) 和 V2 (x, y, w, h)
double _readX(Map<dynamic, dynamic> json, String key) =>
    (json['x'] ?? json['left'] ?? 0.0) as double;
double _readY(Map<dynamic, dynamic> json, String key) =>
    (json['y'] ?? json['top'] ?? 0.0) as double;
double _readW(Map<dynamic, dynamic> json, String key) =>
    (json['w'] ?? json['width'] ?? 0.0) as double;
double _readH(Map<dynamic, dynamic> json, String key) =>
    (json['h'] ?? json['height'] ?? 0.0) as double;

@freezed
abstract class OCRTextElement with _$OCRTextElement {
  const factory OCRTextElement({
    required String text,
    @JsonKey(readValue: _readX) required double x,
    @JsonKey(readValue: _readY) required double y,
    @JsonKey(readValue: _readW) required double w,
    @JsonKey(readValue: _readH) required double h,
    @Default(0.0) double confidence,
  }) = _OCRTextElement;

  factory OCRTextElement.fromJson(Map<String, dynamic> json) =>
      _$OCRTextElementFromJson(json);
}

@freezed
abstract class OCRLine with _$OCRLine {
  @JsonSerializable(explicitToJson: true)
  const factory OCRLine({
    required String text,
    @JsonKey(readValue: _readX) required double x,
    @JsonKey(readValue: _readY) required double y,
    @JsonKey(readValue: _readW) required double w,
    @JsonKey(readValue: _readH) required double h,
    @Default([]) List<OCRTextElement> elements,
    @Default(0.0) double confidence,
  }) = _OCRLine;

  factory OCRLine.fromJson(Map<String, dynamic> json) =>
      _$OCRLineFromJson(json);
}

@freezed
abstract class OCRBlock with _$OCRBlock {
  @JsonSerializable(explicitToJson: true)
  const factory OCRBlock({
    required String text,
    @JsonKey(readValue: _readX) required double x,
    @JsonKey(readValue: _readY) required double y,
    @JsonKey(readValue: _readW) required double w,
    @JsonKey(readValue: _readH) required double h,
    @Default([]) List<OCRLine> lines,
  }) = _OCRBlock;

  factory OCRBlock.fromJson(Map<String, dynamic> json) =>
      _$OCRBlockFromJson(json);
}

@freezed
abstract class OCRResult with _$OCRResult {
  @JsonSerializable(explicitToJson: true)
  const factory OCRResult({
    required String text,
    @Default([]) List<OCRBlock> blocks,
    @Default(0.0) double confidence,

    // Metadata (V2)
    @Default('unknown') String source, // e.g., 'ios_vision', 'google_mlkit'
    @Default('auto') String language,
    DateTime? timestamp,
    @Default(1) int version, // Default to 1 for old data compatibility
  }) = _OCRResult;

  factory OCRResult.fromJson(Map<String, dynamic> json) =>
      _$OCRResultFromJson(json);
}
