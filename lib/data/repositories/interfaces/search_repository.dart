/// # ISearchRepository Interface
///
/// ## Description
/// 全文搜索业务契约。
/// 基于 FTS5 实现高效的 OCR 文本检索。
///
/// ## Functions
/// - `search`: 执行全文搜索并返回匹配的 Record 列表.
/// - `updateIndex`: 更新搜索索引.
/// - `syncRecordIndex`: 聚合 Record 下所有图片的 OCR 文本并更新索引.
library;

import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../models/search_result.dart';

abstract interface class ISearchRepository {
  /// 执行全文搜索
  /// 返回符合条件的 SearchResult 列表（包含片段高亮）
  Future<List<SearchResult>> search(
    String query,
    String personId, {
    DatabaseExecutor? executor,
  });

  /// 更新或插入 OCR 索引
  Future<void> updateIndex(
    String recordId,
    String content, {
    DatabaseExecutor? executor,
  });

  /// 聚合 Record 下所有图片的 OCR 文本并更新索引
  Future<void> syncRecordIndex(String recordId, {DatabaseExecutor? executor});

  /// 删除索引
  Future<void> deleteIndex(String recordId, {DatabaseExecutor? executor});

  /// 全量重索引
  Future<void> reindexAll();
}
