/// # RecordRepository Implementation
///
/// ## Description
/// `IRecordRepository` 的具体实现。负责 `MedicalRecord` 及其关联数据 (`MedicalImage` 元数据) 的持久化。
///
/// ## Security
/// - 所有数据读写均通过 `SQLCipherDatabaseService` 进行，确保存储加密。
///
/// ## Performance
/// - `getRecordById`: 执行一次查询获取主体，再一次查询获取所有关联图片。
/// - `getRecordsByPerson`: 仅获取 Record 主体列表（不预加载图片），以优化列表页性能。
///
/// ## Sync Logic
/// - `tagsCache`: 此字段由 `ImageRepository` 更新操作触发同步，本类仅负责读取和简单的写入。
///
/// ## 修复记录
/// - [issue#22] 实现 `searchRecords` 中的日期范围过滤逻辑。
library;

import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../core/utils/fts_helper.dart';
import '../../data/models/image.dart';
import '../../data/models/record.dart';
import 'base_repository.dart';
import 'interfaces/record_repository.dart';
import 'interfaces/search_repository.dart';

class RecordRepository extends BaseRepository implements IRecordRepository {
  final ISearchRepository? _searchRepository;

  RecordRepository(super.dbService, {ISearchRepository? searchRepository})
    : _searchRepository = searchRepository;

