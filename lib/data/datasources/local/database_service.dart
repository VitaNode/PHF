/// # SQLCipherDatabaseService
///
/// ## Description
/// 管理应用的核心加密数据库 (SQLite + SQLCipher)。
/// 负责数据库的连接、加密配置、表结构初始化及版本迁移。
///
/// ## Security
/// - **Encryption**: AES-256 (via SQLCipher).
/// - **Password**: Derived from `MasterKeyManager` (Base64 encoded 32-byte key).
/// - **Settings**:
///   - `cipher_page_size`: 4096
///   - `kdf_iter`: 256000 (SQLCipher 4 default)
///   - `foreign_keys`: ON
///
/// ## Tables
/// - `persons`: 用户档案
/// - `records`: 就诊记录
/// - `images`: 图片索引
/// - `tags`: 标签定义
/// - `image_tags`: 标签关联
/// - `hospitals`: 医院数据
/// - `app_meta`: 应用元数据
/// - `ocr_search_index`: FTS5 全文索引
library;

import 'dart:convert';
import 'package:flutter/foundation.dart'; // for visibleForTesting
import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../../core/security/master_key_manager.dart';
import '../../../core/services/path_provider_service.dart';
import 'seeds/database_seeder.dart';

class SQLCipherDatabaseService {
  static const String _dbName = 'phf_encrypted.db';
  static const int _dbVersion = 5;

  final MasterKeyManager keyManager;
  final PathProviderService pathService;

  Database? _database;
  Future<Database>? _initFuture;

  SQLCipherDatabaseService({
    required this.keyManager,
    required this.pathService,
  });

  /// 获取数据库实例
  ///
  /// 如果尚未初始化，将触发初始化流程。
  Future<Database> get database async {
    if (_database != null) return _database!;
    
    // 如果已经在初始化中，等待同一个 Future
    if (_initFuture != null) return _initFuture!;

    _initFuture = _initDatabase();
    try {
      _database = await _initFuture;
      return _database!;
    } finally {
      // 无论成功失败，初始化流程已结束，但如果成功了 _database 就不是 null 了
      // 如果失败了，下次调用可以重试
      _initFuture = null;
    }
  }

