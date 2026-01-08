/// # ImageRepository Implementation
///
/// ## Description
/// `IImageRepository` 的具体实现。负责 `MedicalImage` 的持久化及标签关联。
///
/// ## Security
/// - 仅操作元数据（密钥、路径等），不直接处理文件字节流。
///
/// ## Sync Logic (Critical)
/// - `updateImageTags`: 采用事务机制。
///   1. 更新 `image_tags` 关联表。
///   2. 聚合查询该 Image 所属 Record 下的所有 Image 的所有 Tag。
///   3. 更新 `records.tags_cache` 字段，确保列表页查询性能。
library;

/// ## 修复记录
/// - **2025-12-31**: T21.2 级联删除逻辑优化 - 当一个 Record 下的所有图片被用户手动删除后，
///   自动删除该 Record 实体及其关联的 OCR 队列任务。同时删除 FTS5 搜索索引中的相关记录。
/// - **2026-01-08**: 修复：在更新标签或元数据时，同步更新 FTS5 搜索索引以防止数据失真（Issue #98）。
import 'dart:convert';
import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../data/models/image.dart';
import 'base_repository.dart';
import 'interfaces/image_repository.dart';
import 'interfaces/search_repository.dart';

class ImageRepository extends BaseRepository implements IImageRepository {
  final ISearchRepository? _searchRepository;

  ImageRepository(super.dbService, {ISearchRepository? searchRepository})
    : _searchRepository = searchRepository;

