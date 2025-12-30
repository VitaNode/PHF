/// # CryptoService Implementation
///
/// ## Description
/// 基于 `cryptography` 包实现的 AES-256-GCM 加解密服务。
/// 支持内存操作和文件流式操作。
///
/// ## File Format (Streaming)
/// chunked_stream := chunk*
/// chunk := length(4 bytes BE) || nonce(12 bytes) || ciphertext(N bytes) || tag(16 bytes)
///
/// ## Security
/// - Algorithm: AES-GCM (256-bit key)
/// - Nonce: 12 bytes (unique per chunk/message)
/// - Tag: 16 bytes (authentication)
library;

import 'dart:io';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'interfaces/crypto_service.dart';

class CryptoService implements ICryptoService {
  // Use AesGcm with 256-bit keys and 128-bit (16 bytes) tags.
  final AesGcm _algorithm = AesGcm.with256bits(nonceLength: 12);
  
  // Chunk size for file streaming (e.g., 2MB plaintext per chunk)
  static const int _chunkSize = 2 * 1024 * 1024;

  @override
  Uint8List generateRandomKey() {
    // Generate 32 bytes (256 bits) securely
    final secretKey = SecretKeyData.random(length: 32);
    return Uint8List.fromList(secretKey.bytes);
  }

  @override
  Future<Uint8List> encrypt({
    required Uint8List data,
    required Uint8List key,
    Uint8List? associatedData,
  }) async {
    final secretKey = SecretKey(key);
    
    // Encrypt
    final secretBox = await _algorithm.encrypt(
      data,
      secretKey: secretKey,
      aad: associatedData ?? Uint8List(0),
    );

    // Format: Nonce (12) + Ciphertext + Tag (16)
    // Note: cryptography package's SecretBox.concatenation() does:
    // Nonce + Ciphertext + Tag (default behavior for AES-GCM)
    return Uint8List.fromList(secretBox.concatenation());
  }

  @override
  Future<Uint8List> decrypt({
    required Uint8List encryptedData,
    required Uint8List key,
    Uint8List? associatedData,
  }) async {
    final secretKey = SecretKey(key);

    try {
      // Parse SecretBox from concatenated bytes (Nonce + Cipher + Tag)
      final secretBox = SecretBox.fromConcatenation(
        encryptedData,
        nonceLength: 12,
        macLength: 16,
      );

      final plaintext = await _algorithm.decrypt(
        secretBox,
        secretKey: secretKey,
        aad: associatedData ?? Uint8List(0),
      );

      return Uint8List.fromList(plaintext);
    } catch (e) {
      if (e is SecretBoxAuthenticationError) {
        throw SecurityException('Decryption failed: Authentication tag mismatch.');
      }
      throw SecurityException('Decryption error: $e');
    }
  }

  @override
  Future<void> encryptFile({
    required String sourcePath,
    required String destPath,
    required Uint8List key,
  }) async {
    final inputFile = File(sourcePath);
    final outputFile = File(destPath);
    final secretKey = SecretKey(key);

    // Ensure output doesn't exist or overwrite
    if (await outputFile.exists()) {
      await outputFile.delete();
    }
    
    final outputSink = outputFile.openWrite();
    final inputAccess = await inputFile.open();
    final fileLen = await inputFile.length();
    
    int offset = 0;
    try {
      while (offset < fileLen) {
        // Read chunk
        final chunkLen = (offset + _chunkSize > fileLen) 
            ? fileLen - offset 
            : _chunkSize;
            
        final buffer = Uint8List(chunkLen);
        await _readExact(inputAccess, buffer);
        
        // Encrypt chunk
        final secretBox = await _algorithm.encrypt(
          buffer,
          secretKey: secretKey,
        );
        
        // Serialize: [Len 4B][Nonce 12B][Cipher][Tag 16B]
        final concatenated = secretBox.concatenation();
        final packetLen = concatenated.length;
        
        // Write Length Header (4 bytes Big Endian)
        final header = ByteData(4);
        header.setUint32(0, packetLen, Endian.big);
        outputSink.add(header.buffer.asUint8List());
        
        // Write Payload
        outputSink.add(concatenated);
        
        offset += chunkLen;
      }
    } catch (e) {
       throw SecurityException('File encryption failed: $e');
    } finally {
      await inputAccess.close();
      await outputSink.close();
    }
  }

  @override
  Future<void> decryptFile({
    required String sourcePath,
    required String destPath,
    required Uint8List key,
  }) async {
    final inputFile = File(sourcePath);
    final outputFile = File(destPath);
    final secretKey = SecretKey(key);

    if (await outputFile.exists()) {
      await outputFile.delete();
    }

    final outputSink = outputFile.openWrite();
    final inputAccess = await inputFile.open();
    final fileLen = await inputFile.length();
    
    int offset = 0;
    
    try {
      while (offset < fileLen) {
        // 1. Read Packet Length (4 bytes)
        if (offset + 4 > fileLen) {
           throw SecurityException('Corrupted file: Incomplete header at end of file.');
        }
        
        final headerBytes = Uint8List(4);
        await _readExact(inputAccess, headerBytes);
        offset += 4;
        
        final packetLen = ByteData.sublistView(headerBytes).getUint32(0, Endian.big);
        
        // 2. Read Packet (Nonce + Cipher + Tag)
        if (offset + packetLen > fileLen) {
           throw SecurityException('Corrupted file: Incomplete packet.');
        }
        
        final packetBytes = Uint8List(packetLen);
        await _readExact(inputAccess, packetBytes);
        offset += packetLen;
        
        // 3. Decrypt
        final secretBox = SecretBox.fromConcatenation(
          packetBytes,
          nonceLength: 12,
          macLength: 16,
        );
        
        final plaintext = await _algorithm.decrypt(
          secretBox,
          secretKey: secretKey,
        );
        
        outputSink.add(plaintext);
      }
    } catch (e) {
      if (e is SecretBoxAuthenticationError) {
        throw SecurityException('File decryption failed: Auth tag mismatch.');
      }
      throw SecurityException('File decryption error: $e');
    } finally {
      await inputAccess.close();
      await outputSink.close();
    }
  }

  /// Helper to ensure buffer is fully filled on read
  Future<void> _readExact(RandomAccessFile file, Uint8List buffer) async {
    int offset = 0;
    while (offset < buffer.length) {
      // readInto reads *up to* remaining bytes
      final readCount = await file.readInto(buffer, offset, buffer.length);
     if (readCount == 0) {
        throw SecurityException('Unexpected end of file.');
      }
      offset += readCount;
    }
  }
}
