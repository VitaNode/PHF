/// # ICryptoService Documentation
///
/// ## Description
/// 核心加解密服务接口，定义了符合 `Constitution#VI. Security` 的加解密行为。
///
/// ## Core Methods
/// - `generateMasterKey()`: 生成符合安全强度的 Master Key。
/// - `encrypt(data, key, {aad})`: 使用 AES-256-GCM 加密数据。
/// - `decrypt(cipherData, key, {aad})`: 使用 AES-256-GCM 解密数据。
///
/// ## Security Measures
/// - 强制使用 `Uint8List` 处理字节，减少内存残留风险。
/// - 接口不涉及具体的密钥存储逻辑，仅负责算法执行。
library;

import 'dart:typed_data';

/// 核心加解密服务契约
abstract class ICryptoService {
  /// 生成一个随机的 256-bit (32 bytes) 密钥
  Uint8List generateRandomKey();

  /// 使用提供的密钥加密数据
  /// 
  /// [key] 必须为 32 字节。
  /// [associatedData] (AAD) 用于防止密文被篡改。
  /// 
  /// 返回加密后的数据包（IV + Ciphertext + Tag）。
  Future<Uint8List> encrypt({
    required Uint8List data,
    required Uint8List key,
    Uint8List? associatedData,
  });

  /// 使用提供的密钥解密数据包
  /// 
  /// [encryptedData] 必须包含 IV 和 Auth Tag。
  /// [key] 必须为 32 字节。
  /// 
  /// 如果校验失败（摘要不匹配），应抛出 `SecurityException`。
  Future<Uint8List> decrypt({
    required Uint8List encryptedData,
    required Uint8List key,
    Uint8List? associatedData,
  });

  /// [Streaming] 对物理文件执行流式加密
  /// 
  /// 符合 `Constitution#I. Privacy`：避免大文件加载导致 OOM。
  /// 
  /// [sourcePath]: 原始明文文件路径。
  /// [destPath]: 加密后结果存储路径。
  /// [key]: 32 字节密钥。
  Future<void> encryptFile({
    required String sourcePath,
    required String destPath,
    required Uint8List key,
  });

  /// [Streaming] 对物理文件执行流式解密
  /// 
  /// [sourcePath]: 加密后的密文文件路径（含 IV 头部）。
  /// [destPath]: 解密后明文临时存储路径（处理完需立即 Wipe）。
  Future<void> decryptFile({
    required String sourcePath,
    required String destPath,
    required Uint8List key,
  });
}

/// 安全相关异常
class SecurityException implements Exception {
  final String message;
  SecurityException(this.message);
  @override
  String toString() => 'SecurityException: $message';
}
