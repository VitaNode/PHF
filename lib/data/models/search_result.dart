/// # Search Result Model
///
/// ## Description
/// 包含全量 Record 对象及 FTS5 搜索摘要（Snippet）。
///
/// ## Fields
/// - `record`: 完整的病历对象。
/// - `snippet`: 包含高亮标签（如 `<b>match</b>`）的文本摘要。
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'record.dart';

part 'search_result.freezed.dart';

@freezed
abstract class SearchResult with _$SearchResult {
  const factory SearchResult({
    required MedicalRecord record,
    /// 包含高亮 HTML 标签的摘要
    required String snippet,
  }) = _SearchResult;
}
