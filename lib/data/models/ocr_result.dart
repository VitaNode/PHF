/// # OCR Result Model
///
/// ## Description
/// 存储图片 OCR 识别的结果，包括全文文本、结构化区块及置信度。
///
/// ## Fields
/// - `text`: 识别出的完整文本.
/// - `blocks`: 识别出的结构化区块列表.
/// - `confidence`: 识别的总体置信度 (0.0 - 1.0).
///
/// ## Security
/// - 此对象通常作为 OCR 引擎的直接输出，用于后续的结构化提取及入库。
/// - 符合 `Constitution#VII. Coding Standards`。
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'ocr_result.freezed.dart';
part 'ocr_result.g.dart';

@freezed
abstract class OCRBlock with _$OCRBlock {
  const factory OCRBlock({
    required String text,
    required double left,
    required double top,
    required double width,
    required double height,
  }) = _OCRBlock;

  factory OCRBlock.fromJson(Map<String, dynamic> json) => _$OCRBlockFromJson(json);
}

@freezed
abstract class OCRResult with _$OCRResult {
  @JsonSerializable(explicitToJson: true)
  const factory OCRResult({
    required String text,
    @Default([]) List<OCRBlock> blocks,
    @Default(0.0) double confidence,
  }) = _OCRResult;

  factory OCRResult.fromJson(Map<String, dynamic> json) => _$OCRResultFromJson(json);
}
