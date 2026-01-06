/// # OCR Result Model (Schema V2)
///
/// ## Description
/// 存储图片 OCR 识别的结果，支持多层级结构（Page -> Block -> Line -> Element）和坐标归一化。
///
/// ## Fields
/// - `text`: 识别出的完整文本.
/// - `pages`: 页面列表（Schema V2 新增）.
/// - `confidence`: 识别的总体置信度 (0.0 - 1.0).
/// - `source`: 识别引擎来源 (e.g., ios_vision, google_mlkit).
/// - `language`: 识别语言.
/// - `timestamp`: 识别发生的时间.
/// - `version`: 数据模型版本 (V1=Pixels, V2=Ratios).
///
/// ## Security
/// - 此对象通常作为 OCR 引擎的直接输出，用于后续的结构化提取及入库。
/// - 符合 `Constitution#VII. Coding Standards`。
///
/// ## Repair Logs
/// [2026-01-06] 修复：统一模型至 Schema V2，引入 OcrPage 层级，规范 PascalCase 命名，并强化 MethodChannel 通讯的向后兼容性。
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'ocr_result.freezed.dart';
part 'ocr_result.g.dart';

/// 语义类型，用于增强 OCR 结果的语义表达
enum OcrSemanticType {
  @JsonValue('normal')
  normal,
  @JsonValue('label')
  label,
  @JsonValue('value')
  value,
  @JsonValue('section_title')
  sectionTitle,
}

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
abstract class OcrElement with _$OcrElement {
  const factory OcrElement({
    required String text,
    @JsonKey(readValue: _readX) required double x,
    @JsonKey(readValue: _readY) required double y,
    @JsonKey(readValue: _readW) required double w,
    @JsonKey(readValue: _readH) required double h,
    @Default(0.0) double confidence,
    @Default(OcrSemanticType.normal) OcrSemanticType type,
  }) = _OcrElement;

  factory OcrElement.fromJson(Map<String, dynamic> json) =>
      _$OcrElementFromJson(json);
}

@freezed
abstract class OcrLine with _$OcrLine {
  @JsonSerializable(explicitToJson: true)
  const factory OcrLine({
    required String text,
    @JsonKey(readValue: _readX) required double x,
    @JsonKey(readValue: _readY) required double y,
    @JsonKey(readValue: _readW) required double w,
    @JsonKey(readValue: _readH) required double h,
    @Default([]) List<OcrElement> elements,
    @Default(0.0) double confidence,
    @Default(OcrSemanticType.normal) OcrSemanticType type,
  }) = _OcrLine;

  factory OcrLine.fromJson(Map<String, dynamic> json) =>
      _$OcrLineFromJson(json);
}

@freezed
abstract class OcrBlock with _$OcrBlock {
  @JsonSerializable(explicitToJson: true)
  const factory OcrBlock({
    required String text,
    @JsonKey(readValue: _readX) required double x,
    @JsonKey(readValue: _readY) required double y,
    @JsonKey(readValue: _readW) required double w,
    @JsonKey(readValue: _readH) required double h,
    @Default([]) List<OcrLine> lines,
    @Default(0.0) double confidence,
    @Default(OcrSemanticType.normal) OcrSemanticType type,
  }) = _OcrBlock;

  factory OcrBlock.fromJson(Map<String, dynamic> json) =>
      _$OcrBlockFromJson(json);
}

@freezed
abstract class OcrPage with _$OcrPage {
  @JsonSerializable(explicitToJson: true)
  const factory OcrPage({
    @Default(0) int pageNumber,
    @Default([]) List<OcrBlock> blocks,
    @Default(0.0) double confidence,
    @Default(0.0) double width,
    @Default(0.0) double height,
  }) = _OcrPage;

  factory OcrPage.fromJson(Map<String, dynamic> json) =>
      _$OcrPageFromJson(json);
}

/// 兼容 V1 结构的读取逻辑：如果不存在 pages 但存在 blocks，则将 blocks 包装为单页
Object? _readPages(Map<dynamic, dynamic> json, String key) {
  if (json['pages'] != null) return json['pages'];
  if (json['blocks'] != null) {
    return [
      {
        'pageNumber': 0,
        'blocks': json['blocks'],
      }
    ];
  }
  return null;
}

@freezed
abstract class OcrResult with _$OcrResult {
  @JsonSerializable(explicitToJson: true)
  const factory OcrResult({
    required String text,
    @JsonKey(readValue: _readPages) @Default([]) List<OcrPage> pages,
    @Default(0.0) double confidence,

    // Metadata (V2)
    @Default('unknown') String source, // e.g., 'ios_vision', 'google_mlkit'
    @Default('auto') String language,
    DateTime? timestamp,
    @Default(2) int version, // V2
  }) = _OcrResult;

  factory OcrResult.fromJson(Map<String, dynamic> json) =>
      _$OcrResultFromJson(json);

  /// 辅助 Getter: 为了兼容旧代码，提供 blocks 快捷访问（仅限第一页）
  const OcrResult._();
  List<OcrBlock> get blocks => pages.isNotEmpty ? pages.first.blocks : [];
}

// --- Legacy Type Aliases for Gradual Migration ---
typedef OCRResult = OcrResult;
typedef OCRBlock = OcrBlock;
typedef OCRLine = OcrLine;
typedef OCRTextElement = OcrElement;
typedef OCRSemanticType = OcrSemanticType;