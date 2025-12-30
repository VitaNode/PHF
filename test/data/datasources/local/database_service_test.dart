import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:phf/core/security/master_key_manager.dart';
import 'package:phf/core/services/path_provider_service.dart';
import 'package:phf/data/datasources/local/database_service.dart';

@GenerateNiceMocks([
  MockSpec<MasterKeyManager>(),
  MockSpec<PathProviderService>(),
])
import 'database_service_test.mocks.dart';

void main() {
  late MockMasterKeyManager mockKeyManager;
  late MockPathProviderService mockPathService;
  late SQLCipherDatabaseService service;

  setUp(() {
    mockKeyManager = MockMasterKeyManager();
    mockPathService = MockPathProviderService();
    service = SQLCipherDatabaseService(
      keyManager: mockKeyManager,
      pathService: mockPathService,
    );
  });

  group('SQLCipherDatabaseService Initialization Logic', () {
    test('Should retrieve master key and path before opening database', () async {
      // Arrange
      final dummyKey = Uint8List.fromList(List.filled(32, 1));
      when(mockKeyManager.getMasterKey()).thenAnswer((_) async => dummyKey);
      when(mockPathService.getDatabasePath(any)).thenReturn('/mock/path/phf_encrypted.db');

      // Note: We cannot easily mock the static/global openDatabase from sqflite 
      // without Dependency Injection or FFI in this unit test scope.
      // This test primarily verifies the dependency interaction flow.
      
      // Since calling service.database will trigger openDatabase which fails on standard test environment
      // (MissingPluginException or FFI error), we expect it to fail but check verify calls.
      
      try {
        await service.database;
      } catch (e) {
        // Expected failure in unit test environment without sqlite native lib
      }

      // Assert
      verify(mockPathService.getDatabasePath('phf_encrypted.db')).called(1);
      verify(mockKeyManager.getMasterKey()).called(1);
    });
  });
}
