/// # SearchRepository Implementation
///
/// ## Description
/// `ISearchRepository` 的具体实现。
///
/// ## Security
/// - 基于 SQLCipher 加密环境。
/// - FTS5 索引存储在加密数据库内部。
///
/// ## Repair Logs
/// [2026-01-06] 修复：重构了 `search` 方法，修复了严重的括号嵌套错误、逻辑断层及变量作用域问题；
/// 修正了 MedicalImage 构造函数参数（pageIndex, thumbnailEncryptionKey）；
/// 解决了 BaseRepository 缺失 db getter 的调用问题；
/// 优化了 FTS5 查询语法，直接引用表名以确保 MATCH 语义在不同 SQLite 版本下的稳定性。
/// [2026-01-06] 加固：在 FTS5 索引中引入 `person_id` 物理列，实现更深层的数据隔离与搜索安全。
/// [2026-01-06] 优化：改进了 CJK 分段逻辑与查询脱敏，修复了多词搜索回归问题，并确保 Snippet 还原的可读性。
/// [2026-01-08] 修复：提取 FtsHelper 工具类，统一全站 FTS5 查询脱敏与 CJK 处理逻辑。
library;

import 'dart:convert';
import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../core/utils/fts_helper.dart';
import '../models/image.dart';
import '../models/record.dart';
import 'base_repository.dart';
import 'interfaces/search_repository.dart';
import '../models/search_result.dart';

class SearchRepository extends BaseRepository implements ISearchRepository {
  SearchRepository(super.dbService);

