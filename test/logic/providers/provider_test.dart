import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phf/logic/providers/core_providers.dart';
import 'package:phf/logic/providers/ingestion_provider.dart';
import 'package:phf/logic/providers/states/ingestion_state.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:mockito/annotations.dart';
import 'package:phf/data/datasources/local/database_service.dart';

// No mocks needed for basic DI check as we use real instances (except DatabaseService dependency)
// Real services have no side effects during construction usually.
// However, MasterKeyManager.getMasterKey reads secure storage which requires platform channel.
// So we need overrides.

@GenerateNiceMocks([MockSpec<SQLCipherDatabaseService>()])
import 'provider_test.mocks.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  test('DI Graph Validity - Core Providers', () {
    final container = ProviderContainer(
      overrides: [
        // We override databaseService to avoid real DB init and KeyManager dependency for this simple test
        databaseServiceProvider.overrideWith((ref) => MockSQLCipherDatabaseService()),
      ],
    );

    expect(container.read(pathProviderServiceProvider), isNotNull);
    expect(container.read(permissionServiceProvider), isNotNull);
    expect(container.read(masterKeyManagerProvider), isNotNull);
    // Repos
    expect(container.read(recordRepositoryProvider), isNotNull);
    expect(container.read(imageRepositoryProvider), isNotNull);
    
    // Services
    expect(container.read(cryptoServiceProvider), isNotNull);
    expect(container.read(fileSecurityHelperProvider), isNotNull);
  });

  test('IngestionController Initial State', () {
    final container = ProviderContainer();
    final state = container.read(ingestionControllerProvider);
    expect(state.rawImages, isEmpty);
    expect(state.status, IngestionStatus.idle);
  });
}
