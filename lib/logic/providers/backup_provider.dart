/// # Backup Provider
///
/// ## Description
/// 处理备份导出与导入的高层状态。
/// 串联 [BackupService] 与 share_plus 插件。
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
// ignore: deprecated_member_use
import 'package:share_plus/share_plus.dart';
import '../services/backup_service.dart';
import 'core_providers.dart';
import 'logging_provider.dart';

part 'backup_provider.g.dart';

@riverpod
class BackupController extends _$BackupController {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  /// 导出备份并分享
  Future<void> exportAndShare(String pin) async {
    state = const AsyncValue.loading();
    final talker = ref.read(talkerProvider);

    state = await AsyncValue.guard(() async {
      final service = ref.read(backupServiceProvider);

      talker.info('[BackupController] Starting export...');
      final path = await service.exportBackup(pin);

      talker.info('[BackupController] Export finished. Triggering share.');
      // ignore: deprecated_member_use
      await Share.shareXFiles([XFile(path)], subject: 'PaperHealth 安全备份');
    });
  }

  /// 导入备份
  Future<void> importFromFile(String path, String pin) async {
    state = const AsyncValue.loading();
    final talker = ref.read(talkerProvider);

    state = await AsyncValue.guard(() async {
      final service = ref.read(backupServiceProvider);

      talker.info('[BackupController] Starting import from $path');
      await service.importBackup(path, pin);

      talker.info(
        '[BackupController] Import successful. Invalidating database.',
      );

      // 重置数据库连接，强制重新初始化
      ref.invalidate(databaseServiceProvider);
      // 同时可能需要重置其他依赖数据库的 Provider
      // 简单起见，可以提示用户重启应用或利用 Riverpod 的依赖关系自动传播
    });
  }
}
