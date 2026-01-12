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
  Future<void> saveImages(
    List<MedicalImage> images, {
    DatabaseExecutor? executor,
  }) async {
    final exec = await getExecutor(executor);

    Future<void> logic(DatabaseExecutor e) async {
      final batch = e.batch();
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

      final recordIds = images.map((i) => i.recordId).toSet();
      for (var recordId in recordIds) {
        await _syncRecordTagsCache(e, recordId);
        await _syncRecordMetadataCache(e, recordId);
        // 同步 FTS 索引
        await _searchRepository?.syncRecordIndex(recordId, executor: e);
      }
    }

    if (executor == null && exec is Database) {
      await exec.transaction((txn) => logic(txn));
    } else {
      await logic(exec);
    }
  }

  @override
  Future<List<MedicalImage>> getImagesForRecord(
    String recordId, {
    DatabaseExecutor? executor,
  }) async {
    final exec = await getExecutor(executor);
    final List<Map<String, dynamic>> maps = await exec.query(
      'images',
      where: 'record_id = ?',
      whereArgs: [recordId],
      orderBy: 'page_index ASC',
    );

    return maps.map((row) => mapToImage(row)).toList();
  }

  @override
  Future<void> deleteImage(String imageId, {DatabaseExecutor? executor}) async {
    final exec = await getExecutor(executor);

    Future<void> logic(DatabaseExecutor e) async {
      // Get recordId before deletion for sync
      final List<Map<String, dynamic>> maps = await e.query(
        'images',
        columns: ['record_id'],
        where: 'id = ?',
        whereArgs: [imageId],
      );

      if (maps.isEmpty) return;
      final String recordId = maps.first['record_id'] as String;

      // 1. Delete OCR Task for this image
      await e.delete('ocr_queue', where: 'image_id = ?', whereArgs: [imageId]);

      // 2. Delete image and its tags
      await e.delete('images', where: 'id = ?', whereArgs: [imageId]);
      await e.delete('image_tags', where: 'image_id = ?', whereArgs: [imageId]);

      // 3. Check remaining images for this record
      final List<Map<String, dynamic>> remaining = await e.rawQuery(
        'SELECT COUNT(*) as count FROM images WHERE record_id = ?',
        [recordId],
      );
      final int count = Sqflite.firstIntValue(remaining) ?? 0;

      if (count == 0) {
        // 4. No images left, delete the entire Record and its search index
        await e.delete('records', where: 'id = ?', whereArgs: [recordId]);
        await e.delete(
          'ocr_search_index',
          where: 'record_id = ?',
          whereArgs: [recordId],
        );
      } else {
        // 5. Still has images, sync caches
        await _syncRecordTagsCache(e, recordId);
        await _syncRecordMetadataCache(e, recordId);
      }
    }

    if (executor == null && exec is Database) {
      await exec.transaction((txn) => logic(txn));
    } else {
      await logic(exec);
    }
  }

  @override
  Future<void> updateImageTags(
    String imageId,
    List<String> tagIds, {
    DatabaseExecutor? executor,
  }) async {
    final exec = await getExecutor(executor);

    Future<void> logic(DatabaseExecutor e) async {
      // Get recordId
      final List<Map<String, dynamic>> maps = await e.query(
        'images',
        columns: ['record_id'],
        where: 'id = ?',
        whereArgs: [imageId],
      );
      if (maps.isEmpty) return;
      final String recordId = maps.first['record_id'] as String;

      // 1. Update image tags column (local cache)
      await e.update(
        'images',
        {'tags': jsonEncode(tagIds)},
        where: 'id = ?',
        whereArgs: [imageId],
      );

      // 2. Update relational table
      await e.delete('image_tags', where: 'image_id = ?', whereArgs: [imageId]);
      for (var tagId in tagIds) {
        await e.insert('image_tags', {
          'image_id': imageId,
          'tag_id': tagId,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }

      // 3. Sync record cache
      await _syncRecordTagsCache(e, recordId);

      // 4. 同步 FTS 索引 (因为标签名在索引中)
      await _searchRepository?.syncRecordIndex(recordId, executor: e);
    }

    if (executor == null && exec is Database) {
      await exec.transaction((txn) => logic(txn));
    } else {
      await logic(exec);
    }
  }

  @override
  Future<MedicalImage?> getImageById(
    String id, {
    DatabaseExecutor? executor,
  }) async {
    final exec = await getExecutor(executor);
    final List<Map<String, dynamic>> maps = await exec.query(
      'images',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return mapToImage(maps.first);
  }

  @override
  Future<void> updateImageMetadata(
    String imageId, {
    String? hospitalName,
    DateTime? visitDate,
    DatabaseExecutor? executor,
  }) async {
    final exec = await getExecutor(executor);

    Future<void> logic(DatabaseExecutor e) async {
      // Get recordId before update
      final List<Map<String, dynamic>> maps = await e.query(
        'images',
        columns: ['record_id'],
        where: 'id = ?',
        whereArgs: [imageId],
      );
      if (maps.isEmpty) return;
      final String recordId = maps.first['record_id'] as String;

      await e.update(
        'images',
        {
          if (hospitalName != null) 'hospital_name': hospitalName,
          if (visitDate != null)
            'visit_date_ms': visitDate.millisecondsSinceEpoch,
        },
        where: 'id = ?',
        whereArgs: [imageId],
      );

      await _syncRecordMetadataCache(e, recordId);

      // 同步 FTS 索引
      await _searchRepository?.syncRecordIndex(recordId, executor: e);
    }

    if (executor == null && exec is Database) {
      await exec.transaction((txn) => logic(txn));
    } else {
      await logic(exec);
    }
  }

  @override
  Future<void> updateOCRData(
    String imageId,
    String text, {
    String? rawJson,
    double confidence = 0.0,
    DatabaseExecutor? executor,
  }) async {
    final exec = await getExecutor(executor);
    await exec.update(
      'images',
      {'ocr_text': text, 'ocr_raw_json': rawJson, 'ocr_confidence': confidence},
      where: 'id = ?',
      whereArgs: [imageId],
    );
  }

  Future<void> _syncRecordTagsCache(
    DatabaseExecutor exec,
    String recordId,
  ) async {
    // 1. Query all tags for this record
    // Use DISTINCT on tag_id
    final List<Map<String, dynamic>> results = await exec.rawQuery(
      '''
      SELECT DISTINCT it.tag_id
      FROM image_tags it
      INNER JOIN images i ON it.image_id = i.id
      WHERE i.record_id = ?
    ''',
      [recordId],
    );

    final List<String> tagIds = results
        .map((row) => row['tag_id'] as String)
        .toList();

    // 2. Update record
    await exec.update(
      'records',
      {'tags_cache': jsonEncode(tagIds)},
      where: 'id = ?',
      whereArgs: [recordId],
    );
  }

  Future<void> _syncRecordMetadataCache(
    DatabaseExecutor exec,
    String recordId,
  ) async {
    // 1. 获取所有属于该 Record 的图片汇总信息
    final List<Map<String, dynamic>> images = await exec.query(
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
      await exec.update(
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
      await exec.update(
        'records',
        updates,
        where: 'id = ?',
        whereArgs: [recordId],
      );
    }
  }
}
