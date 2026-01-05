// test/integration/tags_integration_test.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';

import 'package:phf/data/models/image.dart';
import 'package:phf/data/repositories/image_repository.dart';
import 'package:phf/data/repositories/tag_repository.dart';
import 'package:phf/data/datasources/local/database_service.dart';
import 'package:phf/core/security/master_key_manager.dart';
import 'package:phf/core/services/path_provider_service.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart'
    show sqfliteFfiInit, databaseFactoryFfi;
// Import the SAME package as the Source Code to ensure Type Compatibility
import 'package:sqflite_sqlcipher/sqflite.dart';

// Mock Services
class MockPathProviderService extends Mock implements PathProviderService {
  @override
  String getDatabasePath(String fileName) => p.join(
    Directory.systemTemp.path,
    'test_tags_${DateTime.now().millisecondsSinceEpoch}.db',
  );
  @override
  String get sandboxRoot => '/tmp';
}

class MockMasterKeyManager extends Mock implements MasterKeyManager {
  @override
  Future<Uint8List> getMasterKey() async =>
      Uint8List.fromList(List.filled(32, 1));
}

// Test Database Service that uses FFI and NO Encryption for testing
class TestDatabaseService extends SQLCipherDatabaseService {
  TestDatabaseService({required super.keyManager, required super.pathService});

  Database? _cachedDb;

  @override
  Future<Database> get database async {
    if (_cachedDb != null) return _cachedDb!;

    // Init FFI
    sqfliteFfiInit();

    final path = pathService.getDatabasePath('test.db');

    // Use factory directly
    final db = await databaseFactoryFfi.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await onCreate(db, version);
        },
      ),
    );
    _cachedDb = db;
    return _cachedDb!;
  }
}

void main() {
  late SQLCipherDatabaseService dbService;
  late ImageRepository imageRepo;
  late TagRepository tagRepo;

  setUp(() async {
    dbService = TestDatabaseService(
      keyManager: MockMasterKeyManager(),
      pathService: MockPathProviderService(),
    );
    // Init DB (triggers onCreate)
    await dbService.database;

    imageRepo = ImageRepository(dbService);
    tagRepo = TagRepository(
      dbService,
      Talker(settings: TalkerSettings(useConsoleLogs: false)),
    );
  });

  tearDown(() async {
    // await dbService.close(); // FFI might have issues closing on fast tests, let's try
  });

  test('Should sync image tags to record tags_cache', () async {
    final db = await dbService.database;

    // 1. Create a Person
    await db.insert('persons', {
      'id': 'p1',
      'nickname': 'Test',
      'created_at_ms': 0,
    });

    // 2. Create a Record
    await db.insert('records', {
      'id': 'r1',
      'person_id': 'p1',
      'created_at_ms': 0,
      'updated_at_ms': 0,
      'status': 'archived',
    });

    // 3. Create Tags
    await db.insert('tags', {'id': 't1', 'name': 'TagA', 'created_at_ms': 0});
    await db.insert('tags', {'id': 't2', 'name': 'TagB', 'created_at_ms': 0});

    // 4. Create Image with Tags
    final img = MedicalImage(
      id: 'i1',
      recordId: 'r1',
      encryptionKey: 'k',
      thumbnailEncryptionKey: 'tk',
      filePath: 'p',
      thumbnailPath: 't',
      createdAt: DateTime.now(),
      tagIds: ['t1', 't2'],
    );

    // 5. Save Image
    await imageRepo.saveImages([img]);

    // Check images table
    final imgRes = await db.query('images');
    expect(imgRes.first['tags'], contains('t1'));

    // Verify Relational Sync
    final relationRes = await db.query('image_tags');
    expect(relationRes.length, 2);

    // Verify Record Cache
    final recRes = await db.query('records');
    final tagsCache = jsonDecode(recRes.first['tags_cache'] as String);
    expect(tagsCache, contains('TagA'));
    expect(tagsCache, contains('TagB'));
  });

  test('Should retrieve all tags correctly', () async {
    final db = await dbService.database;
    await db.insert('tags', {
      'id': 't_test',
      'name': 'TestTag',
      'color': '#FFFFFF',
      'order_index': 0,
      'is_custom': 0,
      'created_at_ms': 1234567890,
    });

    final tags = await tagRepo.getAllTags();
    expect(tags.length, greaterThanOrEqualTo(1));
    final t = tags.firstWhere((element) => element.id == 't_test');
    expect(t.name, 'TestTag');
    expect(t.createdAt.millisecondsSinceEpoch, 1234567890);
    expect(t.isSystem, true);
  });
}
