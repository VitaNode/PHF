/// # SearchRepository Implementation
///
/// ## Description
/// `ISearchRepository` 的具体实现。
///
/// ## Security
/// - 基于 SQLCipher 加密环境。
/// - FTS5 索引存储在加密数据库内部。
///
/// ## Updates
/// - **2026-01-05**:
///   - Repair: 增强 FTS5 查询安全性：对输入进行脱敏处理，防止 SQLite 语法错误。
///   - Repair: 增加异常捕获，确保搜索过程中的健壮性。
/// - **2026-01-04**:
///   - 升级同步逻辑以填充多字段 (hospital_name, tags, ocr_text, notes) 到 FTS5 索引。
/// - **2025-12-31**:
///   - 实现索引同步以支持同记录下多图 OCR 文本的聚合检索。
///   - 修复结果映射中图片数据缺失及日期转换问题。
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
    if (query.trim().isEmpty) return [];

    try {
      final db = await dbService.database;
      final sanitizedQuery = _sanitizeFts5Query(query);

      final sql = '''
        SELECT r.*, snippet(ocr_search_index, 5, '<b>', '</b>', '...', 16) as snippet
        FROM records r
        JOIN ocr_search_index fts ON r.id = fts.record_id
        WHERE r.person_id = ? AND r.status != 'deleted' AND ocr_search_index MATCH ?
        ORDER BY r.visit_date_ms DESC
        LIMIT 100
      ''';

      final List<Map<String, dynamic>> maps = await db.rawQuery(sql, [
        personId,
        sanitizedQuery,
      ]);

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

        final List<String> tagIds = [];
        if (imgRow['tags'] != null) {
          try {
            final decoded = jsonDecode(imgRow['tags'] as String);
            if (decoded is List) tagIds.addAll(List<String>.from(decoded));
          } catch (_) {}
        }

        imagesByRecord[rid]!.add(
          MedicalImage.fromJson({
            'id': imgRow['id'],
            'recordId': imgRow['record_id'],
            'encryptionKey': imgRow['encryption_key'],
            'thumbnailEncryptionKey':
                imgRow['thumbnail_encryption_key'] ?? imgRow['encryption_key'],
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
                ? DateTime.fromMillisecondsSinceEpoch(
                    imgRow['visit_date_ms'] as int,
                  ).toIso8601String()
                : null,
            'createdAt': DateTime.fromMillisecondsSinceEpoch(
              imgRow['created_at_ms'] as int,
            ).toIso8601String(),
            'tagIds': tagIds,
          }),
        );
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
              ? DateTime.fromMillisecondsSinceEpoch(
                  m['visit_end_date_ms'] as int,
                )
              : null,
          createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMs),
          updatedAt: DateTime.fromMillisecondsSinceEpoch(
            m['updated_at_ms'] as int,
          ),
          status: RecordStatus.values.firstWhere((e) => e.name == m['status']),
          tagsCache: m['tags_cache'] as String?,
          images: imagesByRecord[rid] ?? [],
        );

        return SearchResult(
          record: record,
          snippet: m['snippet'] as String? ?? '',
        );
      }).toList();
    } catch (e) {
      // Log error and return empty list to avoid crashing UI
      return [];
    }
  }

  /// 针对 FTS5 查询对输入进行脱敏
  ///
  /// 将输入按空格分词，并为每个词加上双引号并转义现有的双引号，
  /// 确保不会触发 FTS5 的语法错误（如 *、NEAR、AND 等特殊语义）。
  String _sanitizeFts5Query(String query) {
    final tokens = query.split(RegExp(r'\s+')).where((t) => t.isNotEmpty);
    if (tokens.isEmpty) return '';
    return tokens.map((t) => '"${t.replaceAll('"', '""')}"').join(' ');
  }

  @override
  Future<void> updateIndex(String recordId, String content) async {
    // Deprecated direct usage, but kept for interface compatibility if needed.
    // Ideally we should use syncRecordIndex for full updates.
    // If called directly, we assume content maps to 'content' column only,
    // or we might lose other columns.
    // For now, let's redirect to syncRecordIndex logic if possible,
    // but updateIndex signature is simple.
    // We will just update 'content' and leave others null/empty?
    // Or better, let's just implement it as "Update content column only".

    final db = await dbService.database;
    await db.transaction((txn) async {
      await txn.delete(
        'ocr_search_index',
        where: 'record_id = ?',
        whereArgs: [recordId],
      );
      await txn.insert('ocr_search_index', {
        'record_id': recordId,
        'content': content,
      });
    });
  }

  @override
  Future<void> syncRecordIndex(String recordId) async {
    final db = await dbService.database;

    // 1. Fetch Record Info
    final List<Map<String, dynamic>> recordRows = await db.query(
      'records',
      columns: ['hospital_name', 'notes'],
      where: 'id = ?',
      whereArgs: [recordId],
    );
    if (recordRows.isEmpty) {
      await deleteIndex(recordId);
      return;
    }
    final recordRow = recordRows.first;
    final hospitalName = recordRow['hospital_name'] as String? ?? '';
    final notes = recordRow['notes'] as String? ?? '';

    // 2. Fetch Images Info (OCR Text & Tags)
    final List<Map<String, dynamic>> imageRows = await db.query(
      'images',
      columns: ['ocr_text', 'tags'],
      where: 'record_id = ?',
      whereArgs: [recordId],
      orderBy: 'page_index ASC',
    );

    final StringBuffer ocrBuffer = StringBuffer();
    final Set<String> tagIds = {};

    for (var row in imageRows) {
      if (row['ocr_text'] != null) {
        ocrBuffer.writeln(row['ocr_text'] as String);
        ocrBuffer.writeln(); // Spacing
      }

      if (row['tags'] != null) {
        try {
          final decoded = jsonDecode(row['tags'] as String);
          if (decoded is List) tagIds.addAll(List<String>.from(decoded));
        } catch (_) {}
      }
    }

    // 3. Resolve Tag Names
    final StringBuffer tagNamesBuffer = StringBuffer();
    if (tagIds.isNotEmpty) {
      final placeholder = List.filled(tagIds.length, '?').join(',');
      final List<Map<String, dynamic>> tagRows = await db.query(
        'tags',
        columns: ['name'],
        where: 'id IN ($placeholder)',
        whereArgs: tagIds.toList(),
      );
      for (var row in tagRows) {
        tagNamesBuffer.write('${row['name']} ');
      }
    }

    final ocrText = ocrBuffer.toString();
    final tagNames = tagNamesBuffer.toString();

    // 4. Construct Content (Aggregate for fallback)
    final content = [hospitalName, tagNames, notes, ocrText].join('\n');

    // 5. Update FTS Index
    await db.transaction((txn) async {
      await txn.delete(
        'ocr_search_index',
        where: 'record_id = ?',
        whereArgs: [recordId],
      );
      await txn.insert('ocr_search_index', {
        'record_id': recordId,
        'hospital_name': hospitalName,
        'tags': tagNames,
        'ocr_text': ocrText,
        'notes': notes,
        'content': content,
      });
    });
  }

  @override
  Future<void> deleteIndex(String recordId) async {
    final db = await dbService.database;
    await db.delete(
      'ocr_search_index',
      where: 'record_id = ?',
      whereArgs: [recordId],
    );
  }
}
