/// # EncryptedFileResult
///
/// ## Description
/// 加密操作的返回结果封装。
///
/// ## Fields
/// - `relativePath`: 加密文件相对于应用沙盒根目录的路径.
/// - `base64Key`: 本次加密使用的随机密钥 (Base64).
library;

class EncryptedFileResult {
  final String relativePath;
  final String base64Key;

  const EncryptedFileResult({
    required this.relativePath,
    required this.base64Key,
  });
}
