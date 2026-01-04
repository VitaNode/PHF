import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:phf/data/repositories/person_repository.dart';
import 'package:phf/data/repositories/tag_repository.dart';
import 'package:phf/data/repositories/search_repository.dart';
import 'package:phf/data/datasources/local/database_service.dart';
import 'package:phf/data/models/person.dart';
import 'package:phf/data/models/tag.dart';
import 'package:phf/core/security/master_key_manager.dart';
import 'package:phf/core/services/path_provider_service.dart';

// Mock Classes
class MockMasterKeyManager extends Mock implements MasterKeyManager {
  @override
  Future<List<int>> getMasterKey() async => List.filled(32, 0);
}

class MockPathProviderService extends Mock implements PathProviderService {
  @override
  String getDatabasePath(String dbName) => inMemoryDatabasePath;
}

void main() {
  // Initialize FFI for testing
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late SQLCipherDatabaseService dbService;
  late PersonRepository personRepo;
  late TagRepository tagRepo;
  late SearchRepository searchRepo;

  setUp(() async {
    final mockKeyManager = MockMasterKeyManager();
    final mockPathService = MockPathProviderService();

    // Inject databaseFactoryFfi into service to allow FFI testing
    dbService = SQLCipherDatabaseService(
      keyManager: mockKeyManager,
      pathService: mockPathService,
      dbFactory: databaseFactoryFfi,
    );

    personRepo = PersonRepository(dbService);
    tagRepo = TagRepository(dbService);
    searchRepo = SearchRepository(dbService);
  });

  tearDown(() async {
    await dbService.close();
  });

  group('PersonRepository Tests', () {
    test('createPerson and getAllPersons', () async {
      final person = Person(
        id: 'p1',
        nickname: 'Test User',
        createdAt: DateTime.now(),
        orderIndex: 0,
      );

      await personRepo.createPerson(person);
      final persons = await personRepo.getAllPersons();

      expect(persons.length, 1);
      expect(persons.first.nickname, 'Test User');
    });

    test('updateOrder', () async {
      final p1 = Person(
        id: 'p1',
        nickname: 'P1',
        createdAt: DateTime.now(),
        orderIndex: 0,
      );
      final p2 = Person(
        id: 'p2',
        nickname: 'P2',
        createdAt: DateTime.now(),
        orderIndex: 1,
      );

      await personRepo.createPerson(p1);
      await personRepo.createPerson(p2);

      // Swap order
      await personRepo.updateOrder([p2, p1]);

      final persons = await personRepo.getAllPersons();
      expect(persons[0].id, 'p2');
      expect(persons[0].orderIndex, 0);
      expect(persons[1].id, 'p1');
      expect(persons[1].orderIndex, 1);
    });

    test('deletePerson constraints', () async {
      final p1 = Person(id: 'p1', nickname: 'P1', createdAt: DateTime.now());
      await personRepo.createPerson(p1);

      // Create a dummy record linked to p1
      final db = await dbService.database;
      await db.insert('records', {
        'id': 'r1',
        'person_id': 'p1',
        'created_at_ms': DateTime.now().millisecondsSinceEpoch,
        'updated_at_ms': DateTime.now().millisecondsSinceEpoch,
        'status': 'processing',
      });

      expect(() => personRepo.deletePerson('p1'), throwsException);

      // Delete record first
      await db.delete('records', where: 'id = ?', whereArgs: ['r1']);
      await personRepo.deletePerson('p1');

      final persons = await personRepo.getAllPersons();
      expect(persons.isEmpty, true);
    });
  });

  group('TagRepository Tests', () {
    test('createTag and filtering', () async {
      final t1 = Tag(id: 't1', name: 'Global', createdAt: DateTime.now());
      final t2 = Tag(
        id: 't2',
        name: 'Personal',
        personId: 'p1',
        createdAt: DateTime.now(),
      );

      await tagRepo.createTag(t1);
      await tagRepo.createTag(t2);

      final allTags = await tagRepo.getAllTags(personId: 'p1');
      expect(allTags.length, 2);

      final globalTags = await tagRepo.getAllTags(personId: 'other');
      expect(globalTags.length, 1);
      expect(globalTags.first.name, 'Global');
    });

    test('deleteTag cascade to images', () async {
      final t1 = Tag(id: 't1', name: 'Test', createdAt: DateTime.now());
      await tagRepo.createTag(t1);

      // Create image with tag
      final db = await dbService.database;

      // Need a record first
      await db.insert('persons', {
        'id': 'p1',
        'nickname': 'N',
        'created_at_ms': 0,
      });
      await db.insert('records', {
        'id': 'r1',
        'person_id': 'p1',
        'created_at_ms': 0,
        'updated_at_ms': 0,
      });

      await db.insert('images', {
        'id': 'i1',
        'record_id': 'r1',
        'file_path': 'path',
        'thumbnail_path': 'path',
        'encryption_key': 'key',
        'thumbnail_encryption_key': 'key',
        'created_at_ms': 0,
        'tags': '["t1", "other"]',
      });

      await tagRepo.deleteTag('t1');

      final result = await db.query(
        'images',
        where: 'id = ?',
        whereArgs: ['i1'],
      );
      final tagsJson = result.first['tags'] as String;

      expect(tagsJson.contains('t1'), false);
      expect(tagsJson.contains('other'), true);
    });
  });
}
