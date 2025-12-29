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

import 'dart:convert';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:path/path.dart' as p;
import '../../../core/security/master_key_manager.dart';
import '../../../core/services/path_provider_service.dart';

class SQLCipherDatabaseService {
  static const String _dbName = 'phf_encrypted.db';
  static const int _dbVersion = 1;

  final MasterKeyManager _keyManager;
  final PathProviderService _pathService;

  Database? _database;

  SQLCipherDatabaseService({
    required MasterKeyManager keyManager,
    required PathProviderService pathService,
  })  : _keyManager = keyManager,
        _pathService = pathService;

  /// 获取数据库实例
  ///
  /// 如果尚未初始化，将触发初始化流程。
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// 关闭数据库连接
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  Future<Database> _initDatabase() async {
    final dbPath = _pathService.getDatabasePath(_dbName);
    
    // 从安全存储获取 Master Key
    // SQLCipher 接受字符串作为密码。我们将 32 字节的二进制 Key 转为 Base64 字符串传递。
    final rawKey = await _keyManager.getMasterKey();
    final password = base64Encode(rawKey);

    return await openDatabase(
      dbPath,
      version: _dbVersion,
      password: password,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
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

  Future<void> _onCreate(Database db, int version) async {
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
        width           INTEGER,
        height          INTEGER,
        mime_type       TEXT DEFAULT 'image/webp',
        file_size       INTEGER,
        page_index      INTEGER DEFAULT 0,
        ocr_text        TEXT,
        ocr_raw_json    TEXT,
        ocr_confidence  REAL,
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

    await batch.commit();
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Phase 1 暂无迁移逻辑
  }
}
