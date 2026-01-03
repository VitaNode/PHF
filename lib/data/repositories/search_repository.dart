/// # SearchRepository Implementation
///
/// ## Description
/// `ISearchRepository` 的具体实现。
///
/// ## Security
/// - 基于 SQLCipher 加密环境。
/// - FTS5 索引存储在加密数据库内部。
///
/// ## Fix Record
/// - **2025-12-31**:
///   1. 实现 `syncRecordIndex` 以支持同 Record 下多图 OCR 文本的聚合检索。
///   2. 修复 `search` 结果映射中 `MedicalImage` 缺失及 `notedAt` null 转换问题。
library;

import 'dart:convert';
import '../models/image.dart';
import '../models/record.dart';
import 'base_repository.dart';
import 'interfaces/search_repository.dart';
import '../models/search_result.dart';

class SearchRepository extends BaseRepository implements ISearchRepository {
  SearchRepository(super.dbService);

  @override
  Future<List<SearchResult>> search(String query, String personId) async {
    final db = await dbService.database;
    
    // 执行 FTS5 全文搜索
    // JOIN records 表以获取元数据，并过滤 personId
    // snippet(index_name, column_index, start_tag, end_tag, ellipsis, max_tokens)
    final sql = '''
      SELECT r.*, snippet(ocr_search_index, 1, '<b>', '</b>', '...', 16) as snippet
      FROM records r
      JOIN ocr_search_index fts ON r.id = fts.record_id
      WHERE r.person_id = ? AND r.status != 'deleted' AND fts.content MATCH ?
      ORDER BY r.visit_date_ms DESC
      LIMIT 100
    ''';
    
    // FTS5 MATCH query syntax: simple words or phrases.
    // Ideally we should sanitize or prepare the query. 
    // SQLCipher FTS5 standard query.
    // If query is empty, this SQL might fail or return nothing. Caller should handle empty query check.

    final List<Map<String, dynamic>> maps = await db.rawQuery(sql, [personId, query]);
    
    if (maps.isEmpty) return [];

    final recordIds = maps.map((m) => m['id'] as String).toList();

    // Fetch Associated Images for N+1 optimization
    final String placeholders = List.filled(recordIds.length, '?').join(',');
    final List<Map<String, dynamic>> imageMaps = await db.query(
      'images',
      where: 'record_id IN ($placeholders)',
      whereArgs: recordIds,
      orderBy: 'page_index ASC',
    );

    // Group images by record_id
    final Map<String, List<MedicalImage>> imagesByRecord = {};
    for (var imgRow in imageMaps) {
      final rid = imgRow['record_id'] as String;
      imagesByRecord.putIfAbsent(rid, () => []);
      
      // Use the same mapping logic as RecordRepository or similar
      final List<String> tagIds = [];
      if (imgRow['tags'] != null) {
        try {
          final decoded = jsonDecode(imgRow['tags'] as String);
          if (decoded is List) tagIds.addAll(List<String>.from(decoded));
        } catch (_) {}
      }

      imagesByRecord[rid]!.add(MedicalImage.fromJson({
        'id': imgRow['id'],
        'recordId': imgRow['record_id'],
        'encryptionKey': imgRow['encryption_key'],
        'thumbnailEncryptionKey': imgRow['thumbnail_encryption_key'] ?? imgRow['encryption_key'],
        'filePath': imgRow['file_path'],
        'thumbnailPath': imgRow['thumbnail_path'],
        'mimeType': imgRow['mime_type'],
        'fileSize': imgRow['file_size'],
        'displayOrder': imgRow['page_index'],
        'width': imgRow['width'],
        'height': imgRow['height'],
        'ocrText': imgRow['ocr_text'],
        'ocrRawJson': imgRow['ocr_raw_json'],
        'ocrConfidence': imgRow['ocr_confidence'],
        'hospitalName': imgRow['hospital_name'],
        'visitDate': imgRow['visit_date_ms'] != null 
            ? DateTime.fromMillisecondsSinceEpoch(imgRow['visit_date_ms'] as int).toIso8601String() 
            : null,
        'createdAt': DateTime.fromMillisecondsSinceEpoch(imgRow['created_at_ms'] as int).toIso8601String(),
        'tagIds': tagIds,
      }));
    }

    return maps.map((m) {
      final rid = m['id'] as String;
      final createdAtMs = m['created_at_ms'] as int;
      final visitDateMs = m['visit_date_ms'] as int?;

      final record = MedicalRecord(
        id: rid,
        personId: m['person_id'] as String,
        hospitalName: m['hospital_name'] as String?,
        notes: m['notes'] as String?,
        notedAt: visitDateMs != null 
            ? DateTime.fromMillisecondsSinceEpoch(visitDateMs)
            : DateTime.fromMillisecondsSinceEpoch(createdAtMs),
        visitEndDate: m['visit_end_date_ms'] != null 
            ? DateTime.fromMillisecondsSinceEpoch(m['visit_end_date_ms'] as int) 
            : null,
        createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMs),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(m['updated_at_ms'] as int),
        status: RecordStatus.values.firstWhere((e) => e.name == m['status']),
        tagsCache: m['tags_cache'] as String?,
        images: imagesByRecord[rid] ?? [],
      );

      return SearchResult(
        record: record,
        snippet: m['snippet'] as String? ?? '',
      );
    }).toList();
  }

  @override
  Future<void> updateIndex(String recordId, String content) async {
    final db = await dbService.database;
    
    // SQLite FTS5 不支持直接 REPLACE，通常先 DELETE 再 INSERT
    await db.transaction((txn) async {
      await txn.delete('ocr_search_index', where: 'record_id = ?', whereArgs: [recordId]);
      await txn.insert('ocr_search_index', {
        'record_id': recordId,
        'content': content,
      });
    });
  }

  @override
  Future<void> syncRecordIndex(String recordId) async {
    final db = await dbService.database;

    // 1. 获取该 Record 下所有图片的 OCR 文本
    final List<Map<String, dynamic>> maps = await db.query(
      'images',
      columns: ['ocr_text'],
      where: 'record_id = ? AND ocr_text IS NOT NULL',
      whereArgs: [recordId],
      orderBy: 'page_index ASC',
    );

    if (maps.isEmpty) {
      await deleteIndex(recordId);
      return;
    }

    // 2. 合并文本
    final fullText = maps.map((m) => m['ocr_text'] as String).join('\n\n');

    // 3. 更新索引
    await updateIndex(recordId, fullText);
  }

  @override
  Future<void> deleteIndex(String recordId) async {
    final db = await dbService.database;
    await db.delete('ocr_search_index', where: 'record_id = ?', whereArgs: [recordId]);
  }
}
