import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:phf/core/security/master_key_manager.dart';

@GenerateNiceMocks([MockSpec<FlutterSecureStorage>()])
import 'master_key_manager_test.mocks.dart';

void main() {
  late MockFlutterSecureStorage mockStorage;
  late MasterKeyManager manager;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    manager = MasterKeyManager(storage: mockStorage);
  });

  group('MasterKeyManager', () {
    test('getMasterKey returns existing key if present', () async {
      // Arrange
      // 32 bytes of 0x01
      final existingKey = Uint8List.fromList(List.filled(32, 1));
      final base64Key = base64Encode(existingKey);
      
      when(mockStorage.read(key: 'phf_master_key_v1'))
          .thenAnswer((_) async => base64Key);

      // Act
      final result = await manager.getMasterKey();

      // Assert
      expect(result, existingKey);
      verify(mockStorage.read(key: 'phf_master_key_v1')).called(1);
      verifyNever(mockStorage.write(key: anyNamed('key'), value: anyNamed('value')));
    });

    test('getMasterKey generates new key if missing', () async {
      // Arrange
      when(mockStorage.read(key: 'phf_master_key_v1'))
          .thenAnswer((_) async => null);

      // Act
      final result = await manager.getMasterKey();

      // Assert
      expect(result.length, 32);
      verify(mockStorage.read(key: 'phf_master_key_v1')).called(1);
      
      // Capture the write
      final verification = verify(mockStorage.write(
        key: 'phf_master_key_v1', 
        value: captureAnyNamed('value')
      ));
      verification.called(1);
      
      // Verify stored value matches returned value
      final storedBase64 = verification.captured.single as String;
      expect(base64Decode(storedBase64), result);
    });

    test('getUserSalt returns existing salt if present', () async {
      // Arrange: 16 bytes of 0x02
      final existingSalt = Uint8List.fromList(List.filled(16, 2));
      final base64Salt = base64Encode(existingSalt);
      
      when(mockStorage.read(key: 'phf_user_salt_v1'))
          .thenAnswer((_) async => base64Salt);

      // Act
      final result = await manager.getUserSalt();

      // Assert
      expect(result, existingSalt);
    });

    test('getUserSalt generates new salt if missing', () async {
      // Arrange
      when(mockStorage.read(key: 'phf_user_salt_v1'))
          .thenAnswer((_) async => null);

      // Act
      final result = await manager.getUserSalt();

      // Assert
      expect(result.length, 16);
      
      verify(mockStorage.write(
        key: 'phf_user_salt_v1', 
        value: anyNamed('value')
      )).called(1);
    });

    test('wipeAll deletes both keys', () async {
      // Act
      await manager.wipeAll();

      // Assert
      verify(mockStorage.delete(key: 'phf_master_key_v1')).called(1);
      verify(mockStorage.delete(key: 'phf_user_salt_v1')).called(1);
    });
  });
}
