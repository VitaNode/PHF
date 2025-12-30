import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:phf/logic/services/crypto_service.dart';
import 'package:phf/logic/services/interfaces/crypto_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late CryptoService service;

  setUp(() {
    service = CryptoService();
  });

  group('CryptoService In-Memory', () {
    test('generateRandomKey returns 32 bytes', () {
      final key = service.generateRandomKey();
      expect(key.length, 32);
    });

    test('generateRandomKey creates unique keys', () {
      final key1 = service.generateRandomKey();
      final key2 = service.generateRandomKey();
      expect(key1, isNot(equals(key2)));
    });

    test('encrypt/decrypt roundtrip', () async {
      final key = service.generateRandomKey();
      final plaintext = Uint8List.fromList([1, 2, 3, 4, 5]);

      final ciphertext = await service.encrypt(
        data: plaintext,
        key: key,
      );

      // Packet: Nonce(12) + Cipher(5) + Tag(16) = 33 bytes
      expect(ciphertext.length, 12 + 5 + 16);

      final decrypted = await service.decrypt(
        encryptedData: ciphertext,
        key: key,
      );

      expect(decrypted, plaintext);
    });

    test('decrypt throws SecurityException on bad key', () async {
      final key = service.generateRandomKey();
      final badKey = service.generateRandomKey();
      final plaintext = Uint8List.fromList([1, 2, 3]);

      final ciphertext = await service.encrypt(
        data: plaintext,
        key: key,
      );

      expect(
        () => service.decrypt(encryptedData: ciphertext, key: badKey),
        throwsA(isA<SecurityException>()),
      );
    });
  });

  group('CryptoService File Streaming', () {
    late Directory tempDir;
    late File sourceFile;
    late File encFile;
    late File decFile;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('phf_crypto_test');
      sourceFile = File('${tempDir.path}/source.dat');
      encFile = File('${tempDir.path}/enc.dat');
      decFile = File('${tempDir.path}/dec.dat');
    });

    tearDown(() async {
      await tempDir.delete(recursive: true);
    });

    test('encryptFile/decryptFile roundtrip (small file)', () async {
      final key = service.generateRandomKey();
      final plaintext = Uint8List.fromList(List.generate(100, (i) => i));
      await sourceFile.writeAsBytes(plaintext);

      await service.encryptFile(
        sourcePath: sourceFile.path,
        destPath: encFile.path,
        key: key,
      );

      expect(await encFile.exists(), true);
      final encSize = await encFile.length();
      // Packet: Header(4) + Nonce(12) + Cipher(100) + Tag(16) = 132
      expect(encSize, 4 + 12 + 100 + 16);

      await service.decryptFile(
        sourcePath: encFile.path,
        destPath: decFile.path,
        key: key,
      );

      expect(await decFile.exists(), true);
      final decrypted = await decFile.readAsBytes();
      expect(decrypted, plaintext);
    });

    test('encryptFile/decryptFile roundtrip (multi-chunk)', () async {
      // Chunk Size default is 2MB.
      // Let's create a 3MB file to force 2 chunks (2MB + 1MB).
      final key = service.generateRandomKey();
      const size = 3 * 1024 * 1024;
      final plaintext = Uint8List(size); // Zero initialized
      // Fill some recognizable data
      plaintext[0] = 0xAA;
      plaintext[size - 1] = 0xBB;
      
      await sourceFile.writeAsBytes(plaintext);

      await service.encryptFile(
        sourcePath: sourceFile.path,
        destPath: encFile.path,
        key: key,
      );

      // Verify file size: 
      // Chunk 1 (2MB): 4 + 12 + 2MB + 16
      // Chunk 2 (1MB): 4 + 12 + 1MB + 16
      // Total Overhead: (4+12+16)*2 = 64 bytes.
      final encSize = await encFile.length();
      expect(encSize, size + 64);

      await service.decryptFile(
        sourcePath: encFile.path,
        destPath: decFile.path,
        key: key,
      );

      final decrypted = await decFile.readAsBytes();
      expect(decrypted.length, size);
      expect(decrypted[0], 0xAA);
      expect(decrypted[size - 1], 0xBB);
    });
  });
}