  @override
  Future<void> saveRecord(MedicalRecord record) async {
    final db = await dbService.database;

    // 手动映射字段以匹配数据库 Schema (snake_case)
    final dbMap = <String, dynamic>{
      'id': record.id,
      'person_id': record.personId,
      'hospital_name': record.hospitalName,
      'notes': record.notes,
      'visit_date_ms': record.notedAt.millisecondsSinceEpoch,
      'visit_date_iso': record.notedAt.toIso8601String(),
      'visit_end_date_ms': record.visitEndDate?.millisecondsSinceEpoch,
      'created_at_ms': record.createdAt.millisecondsSinceEpoch,
      'updated_at_ms': record.updatedAt.millisecondsSinceEpoch,
      'status': record.status.name, // 'archived', 'deleted'
      'tags_cache': record.tagsCache,
    };

    // images 不存入 records 表

    // 执行插入或更新
    await db.insert(
      'records',
      dbMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // 同步 FTS 索引
    await _searchRepository?.syncRecordIndex(record.id);
  }

  @override
  Future<MedicalRecord?> getRecordById(String id) async {
    final db = await dbService.database;

    // 1. Fetch Record
    final List<Map<String, dynamic>> maps = await db.query(
      'records',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    final row = maps.first;

    // 2. Fetch Associated Images
    // 按 page_index 排序
    final List<Map<String, dynamic>> imageMaps = await db.query(
      'images',
      where: 'record_id = ?',
      whereArgs: [id],
      orderBy: 'page_index ASC',
    );

    final images = imageMaps.map((m) => _mapToImage(m)).toList();

    return _mapToRecord(row, images);
  }

  @override
  Future<List<MedicalRecord>> getRecordsByPerson(String personId) async {
    final db = await dbService.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'records',
      where: 'person_id = ? AND status != ?',
      whereArgs: [personId, 'deleted'], // 默认不显示已删除
      orderBy: 'visit_date_ms DESC',
    );

    if (maps.isEmpty) return [];

    final recordIds = maps.map((m) => m['id'] as String).toList();

    // 优化：一次性获取所有相关的图片元数据，避免 N+1 查询
    final String placeholders = List.filled(recordIds.length, '?').join(',');
    final List<Map<String, dynamic>> imageMaps = await db.query(
      'images',
      where: 'record_id IN ($placeholders)',
      whereArgs: recordIds,
      orderBy: 'page_index ASC',
    );

    // 按 record_id 分组
    final Map<String, List<MedicalImage>> imagesByRecord = {};
    for (var imgMap in imageMaps) {
      final rid = imgMap['record_id'] as String;
      imagesByRecord.putIfAbsent(rid, () => []);
      imagesByRecord[rid]!.add(_mapToImage(imgMap));
    }

    return maps.map((m) {
      final rid = m['id'] as String;
      return _mapToRecord(m, imagesByRecord[rid] ?? []);
    }).toList();
  }

  @override
  Future<void> updateStatus(String id, RecordStatus status) async {
    final db = await dbService.database;
    await db.update(
      'records',
      {
        'status': status.name,
        'updated_at_ms': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    // 状态变更可能影响搜索可见性，建议同步
    await _searchRepository?.syncRecordIndex(id);
  }

  @override
  Future<void> updateRecordMetadata(
    String id, {
    String? hospitalName,
    DateTime? visitDate,
    String? notes,
  }) async {
    final db = await dbService.database;
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.update(
      'records',
      {
        if (hospitalName != null) 'hospital_name': hospitalName,
        if (visitDate != null) ...{
          'visit_date_ms': visitDate.millisecondsSinceEpoch,
          'visit_date_iso': visitDate.toIso8601String(),
        },
        if (notes != null) 'notes': notes,
        'updated_at_ms': now,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    // 元数据变更需同步 FTS
    await _searchRepository?.syncRecordIndex(id);
  }

  @override
  Future<void> hardDeleteRecord(String id) async {
    final db = await dbService.database;
    await db.delete('records', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<MedicalRecord>> searchRecords({
    required String personId,
    String? query,
    List<String>? tags,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await dbService.database;
    String sql;
    final List<dynamic> args = [];

    // 基础查询
    String whereClause = 'r.person_id = ? AND r.status != ?';
    args.add(personId);
    args.add('deleted');

    // 标签过滤
    if (tags != null && tags.isNotEmpty) {
      for (var tag in tags) {
        whereClause += ' AND r.tags_cache LIKE ?';
        args.add('%"$tag"%'); // 匹配 JSON 字符串
      }
    }

    // 日期范围过滤
    if (startDate != null) {
      whereClause += ' AND r.visit_date_ms >= ?';
      args.add(startDate.millisecondsSinceEpoch);
    }
    if (endDate != null) {
      whereClause += ' AND r.visit_date_ms <= ?';
      args.add(endDate.millisecondsSinceEpoch);
    }

    // 文本搜索 (OCR FTS5)
    if (query != null && query.isNotEmpty) {
      final sanitizedQuery = FtsHelper.sanitizeQuery(query);
      if (sanitizedQuery.isNotEmpty) {
        // JOIN FTS table
        // SELECT r.* FROM records r JOIN ocr_search_index fts ON r.id = fts.record_id WHERE ocr_search_index MATCH ?
        // 强化隔离：在 FTS 表中直接过滤 person_id
        sql =
            '''
          SELECT r.* 
          FROM records r
          JOIN ocr_search_index fts ON r.id = fts.record_id
          WHERE $whereClause 
            AND fts.person_id = ?
            AND ocr_search_index MATCH ?
          ORDER BY r.visit_date_ms DESC
        ''';
        args.add(personId); // for fts.person_id
        args.add(sanitizedQuery); // for ocr_search_index MATCH ?
      } else {
        sql =
            'SELECT r.* FROM records r WHERE $whereClause ORDER BY r.visit_date_ms DESC';
      }
    } else {
      sql =
          'SELECT r.* FROM records r WHERE $whereClause ORDER BY r.visit_date_ms DESC';
    }

    final List<Map<String, dynamic>> maps = await db.rawQuery(sql, args);
    return maps.map((m) => _mapToRecord(m, [])).toList();
  }

  @override
  Future<void> syncRecordMetadata(String recordId) async {
    final db = await dbService.database;

    // 1. 获取所有属于该 Record 的图片
    final List<Map<String, dynamic>> images = await db.query(
      'images',
      columns: ['visit_date_ms', 'hospital_name'],
      where: 'record_id = ?',
      whereArgs: [recordId],
      orderBy: 'page_index ASC',
    );

    if (images.isEmpty) return;

    int? minDate;
    int? maxDate;
    String? hospitalName;

    for (var img in images) {
      final date = img['visit_date_ms'] as int?;
      if (date != null) {
        if (minDate == null || date < minDate) minDate = date;
        if (maxDate == null || date > maxDate) maxDate = date;
      }

      if (hospitalName == null &&
          img['hospital_name'] != null &&
          (img['hospital_name'] as String).isNotEmpty) {
        hospitalName = img['hospital_name'] as String;
      }
    }

    // 2. 更新 records 表
    final Map<String, dynamic> updates = {};
    if (minDate != null) {
      updates['visit_date_ms'] = minDate;
      updates['visit_date_iso'] = DateTime.fromMillisecondsSinceEpoch(
        minDate,
      ).toIso8601String();
    }
    if (maxDate != null) {
      updates['visit_end_date_ms'] = maxDate;
    }
    if (hospitalName != null) {
      updates['hospital_name'] = hospitalName;
    }

    if (updates.isNotEmpty) {
      updates['updated_at_ms'] = DateTime.now().millisecondsSinceEpoch;
      await db.update(
        'records',
        updates,
        where: 'id = ?',
        whereArgs: [recordId],
      );
    }
  }

  @override
  Future<int> getPendingCount(String personId) async {
    final db = await dbService.database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM records WHERE person_id = ? AND status = ?',
      [personId, 'review'],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  @override
  Future<List<MedicalRecord>> getReviewRecords(String personId) async {
    final db = await dbService.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'records',
      where: 'person_id = ? AND status = ?',
      whereArgs: [personId, 'review'],
      orderBy: 'created_at_ms DESC', // Pending reviews typically in entry order
    );

    if (maps.isEmpty) return [];

    final recordIds = maps.map((m) => m['id'] as String).toList();

    // Fetch Images for N+1 optimization
    final String placeholders = List.filled(recordIds.length, '?').join(',');
    final List<Map<String, dynamic>> imageMaps = await db.query(
      'images',
      where: 'record_id IN ($placeholders)',
      whereArgs: recordIds,
      orderBy: 'page_index ASC',
    );

    final Map<String, List<MedicalImage>> imagesByRecord = {};
    for (var imgMap in imageMaps) {
      final rid = imgMap['record_id'] as String;
      imagesByRecord.putIfAbsent(rid, () => []);
      imagesByRecord[rid]!.add(_mapToImage(imgMap));
    }

    return maps.map((m) {
      final rid = m['id'] as String;
      return _mapToRecord(m, imagesByRecord[rid] ?? []);
    }).toList();
  }

  // --- Helpers ---

  MedicalRecord _mapToRecord(
    Map<String, dynamic> row,
    List<MedicalImage> images,
  ) {
    // 还原 DateTime
    final visitDateMs = row['visit_date_ms'] as int?;
    final createdAtMs = row['created_at_ms'] as int;
    final updatedAtMs = row['updated_at_ms'] as int;

    final notedAt = visitDateMs != null
        ? DateTime.fromMillisecondsSinceEpoch(visitDateMs)
        : DateTime.fromMillisecondsSinceEpoch(
            createdAtMs,
          ); // Fallback to creation date

    final visitEndDate = row['visit_end_date_ms'] != null
        ? DateTime.fromMillisecondsSinceEpoch(row['visit_end_date_ms'] as int)
        : null;
    final createdAt = DateTime.fromMillisecondsSinceEpoch(createdAtMs);
    final updatedAt = DateTime.fromMillisecondsSinceEpoch(updatedAtMs);

    // 还原 Status
    final statusStr = row['status'] as String;
    final status = RecordStatus.values.firstWhere(
      (e) => e.name == statusStr,
      orElse: () => RecordStatus.archived,
    );

    return MedicalRecord(
      id: row['id'] as String,
      personId: row['person_id'] as String,
      hospitalName: row['hospital_name'] as String?,
      notes: row['notes'] as String?,
      notedAt: notedAt,
      visitEndDate: visitEndDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
      status: status,
      tagsCache: row['tags_cache'] as String?,
      images: images,
    );
  }

  MedicalImage _mapToImage(Map<String, dynamic> row) {
    return MedicalImage.fromJson({
      'id': row['id'],
      'recordId': row['record_id'],
      'encryptionKey': row['encryption_key'],
      'thumbnailEncryptionKey':
          row['thumbnail_encryption_key'] ?? row['encryption_key'],
      'filePath': row['file_path'],
      'thumbnailPath': row['thumbnail_path'],
      'mimeType': row['mime_type'],
      'fileSize': row['file_size'],
      'displayOrder': row['page_index'],
      'width': row['width'],
      'height': row['height'],
      'ocrText': row['ocr_text'],
      'ocrRawJson': row['ocr_raw_json'],
      'ocrConfidence': row['ocr_confidence'],
      'hospitalName': row['hospital_name'],
      'visitDate': row['visit_date_ms'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              row['visit_date_ms'] as int,
            ).toIso8601String()
          : null,
      'createdAt': DateTime.fromMillisecondsSinceEpoch(
        row['created_at_ms'] as int,
      ).toIso8601String(),
    });
  }
}
