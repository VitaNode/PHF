
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:phf/core/security/file_security_helper.dart';
import 'package:phf/logic/services/interfaces/crypto_service.dart';

import 'file_security_helper_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ICryptoService>()])
void main() {
  late MockICryptoService mockCryptoService;
  late FileSecurityHelper helper;
  late Directory tempDir;

  setUp(() async {
    mockCryptoService = MockICryptoService();
    helper = FileSecurityHelper(cryptoService: mockCryptoService);
    tempDir = await Directory.systemTemp.createTemp('phf_test_');
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('FileSecurityHelper', () {
    test('decryptDataFromFile should decrypt content correctly', () async {
      // Arrange
      final fakeContent = Uint8List.fromList([1, 2, 3, 4]);
      final fakeEncrypted = Uint8List.fromList([9, 9, 9]); // Dummy encrypted
      final fakeKeyBytes = Uint8List.fromList(List.filled(32, 1));
      final fakeKeyBase64 = base64Encode(fakeKeyBytes);
      const filename = 'test_enc.enc';
      final encFile = File('${tempDir.path}/$filename');

      // Write "encrypted" data to disk
      await encFile.writeAsBytes(fakeEncrypted);

      // Mock Crypto Service
      when(mockCryptoService.decrypt(
        encryptedData: anyNamed('encryptedData'),
        key: anyNamed('key'),
      )).thenAnswer((_) async => fakeContent);

      // Act
      final result = await helper.decryptDataFromFile(encFile.path, fakeKeyBase64);

      // Assert
      expect(result, fakeContent);
      verify(mockCryptoService.decrypt(
        encryptedData: fakeEncrypted, 
        key: argThat(equals(fakeKeyBytes), named: 'key')
      )).called(1);
    });

    test('decryptDataFromFile should throw FileNotFoundException if file missing', () async {
      final fakeKeyBase64 = base64Encode(Uint8List(32));
      final missingPath = '${tempDir.path}/missing.enc';

      expect(
        () => helper.decryptDataFromFile(missingPath, fakeKeyBase64),
        throwsA(isA<FileNotFoundException>()),
      );
    });
  });
}
