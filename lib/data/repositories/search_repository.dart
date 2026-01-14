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
import 'base_repository.dart';
import 'interfaces/search_repository.dart';
import '../models/search_result.dart';

class SearchRepository extends BaseRepository implements ISearchRepository {
  SearchRepository(super.dbService);

  @override
  Future<List<SearchResult>> search(
    String query,
    String personId, {
    DatabaseExecutor? executor,
  }) async {
    final sanitizedQuery = FtsHelper.sanitizeQuery(query);
    if (sanitizedQuery.isEmpty) return [];

    final exec = await getExecutor(executor);

    try {
      // 1. 执行 FTS5 查询，获取 Record 数据及 Snippet
      final rawResults = await _executeFtsQuery(exec, personId, sanitizedQuery);
      if (rawResults.isEmpty) return [];

      final recordIds = rawResults.map((m) => m['id'] as String).toList();

      // 2. 批量预加载图片 (复用 BaseRepository 逻辑)
      final imagesMap = await fetchImagesForRecords(exec, recordIds);

      // 3. 映射为领域对象
      return rawResults.map((row) {
        final rid = row['id'] as String;
        return SearchResult(
          record: mapToRecord(row, imagesMap[rid] ?? []),
          snippet: FtsHelper.desegmentCJK(row['snippet'] as String? ?? ''),
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> updateIndex(
    String recordId,
    String content, {
    DatabaseExecutor? executor,
  }) async {
    final exec = await getExecutor(executor);
    final List<Map<String, dynamic>> records = await exec.query(
      'records',
      columns: ['person_id'],
      where: 'id = ?',
      whereArgs: [recordId],
    );
    if (records.isEmpty) return;
    final personId = records.first['person_id'] as String;

    Future<void> logic(DatabaseExecutor e) async {
      await e.delete(
        'ocr_search_index',
        where: 'record_id = ?',
        whereArgs: [recordId],
      );
      await e.insert('ocr_search_index', {
        'record_id': recordId,
        'person_id': personId,
        'content': FtsHelper.segmentCJK(content),
      });
    }

    if (executor == null && exec is Database) {
      await exec.transaction((txn) => logic(txn));
    } else {
      await logic(exec);
    }
  }

  @override
  Future<void> syncRecordIndex(
    String recordId, {
    DatabaseExecutor? executor,
  }) async {
    final exec = await getExecutor(executor);

    Future<void> logic(DatabaseExecutor e) async {
      // 1. Fetch Record Info
      final List<Map<String, dynamic>> recordRows = await e.query(
        'records',
        columns: ['hospital_name', 'notes', 'person_id'],
        where: 'id = ?',
        whereArgs: [recordId],
      );

      if (recordRows.isEmpty) {
        await e.delete(
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
      final List<Map<String, dynamic>> imageRows = await e.query(
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
        final List<Map<String, dynamic>> tagRows = await e.query(
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
      await e.delete(
        'ocr_search_index',
        where: 'record_id = ?',
        whereArgs: [recordId],
      );

      await e.insert('ocr_search_index', {
        'record_id': recordId,
        'person_id': personId,
        'hospital_name': FtsHelper.segmentCJK(hospitalName),
        'tags': FtsHelper.segmentCJK(tagNames),
        'ocr_text': FtsHelper.segmentCJK(ocrText),
        'notes': FtsHelper.segmentCJK(notes),
        'content': FtsHelper.segmentCJK(content),
      });
    }

    if (executor == null && exec is Database) {
      await exec.transaction((txn) => logic(txn));
    } else {
      await logic(exec);
    }
  }

  @override
  Future<void> deleteIndex(
    String recordId, {
    DatabaseExecutor? executor,
  }) async {
    final exec = await getExecutor(executor);
    await exec.delete(
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

  // --- Private Helpers ---

  Future<List<Map<String, dynamic>>> _executeFtsQuery(
    DatabaseExecutor exec,
    String personId,
    String sanitizedQuery,
  ) async {
    // 强化隔离：在 FTS 表中直接过滤 person_id
    // snippet 列索引对应 'content' 列，在 Schema 中为第 6 列 (0-indexed)
    const sql = '''
        SELECT r.*, snippet(ocr_search_index, 6, '<b>', '</b>', '...', 16) as snippet
        FROM records r
        INNER JOIN ocr_search_index fts ON r.id = fts.record_id
        WHERE fts.person_id = ? 
          AND r.person_id = ?
          AND r.status != 'deleted' 
          AND ocr_search_index MATCH ?
        ORDER BY r.visit_date_ms DESC
        LIMIT 100
      ''';

    return exec.rawQuery(sql, [personId, personId, sanitizedQuery]);
  }
}
