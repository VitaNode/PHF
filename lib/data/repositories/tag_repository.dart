/// # TagRepository Implementation
///
/// ## Description
/// `ITagRepository` 具体实现。
///
/// ## Security
/// - SQLCipher 加密存储。
///
/// ## Logic
/// - **Sync**: 删除标签时，需手动更新 `images.tags` 字段，因为该字段是 JSON 缓存。
/// - **Filtering**: 支持 `personId` 隔离。
///
/// ## 修复记录
/// - [issue#14] 重构 `deleteTag` 逻辑，消除 `dynamic` 类型的使用，增强类型安全性，符合 Constitution 规范。
library;

import 'dart:convert';
import 'package:sqflite_sqlcipher/sqflite.dart';
import '../datasources/local/database_service.dart';
import '../models/tag.dart';
import 'interfaces/tag_repository.dart';

class TagRepository implements ITagRepository {
  final SQLCipherDatabaseService _dbService;

  TagRepository(this._dbService);

  @override
  Future<List<Tag>> getAllTags({String? personId}) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps;

    if (personId != null) {
      maps = await db.query(
        'tags',
        where: 'person_id = ? OR person_id IS NULL',
        whereArgs: [personId],
        orderBy: 'order_index ASC, created_at_ms DESC',
      );
    } else {
      // Return all tags if no person specified? Or just global?
      // Usually admin or debug mode might want all.
      maps = await db.query(
        'tags',
        orderBy: 'order_index ASC, created_at_ms DESC',
      );
    }

    return maps.map((row) => _mapToTag(row)).toList();
  }

  @override
  Future<void> createTag(Tag tag) async {
    final db = await _dbService.database;
    await db.insert(
      'tags',
      _mapToDb(tag),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateTag(Tag tag) async {
    final db = await _dbService.database;
    await db.update(
      'tags',
      _mapToDb(tag),
      where: 'id = ?',
      whereArgs: [tag.id],
    );
  }

  @override
  Future<void> deleteTag(String id) async {
    final db = await _dbService.database;

    await db.transaction((txn) async {
      // 1. Delete from tags table
      // Foreign key constraints on 'image_tags' should handle the link table if configured with ON DELETE CASCADE.
      // SQLCipherDatabaseService has 'PRAGMA foreign_keys = ON' and 'ON DELETE CASCADE' in schema.
      await txn.delete('tags', where: 'id = ?', whereArgs: [id]);

      // 2. Cascade update 'images.tags' cache
      // Fetch all images that *might* contain this tag.
      // Since 'tags' column is a JSON list of IDs like ["id1", "id2"], use LIKE to find candidates.
      final candidates = await txn.query(
        'images',
        columns: ['id', 'tags'],
        where: 'tags LIKE ?',
        whereArgs: ['%"$id"%'],
      );

      for (var row in candidates) {
        final imageId = row['id'] as String;
        final tagsStr = row['tags'] as String?;
        if (tagsStr == null) continue;

        try {
          final decoded = jsonDecode(tagsStr);
          if (decoded is! List) continue;
          
          final currentTags = decoded.map((e) => e.toString()).toList();
          final newTags = currentTags.where((t) => t != id).toList();

          if (newTags.length != currentTags.length) {
            await txn.update(
              'images',
              {'tags': jsonEncode(newTags)},
              where: 'id = ?',
              whereArgs: [imageId],
            );
          }
        } catch (_) {
          // Ignore JSON parse errors, skip
        }
      }
    });
  }

  // --- Mappers ---

  Tag _mapToTag(Map<String, dynamic> row) {
    return Tag(
      id: row['id'] as String,
      personId: row['person_id'] as String?,
      name: row['name'] as String,
      color: (row['color'] as String?) ?? '#008080',
      orderIndex: row['order_index'] as int? ?? 0,
      isCustom: (row['is_custom'] as int? ?? 0) == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        row['created_at_ms'] as int,
      ),
    );
  }

  Map<String, dynamic> _mapToDb(Tag tag) {
    return {
      'id': tag.id,
      'name': tag.name,
      'color': tag.color,
      'person_id': tag.personId,
      'order_index': tag.orderIndex,
      'is_custom': tag.isCustom ? 1 : 0,
      'created_at_ms': tag.createdAt.millisecondsSinceEpoch,
    };
  }
}
