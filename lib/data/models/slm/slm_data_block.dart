/// # SLM Data Block Entity
///
/// ## Description
/// 用于 SLM (Phase 5) 输入的结构化数据块。
/// 包含原始 OCR 文本、布局信息、置信度以及经过隐私脱敏和归一化处理后的数据。
///
/// ## Fields
/// - `rawText`: OCR 原始文本.
/// - `normalizedText`: 经过单位归一化和隐私脱敏后的文本.
/// - `confidence`: 平均置信度 (0.0 - 1.0).
/// - `boundingBox`: 在原图中的归一化坐标 [x, y, w, h].
/// - `isPIIMasked`: 是否包含已被脱敏的个人隐私信息.
/// - `semanticLabel`: 语义标签 (e.g., #Header, #LabValue).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'slm_data_block.freezed.dart';
part 'slm_data_block.g.dart';

@freezed
abstract class SLMDataBlock with _$SLMDataBlock {
  const factory SLMDataBlock({
    required String rawText,
    String? normalizedText,
    @Default(1.0) double confidence,

    /// Normalized coordinates [x, y, w, h] (0.0 - 1.0)
    @Default([0.0, 0.0, 0.0, 0.0]) List<double> boundingBox,
    @Default(false) bool isPIIMasked,
    String? semanticLabel,
  }) = _SLMDataBlock;

  factory SLMDataBlock.fromJson(Map<String, dynamic> json) =>
      _$SLMDataBlockFromJson(json);
}