  /// 关闭数据库连接
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  Future<Database> _initDatabase() async {
    final dbPath = pathService.getDatabasePath(_dbName);
    // 从安全存储获取 Master Key
    final rawKey = await keyManager.getMasterKey();
    final password = base64Encode(rawKey);

    return openDatabase(
      dbPath,
      version: _dbVersion,
      password: password,
      onConfigure: _onConfigure,
      onCreate: onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onConfigure(Database db) async {
    // 启用外键约束
    await db.execute('PRAGMA foreign_keys = ON');
    
    // 显式设置安全参数 (SQLCipher 4 Defaults but made explicit for future-proofing)
    // 4096 bytes page size aligns with most filesystems
    await db.execute('PRAGMA cipher_page_size = 4096'); 
    
    // 256,000 PBKDF2 iterations for key derivation
    await db.execute('PRAGMA kdf_iter = 256000');
  }

  @visibleForTesting
  Future<void> onCreate(Database db, int version) async {
    final batch = db.batch();

    // 1. Persons (多成员管理)
    batch.execute('''
      CREATE TABLE persons (
        id              TEXT PRIMARY KEY,
        nickname        TEXT NOT NULL,
        avatar_path     TEXT,
        is_default      INTEGER DEFAULT 0,
        created_at_ms   INTEGER NOT NULL
      )
    ''');

    // 2. Hospitals (医院标准库)
    batch.execute('''
      CREATE TABLE hospitals (
        id              TEXT PRIMARY KEY,
        name            TEXT NOT NULL,
        alias_json      TEXT,
        city            TEXT,
        created_at_ms   INTEGER NOT NULL
      )
    ''');

    // 3. Records (就诊事件)
    // 状态管理: 'archived' (默认/已归档), 'processing', 'review', 'deleted'
    batch.execute('''
      CREATE TABLE records (
        id              TEXT PRIMARY KEY,
        person_id       TEXT NOT NULL REFERENCES persons(id) ON DELETE CASCADE,
        status          TEXT NOT NULL DEFAULT 'archived',
        visit_date_ms   INTEGER,
        visit_date_iso  TEXT,
        hospital_name   TEXT,
        hospital_id     TEXT REFERENCES hospitals(id),
        notes           TEXT,
        tags_cache      TEXT,
        visit_end_date_ms INTEGER,
        created_at_ms   INTEGER NOT NULL,
        updated_at_ms   INTEGER NOT NULL
      )
    ''');

    // 4. Images (图片资源)
    // 注意: IV 存储在物理文件头部，不在此表存储。
    batch.execute('''
      CREATE TABLE images (
        id              TEXT PRIMARY KEY,
        record_id       TEXT NOT NULL REFERENCES records(id) ON DELETE CASCADE,
        file_path       TEXT NOT NULL,
        thumbnail_path  TEXT NOT NULL,
        encryption_key  TEXT NOT NULL,
        thumbnail_encryption_key TEXT NOT NULL,
        width           INTEGER,
        height          INTEGER,
        hospital_name   TEXT,
        visit_date_ms   INTEGER,
        mime_type       TEXT DEFAULT 'image/webp',
        file_size       INTEGER,
        page_index      INTEGER DEFAULT 0,
        ocr_text        TEXT,
        ocr_raw_json    TEXT,
        ocr_confidence  REAL,
        tags            TEXT,
        created_at_ms   INTEGER NOT NULL
      )
    ''');

    // 5. Tags (标签定义)
    batch.execute('''
      CREATE TABLE tags (
        id              TEXT PRIMARY KEY,
        name            TEXT NOT NULL UNIQUE,
        color           TEXT,
        order_index     INTEGER,
        person_id       TEXT REFERENCES persons(id) ON DELETE CASCADE,
        is_custom       INTEGER NOT NULL DEFAULT 0,
        created_at_ms   INTEGER NOT NULL
      )
    ''');

    // 6. Image Tags Association (图片-标签关联)
    batch.execute('''
      CREATE TABLE image_tags (
        image_id        TEXT NOT NULL REFERENCES images(id) ON DELETE CASCADE,
        tag_id          TEXT NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
        PRIMARY KEY (image_id, tag_id)
      )
    ''');

    // 7. App Meta (应用元数据)
    batch.execute('''
      CREATE TABLE app_meta (
        key             TEXT PRIMARY KEY,
        value           TEXT
      )
    ''');

    // 8. FTS5 Search Index (OCR 全文检索)
    // UNINDEXED: record_id 不参与分词，但可以被取回
    batch.execute('''
      CREATE VIRTUAL TABLE ocr_search_index USING fts5(
        record_id UNINDEXED, 
        content
      )
    ''');
    
    // 索引优化 (根据查询频率)
    batch.execute('CREATE INDEX idx_records_visit_date ON records(visit_date_ms)');
    batch.execute('CREATE INDEX idx_records_person_status ON records(person_id, status)');
    batch.execute('CREATE INDEX idx_images_record_order ON images(record_id, page_index)');

    // 9. 执行种子数据填充
    DatabaseSeeder.run(batch);

    await batch.commit();
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    final batch = db.batch();

    if (oldVersion < 2) {
      // Upgrade to v2: Add Tags Schema
      
      // 1. Add 'tags_cache' to records table
      // SQLite 'ADD COLUMN' adds it as NULLable.
      try {
        await db.execute('ALTER TABLE records ADD COLUMN tags_cache TEXT');
      } catch (_) {
        // Ignore if column exists (though unlikely in verified upgrade path)
      }

      // 2. Add 'tags' to images table
      try {
        await db.execute('ALTER TABLE images ADD COLUMN tags TEXT');
      } catch (_) {
        // Ignore
      }

      // 3. Create 'tags' table
      batch.execute('''
        CREATE TABLE IF NOT EXISTS tags (
          id              TEXT PRIMARY KEY,
          name            TEXT NOT NULL UNIQUE,
          color           TEXT,
          order_index     INTEGER,
          person_id       TEXT REFERENCES persons(id) ON DELETE CASCADE,
          is_custom       INTEGER NOT NULL DEFAULT 0,
          created_at_ms   INTEGER NOT NULL
        )
      ''');

      // 4. Create 'image_tags' table
      batch.execute('''
        CREATE TABLE IF NOT EXISTS image_tags (
          image_id        TEXT NOT NULL REFERENCES images(id) ON DELETE CASCADE,
          tag_id          TEXT NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
          PRIMARY KEY (image_id, tag_id)
        )
      ''');

      // 5. Seed System Tags (Copied from DatabaseSeeder logic)
      final now = DateTime.now().millisecondsSinceEpoch;
      final tags = [
        {'id': 'sys_tag_1', 'name': '检验', 'color': '#009688', 'order_index': 1}, 
        {'id': 'sys_tag_2', 'name': '检查', 'color': '#26A69A', 'order_index': 2}, 
        {'id': 'sys_tag_3', 'name': '病历', 'color': '#00796B', 'order_index': 3}, 
        {'id': 'sys_tag_4', 'name': '处方', 'color': '#4DB6AC', 'order_index': 4}, 
      ];

      for (var tag in tags) {
        batch.insert('tags', {
          'id': tag['id'],
          'name': tag['name'],
          'color': tag['color'],
          'order_index': tag['order_index'],
          'is_custom': 0,
          'created_at_ms': now,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
    }
    
    if (oldVersion < 3) {
      // Upgrade to v3: Add thumbnail_encryption_key to images
      try {
        await db.execute('ALTER TABLE images ADD COLUMN thumbnail_encryption_key TEXT');
        // For existing rows, we can't easily generate new random keys here without business logic,
        // so we migrate by copying encryption_key (which was the previous workaround).
        await db.execute('UPDATE images SET thumbnail_encryption_key = encryption_key WHERE thumbnail_encryption_key IS NULL');
      } catch (_) {
        // Ignore
      }
    }

    if (oldVersion < 4) {
      // Upgrade to v4: Add hospital_name and visit_date_ms to images
      try {
        await db.execute('ALTER TABLE images ADD COLUMN hospital_name TEXT');
        await db.execute('ALTER TABLE images ADD COLUMN visit_date_ms INTEGER');
        
        // Migrate data from parent record to existing images
        await db.execute('''
          UPDATE images 
          SET hospital_name = (SELECT hospital_name FROM records WHERE records.id = images.record_id),
              visit_date_ms = (SELECT visit_date_ms FROM records WHERE records.id = images.record_id)
          WHERE hospital_name IS NULL OR visit_date_ms IS NULL
        ''');
      } catch (_) {}
    }

    if (oldVersion < 5) {
      // Upgrade to v5: Add visit_end_date_ms to records
      try {
        await db.execute('ALTER TABLE records ADD COLUMN visit_end_date_ms INTEGER');
        
        // Initialize visit_end_date_ms with the same value as visit_date_ms for existing records
        await db.execute('UPDATE records SET visit_end_date_ms = visit_date_ms WHERE visit_end_date_ms IS NULL');
      } catch (_) {}
    }
    
    await batch.commit();
  }
}
