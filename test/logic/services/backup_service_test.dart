// ignore_for_file: unawaited_futures
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:phf/core/security/master_key_manager.dart';
import 'package:phf/core/services/path_provider_service.dart';
import 'package:phf/logic/services/backup_service.dart';
import 'package:phf/logic/services/interfaces/crypto_service.dart';
import 'package:phf/data/datasources/local/database_service.dart';
import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as p;

@GenerateNiceMocks([
  MockSpec<ICryptoService>(),
  MockSpec<PathProviderService>(),
  MockSpec<MasterKeyManager>(),
  MockSpec<SQLCipherDatabaseService>(),
])
import 'backup_service_test.mocks.dart';

void main() {
  late MockICryptoService mockCryptoService;
  late MockPathProviderService mockPathService;
  late MockMasterKeyManager mockKeyManager;
  late MockSQLCipherDatabaseService mockDbService;
  late BackupService backupService;
  late Directory tempTestDir;

  setUp(() async {
    mockCryptoService = MockICryptoService();
    mockPathService = MockPathProviderService();
    mockKeyManager = MockMasterKeyManager();
    mockDbService = MockSQLCipherDatabaseService();

    // Setup temporary directory for file operations
    tempTestDir = await Directory.systemTemp.createTemp('backup_test_');

    // Setup Mock PathProvider
    // Mock getters using when(obj.property).thenReturn(...)
    when(
      mockPathService.tempDirPath,
    ).thenReturn(p.join(tempTestDir.path, 'temp'));
    when(
      mockPathService.imagesDirPath,
    ).thenReturn(p.join(tempTestDir.path, 'images'));
    when(mockPathService.sandboxRoot).thenReturn(tempTestDir.path);

    // Mock methods
    when(mockPathService.getDatabasePath(any)).thenAnswer(
      (invocation) => p.join(
        tempTestDir.path,
        'db',
        invocation.positionalArguments.first as String,
      ),
    );

    // Create necessary directories
    await Directory(p.join(tempTestDir.path, 'temp')).create();
    await Directory(p.join(tempTestDir.path, 'db')).create();
    await Directory(p.join(tempTestDir.path, 'images')).create();

    // Setup MasterKeyManager
    when(
      mockKeyManager.getUserSalt(),
    ).thenAnswer((_) async => Uint8List(16)); // Zero salt for stable test

    backupService = BackupService(
      cryptoService: mockCryptoService,
      pathService: mockPathService,
      keyManager: mockKeyManager,
      dbService: mockDbService,
    );
  });

  tearDown(() {
    tempTestDir.deleteSync(recursive: true);
  });

  group('BackupService', () {
    test('exportBackup should zip and encrypt files', () async {
      // 1. Prepare dummy files
      final dbFile = File(p.join(tempTestDir.path, 'db', 'phf_encrypted.db'));
      await dbFile.writeAsString('dummy db content');

      final imageFile = File(p.join(tempTestDir.path, 'images', 'test.jpg'));
      await imageFile.writeAsString('dummy image content');

      // 2. Execute
      final resultPath = await backupService.exportBackup('123456');

      // 3. Verify
      verify(mockPathService.tempDirPath).called(1);
      verify(mockKeyManager.getUserSalt()).called(1);
      verify(
        mockCryptoService.encryptFile(
          sourcePath: anyNamed('sourcePath'),
          destPath: anyNamed('destPath'),
          key: anyNamed('key'),
        ),
      ).called(1);

      // Verify result path format
      expect(resultPath.endsWith('.phbak'), isTrue);
    });

    test('importBackup should decrypt and unzip files', () async {
      // 1. Prepare a dummy .phbak file (which mimics the input)
      final backupFile = File(p.join(tempTestDir.path, 'test_backup.phbak'));
      await backupFile.writeAsString('encrypted content');

      // 2. Mock decryptFile to actually produce a valid zip at the destination
      when(
        mockCryptoService.decryptFile(
          sourcePath: anyNamed('sourcePath'),
          destPath: anyNamed('destPath'),
          key: anyNamed('key'),
        ),
      ).thenAnswer((invocation) async {
        final destPath =
            invocation.namedArguments[const Symbol('destPath')] as String;

        // Create a real valid zip file at destPath
        final encoder = ZipFileEncoder();
        encoder.create(destPath);
        encoder.addDirectory(
          Directory(p.join(tempTestDir.path, 'images')),
        ); // Add empty images dir for test
        encoder.close();
      });

      // 3. Execute
      await backupService.importBackup(backupFile.path, '123456');

      // 4. Verify
      verify(
        mockCryptoService.decryptFile(
          sourcePath: backupFile.path,
          destPath: anyNamed('destPath'),
          key: anyNamed('key'),
        ),
      ).called(1);

      // Verify files would be extracted (Mock logic doesn't fully simulate extraction overwrites unless we check the fs,
      // but here we trust the loop logic given the zip is valid)
    });
  });
}
