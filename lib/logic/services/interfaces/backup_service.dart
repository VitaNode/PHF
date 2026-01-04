/// # IBackupService
///
/// ## Description
/// 安全备份与恢复服务的业务契约。
/// 负责处理应用的离线加密备份 (.phbak)。
library;

abstract interface class IBackupService {
  /// 执行安全导出
  ///
  /// 1. 使用 [pin] 和系统 Salt 派生加密密钥。
  /// 2. 将数据库与媒体文件夹打包并加密。
  /// 3. 返回生成的临时文件路径。
  Future<String> exportBackup(String pin);

  /// 执行安全导入
  ///
  /// 1. 使用 [pin] 尝试解密 [backupFilePath]。
  /// 2. 如果解密失败（PIN 错误），抛出异常。
  /// 3. 解压并恢复数据库与媒体文件。
  Future<void> importBackup(String backupFilePath, String pin);
}