  @override
  Future<void> saveImages(List<MedicalImage> images) async {
    final db = await dbService.database;
    final batch = db.batch();

    for (var image in images) {
      batch.insert('images', {
        'id': image.id,
        'record_id': image.recordId,
        'file_path': image.filePath,
        'thumbnail_path': image.thumbnailPath,
        'encryption_key': image.encryptionKey,
        'thumbnail_encryption_key': image.thumbnailEncryptionKey,
        'width': image.width,
        'height': image.height,
        'mime_type': image.mimeType,
        'file_size': image.fileSize,
        'page_index': image.displayOrder, // mapped
        'created_at_ms': image.createdAt.millisecondsSinceEpoch,
        'hospital_name': image.hospitalName,
        'visit_date_ms': image.visitDate?.millisecondsSinceEpoch,
        // Store tags (List<String> Ids) as JSON string in 'tags' column
        'tags': jsonEncode(image.tagIds),
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      // Handle Tags Relationship
      if (image.tagIds.isNotEmpty) {
        // 1. Insert into image_tags
        for (var tagId in image.tagIds) {
          batch.insert('image_tags', {
            'image_id': image.id,
            'tag_id': tagId,
          }, conflictAlgorithm: ConflictAlgorithm.ignore);
        }
      }
    }

    await batch.commit();

    // After commit, sync cache for distinct records
    // Optimization: Collect distinct recordIds involved
    final recordIds = images.map((i) => i.recordId).toSet();

    // We can't do this inside the same batch easily if we want to run queries.
    // So distinct implementation is needed.
    // Actually `_syncRecordTagsCache` is async and runs queries.
    // We should do it inside a transaction ideally, but batch commit is atomic.
    // We can run sync after.
    await db.transaction((txn) async {
      for (var recordId in recordIds) {
        await _syncRecordTagsCache(txn, recordId);
        await _syncRecordMetadataCache(txn, recordId);
        // 同步 FTS 索引
        await _searchRepository?.syncRecordIndex(recordId);
      }
    });
  }

  @override
  Future<List<MedicalImage>> getImagesForRecord(String recordId) async {
    final db = await dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'images',
      where: 'record_id = ?',
      whereArgs: [recordId],
      orderBy: 'page_index ASC',
    );

    return maps.map((row) => _mapToImage(row)).toList();
  }

  @override
  Future<void> deleteImage(String imageId) async {
    final db = await dbService.database;
    // Get recordId before deletion for sync
    final List<Map<String, dynamic>> maps = await db.query(
      'images',
      columns: ['record_id'],
      where: 'id = ?',
      whereArgs: [imageId],
    );

    if (maps.isEmpty) return;
    final String recordId = maps.first['record_id'] as String;

    await db.transaction((txn) async {
      // 1. Delete OCR Task for this image
      await txn.delete(
        'ocr_queue',
        where: 'image_id = ?',
        whereArgs: [imageId],
      );

      // 2. Delete image and its tags
      await txn.delete('images', where: 'id = ?', whereArgs: [imageId]);
      await txn.delete(
        'image_tags',
        where: 'image_id = ?',
        whereArgs: [imageId],
      );

      // 3. Check remaining images for this record
      final List<Map<String, dynamic>> remaining = await txn.rawQuery(
        'SELECT COUNT(*) as count FROM images WHERE record_id = ?',
        [recordId],
      );
      final int count = Sqflite.firstIntValue(remaining) ?? 0;

      if (count == 0) {
        // 4. No images left, delete the entire Record and its search index
        await txn.delete('records', where: 'id = ?', whereArgs: [recordId]);
        await txn.delete(
          'ocr_search_index',
          where: 'record_id = ?',
          whereArgs: [recordId],
        );
      } else {
        // 5. Still has images, sync caches
        await _syncRecordTagsCache(txn, recordId);
        await _syncRecordMetadataCache(txn, recordId);
      }
    });
  }

  @override
  Future<void> updateImageTags(String imageId, List<String> tagIds) async {
    final db = await dbService.database;

    // Get recordId
    final List<Map<String, dynamic>> maps = await db.query(
      'images',
      columns: ['record_id'],
      where: 'id = ?',
      whereArgs: [imageId],
    );
    if (maps.isEmpty) return;
    final String recordId = maps.first['record_id'] as String;

    await db.transaction((txn) async {
      // 1. Update image tags column (local cache)
      await txn.update(
        'images',
        {'tags': jsonEncode(tagIds)},
        where: 'id = ?',
        whereArgs: [imageId],
      );

      // 2. Update relational table
      await txn.delete(
        'image_tags',
        where: 'image_id = ?',
        whereArgs: [imageId],
      );
      for (var tagId in tagIds) {
        await txn.insert('image_tags', {
          'image_id': imageId,
          'tag_id': tagId,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }

      // 3. Sync record cache
      await _syncRecordTagsCache(txn, recordId);

      // 4. 同步 FTS 索引 (因为标签名在索引中)
      await _searchRepository?.syncRecordIndex(recordId);
    });
  }

  @override
  Future<MedicalImage?> getImageById(String id) async {
    final db = await dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'images',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return _mapToImage(maps.first);
  }

  @override
  Future<void> updateImageMetadata(
    String imageId, {
    String? hospitalName,
    DateTime? visitDate,
  }) async {
    final db = await dbService.database;

    // Get recordId before update
    final List<Map<String, dynamic>> maps = await db.query(
      'images',
      columns: ['record_id'],
      where: 'id = ?',
      whereArgs: [imageId],
    );
    if (maps.isEmpty) return;
    final String recordId = maps.first['record_id'] as String;

    await db.transaction((txn) async {
      await txn.update(
        'images',
        {
          if (hospitalName != null) 'hospital_name': hospitalName,
          if (visitDate != null)
            'visit_date_ms': visitDate.millisecondsSinceEpoch,
        },
        where: 'id = ?',
        whereArgs: [imageId],
      );

      await _syncRecordMetadataCache(txn, recordId);

      // 同步 FTS 索引
      await _searchRepository?.syncRecordIndex(recordId);
    });
  }

  @override
  Future<void> updateOCRData(
    String imageId,
    String text, {
    String? rawJson,
    double confidence = 0.0,
  }) async {
    final db = await dbService.database;
    await db.update(
      'images',
      {'ocr_text': text, 'ocr_raw_json': rawJson, 'ocr_confidence': confidence},
      where: 'id = ?',
      whereArgs: [imageId],
    );
  }

  Future<void> _syncRecordTagsCache(Transaction txn, String recordId) async {
    // 1. Query all tags for this record
    // Join images -> image_tags -> tags to get Names
    final List<Map<String, dynamic>> results = await txn.rawQuery(
      '''
      SELECT DISTINCT t.name 
      FROM tags t
      INNER JOIN image_tags it ON t.id = it.tag_id
      INNER JOIN images i ON it.image_id = i.id
      WHERE i.record_id = ?
      ORDER BY t.created_at_ms ASC
    ''',
      [recordId],
    );

    final List<String> tagNames = results
        .map((row) => row['name'] as String)
        .toList();

    // 2. Update record
    await txn.update(
      'records',
      {'tags_cache': jsonEncode(tagNames)},
      where: 'id = ?',
      whereArgs: [recordId],
    );
  }

  Future<void> _syncRecordMetadataCache(
    DatabaseExecutor txn,
    String recordId,
  ) async {
    // 1. 获取所有属于该 Record 的图片汇总信息
    final List<Map<String, dynamic>> images = await txn.query(
      'images',
      columns: ['visit_date_ms', 'hospital_name'],
      where: 'record_id = ?',
      whereArgs: [recordId],
      orderBy: 'page_index ASC',
    );

    if (images.isEmpty) {
      // 如果没有图片了，可能需要重置或保持现状？
      // 通常删除最后一张图片会连带删除 Record（或者 Record 变为空）。
      // 这里如果图片为空，尝试清空缓存字段。
      await txn.update(
        'records',
        {
          'hospital_name': null,
          'visit_date_ms': null,
          'visit_date_iso': null,
          'visit_end_date_ms': null,
          'updated_at_ms': DateTime.now().millisecondsSinceEpoch,
        },
        where: 'id = ?',
        whereArgs: [recordId],
      );
      return;
    }

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

    // 2. 更新 records 表缓存
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
      await txn.update(
        'records',
        updates,
        where: 'id = ?',
        whereArgs: [recordId],
      );
    }
  }

  MedicalImage _mapToImage(Map<String, dynamic> row) {
    List<String> tags = [];
    if (row['tags'] != null) {
      try {
        final decoded = jsonDecode(row['tags'] as String);
        if (decoded is List) {
          tags = List<String>.from(decoded);
        }
      } catch (e) {
        // ignore parsing error
      }
    }

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
      'createdAt': DateTime.fromMillisecondsSinceEpoch(
        row['created_at_ms'] as int,
      ).toIso8601String(),
      'hospitalName': row['hospital_name'],
      'visitDate': row['visit_date_ms'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              row['visit_date_ms'] as int,
            ).toIso8601String()
          : null,
      'tagIds': tags,
    });
  }
}