  @override
  Future<List<SearchResult>> search(String query, String personId) async {
    final sanitizedQuery = FtsHelper.sanitizeQuery(query);
    if (sanitizedQuery.isEmpty) return [];

    final database = await dbService.database;

    try {
      final maps = await _executeSearchQuery(
        database,
        personId,
        sanitizedQuery,
      );
      if (maps.isEmpty) return [];

      final recordIds = maps.map((m) => m['id'] as String).toList();
      final imagesByRecord = await _fetchImagesForRecords(database, recordIds);

      return maps.map((m) => _mapToSearchResult(m, imagesByRecord)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> updateIndex(String recordId, String content) async {
    // Deprecated: Needs full context for person_id.
    final database = await dbService.database;
    final List<Map<String, dynamic>> records = await database.query(
      'records',
      columns: ['person_id'],
      where: 'id = ?',
      whereArgs: [recordId],
    );
    if (records.isEmpty) return;
    final personId = records.first['person_id'] as String;

    await database.transaction((txn) async {
      await txn.delete(
        'ocr_search_index',
        where: 'record_id = ?',
        whereArgs: [recordId],
      );
      await txn.insert('ocr_search_index', {
        'record_id': recordId,
        'person_id': personId,
        'content': FtsHelper.segmentCJK(content),
      });
    });
  }

  @override
  Future<void> syncRecordIndex(String recordId) async {
    final database = await dbService.database;

    await database.transaction((txn) async {
      // 1. Fetch Record Info
      final List<Map<String, dynamic>> recordRows = await txn.query(
        'records',
        columns: ['hospital_name', 'notes', 'person_id'],
        where: 'id = ?',
        whereArgs: [recordId],
      );

      if (recordRows.isEmpty) {
        await txn.delete(
          'ocr_search_index',
          where: 'record_id = ?',
          whereArgs: [recordId],
        );
        return;
      }

      final recordRow = recordRows.first;
      final hospitalName = recordRow['hospital_name'] as String? ?? '';
      final notes = recordRow['notes'] as String? ?? '';
      final personId = recordRow['person_id'] as String;

      // 2. Fetch Images Info (OCR Text & Tags)
      final List<Map<String, dynamic>> imageRows = await txn.query(
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
            if (decoded is List) {
              tagIds.addAll(decoded.map((e) => e.toString()));
            }
          } catch (_) {}
        }
      }

      // 3. Resolve Tag Names
      final StringBuffer tagNamesBuffer = StringBuffer();
      if (tagIds.isNotEmpty) {
        final placeholder = List.filled(tagIds.length, '?').join(',');
        final List<Map<String, dynamic>> tagRows = await txn.query(
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

      // 5. Update FTS Index with CJK segmentation
      await txn.delete(
        'ocr_search_index',
        where: 'record_id = ?',
        whereArgs: [recordId],
      );

      await txn.insert('ocr_search_index', {
        'record_id': recordId,
        'person_id': personId,
        'hospital_name': FtsHelper.segmentCJK(hospitalName),
        'tags': FtsHelper.segmentCJK(tagNames),
        'ocr_text': FtsHelper.segmentCJK(ocrText),
        'notes': FtsHelper.segmentCJK(notes),
        'content': FtsHelper.segmentCJK(content),
      });
    });
  }

  @override
  Future<void> deleteIndex(String recordId) async {
    final database = await dbService.database;
    await database.delete(
      'ocr_search_index',
      where: 'record_id = ?',
      whereArgs: [recordId],
    );
  }

  @override
  Future<void> reindexAll() async {
    final database = await dbService.database;
    final List<Map<String, dynamic>> records = await database.query(
      'records',
      columns: ['id'],
      where: "status != 'deleted'",
    );

    for (var row in records) {
      await syncRecordIndex(row['id'] as String);
    }
  }

  Future<List<Map<String, dynamic>>> _executeSearchQuery(
    Database database,
    String personId,
    String sanitizedQuery,
  ) async {
    // 强化隔离：在 FTS 表中直接过滤 person_id
    // snippet 列索引更新为 6 (content)
    const sql = '''
        SELECT r.*, snippet(ocr_search_index, 6, '<b>', '</b>', '...', 16) as snippet
        FROM records r
        INNER JOIN ocr_search_index ON r.id = ocr_search_index.record_id
        WHERE ocr_search_index.person_id = ? 
          AND r.person_id = ?
          AND r.status != 'deleted' 
          AND ocr_search_index MATCH ?
        ORDER BY r.visit_date_ms DESC
        LIMIT 100
      ''';

    return database.rawQuery(sql, [personId, personId, sanitizedQuery]);
  }

  Future<Map<String, List<MedicalImage>>> _fetchImagesForRecords(
    Database database,
    List<String> recordIds,
  ) async {
    final String placeholders = List.filled(recordIds.length, '?').join(',');
    final List<Map<String, dynamic>> imageMaps = await database.query(
      'images',
      where: 'record_id IN ($placeholders)',
      whereArgs: recordIds,
      orderBy: 'page_index ASC',
    );

    final Map<String, List<MedicalImage>> imagesByRecord = {};
    for (var imgRow in imageMaps) {
      final rid = imgRow['record_id'] as String;
      imagesByRecord.putIfAbsent(rid, () => []);

      final image = _mapToMedicalImage(imgRow);
      imagesByRecord[rid]!.add(image);
    }
    return imagesByRecord;
  }

  MedicalImage _mapToMedicalImage(Map<String, dynamic> imgRow) {
    final List<String> tagIds = [];
    if (imgRow['tags'] != null) {
      try {
        final decoded = jsonDecode(imgRow['tags'] as String);
        if (decoded is List) {
          tagIds.addAll(decoded.map((e) => e.toString()));
        }
      } catch (_) {}
    }

    return MedicalImage(
      id: imgRow['id'] as String,
      recordId: imgRow['record_id'] as String,
      filePath: imgRow['file_path'] as String,
      thumbnailPath: imgRow['thumbnail_path'] as String,
      encryptionKey: imgRow['encryption_key'] as String,
      thumbnailEncryptionKey:
          imgRow['thumbnail_encryption_key'] as String? ?? '',
      width: imgRow['width'] as int?,
      height: imgRow['height'] as int?,
      mimeType: imgRow['mime_type'] as String? ?? 'image/webp',
      fileSize: imgRow['file_size'] as int? ?? 0,
      displayOrder: imgRow['page_index'] as int? ?? 0,
      tagIds: tagIds,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        imgRow['created_at_ms'] as int,
      ),
      ocrText: imgRow['ocr_text'] as String?,
      ocrRawJson: imgRow['ocr_raw_json'] as String?,
      ocrConfidence:
          (imgRow['ocr_confidence'] ?? imgRow['confidence']) as double?,
      hospitalName: imgRow['hospital_name'] as String?,
      visitDate: imgRow['visit_date_ms'] != null
          ? DateTime.fromMillisecondsSinceEpoch(imgRow['visit_date_ms'] as int)
          : null,
    );
  }

  SearchResult _mapToSearchResult(
    Map<String, dynamic> m,
    Map<String, List<MedicalImage>> imagesByRecord,
  ) {
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
      status: RecordStatus.values.firstWhere(
        (e) => e.name == m['status'],
        orElse: () => RecordStatus.archived,
      ),
      tagsCache: m['tags_cache'] as String?,
      images: imagesByRecord[rid] ?? [],
    );

    return SearchResult(
      record: record,
      snippet: FtsHelper.desegmentCJK(m['snippet'] as String? ?? ''),
    );
  }
}
