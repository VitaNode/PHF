import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:phf/data/datasources/local/database_service.dart';
import 'package:phf/data/repositories/app_meta_repository.dart';

@GenerateNiceMocks([MockSpec<SQLCipherDatabaseService>()])
import 'app_meta_repository_test.mocks.dart';

void main() {
  // Initialize FFI
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late AppMetaRepository repo;
  late MockSQLCipherDatabaseService mockDbService;
  late Database db;

  setUp(() async {
    mockDbService = MockSQLCipherDatabaseService();
    db = await databaseFactory.openDatabase(inMemoryDatabasePath);

    // Create app_meta table
    await db.execute(
      'CREATE TABLE app_meta (key TEXT PRIMARY KEY, value TEXT)',
    );

    when(mockDbService.database).thenAnswer((_) async => db);
    repo = AppMetaRepository(mockDbService);
  });

  tearDown(() async {
    await db.close();
  });

  group('AppMetaRepository', () {
    test('get and put', () async {
      await repo.put('test_key', 'test_value');
      final val = await repo.get('test_key');
      expect(val, 'test_value');
    });

    test('hasLock', () async {
      expect(await repo.hasLock(), isFalse);

      await repo.setHasLock(true);
      expect(await repo.hasLock(), isTrue);

      await repo.setHasLock(false);
      expect(await repo.hasLock(), isFalse);
    });

    test('isDisclaimerAccepted', () async {
      expect(await repo.isDisclaimerAccepted(), isFalse);

      await repo.setDisclaimerAccepted(true);
      expect(await repo.isDisclaimerAccepted(), isTrue);

      await repo.setDisclaimerAccepted(false);
      expect(await repo.isDisclaimerAccepted(), isFalse);
    });

    test('Person ID management', () async {
      expect(await repo.getCurrentPersonId(), isNull);

      await repo.setCurrentPersonId('p123');
      expect(await repo.getCurrentPersonId(), 'p123');
    });
  });
}
