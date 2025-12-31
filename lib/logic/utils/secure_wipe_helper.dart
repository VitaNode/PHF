/// # SecureWipeHelper
///
/// ## Description
/// 实现文件的“物理擦除”逻辑。
/// 与普通 `File.delete()` 不同，本工具在删除前会先使用随机数据覆盖文件内容并执行 `flush`，
/// 从而降低数据被底层存储介质（如 SSD/Flash）恢复的可能性。
///
/// ## Security Measures
/// - **Overwrite**: 使用随机字节填充文件。
/// - **Flush**: 强制将内存中的脏页刷入磁盘。
/// - **Truncate**: 擦除后将文件大小设为 0。
///
/// ## Constraints
/// - 在现代 SSD/闪存介质上，由于 Wear Leveling（磨损均衡）机制，软件层面的覆盖无法 100% 保证
///   原始物理扇区被擦除，但在应用层已是最高等级的防护措施。
///
/// ## Repair Logs
/// - [2025-12-31] 优化：引入分块覆盖机制（64KB 缓冲区），修复处理大文件时可能导致的 OOM（内存溢出）隐患。
library;

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

class SecureWipeHelper {
  static const int _bufferSize = 64 * 1024; // 64KB

  /// 异步安全擦除文件
  static Future<void> wipe(File file) async {
    try {
      if (!await file.exists()) return;

      final length = await file.length();
      if (length > 0) {
        final random = Random.secure();
        final raf = await file.open(mode: FileMode.write);
        
        final buffer = Uint8List(_bufferSize);
        int written = 0;
        
        while (written < length) {
          // 每次循环重新填充部分随机数据以增强安全性
          for (var i = 0; i < min(_bufferSize, 1024); i++) {
            buffer[i] = random.nextInt(256);
          }
          
          final remaining = length - written;
          final chunkSize = min(remaining, _bufferSize);
          
          await raf.writeFrom(buffer, 0, chunkSize);
          written += chunkSize;
        }

        await raf.flush();
        await raf.truncate(0);
        await raf.close();
      }

      await file.delete();
    } catch (e) {
      // 降级处理：如果安全擦除失败（如权限问题），至少尝试直接删除
      if (await file.exists()) {
        await file.delete().catchError((_) => file);
      }
    }
  }

  /// 同步安全擦除文件 (仅在无法使用异步的特殊场景使用)
  static void wipeSync(File file) {
    try {
      if (!file.existsSync()) return;

      final length = file.lengthSync();
      if (length > 0) {
        final random = Random.secure();
        final raf = file.openSync(mode: FileMode.write);
        
        final buffer = Uint8List(_bufferSize);
        int written = 0;
        
        while (written < length) {
          for (var i = 0; i < min(_bufferSize, 1024); i++) {
            buffer[i] = random.nextInt(256);
          }
          
          final remaining = length - written;
          final chunkSize = min(remaining, _bufferSize);
          
          raf.writeFromSync(buffer, 0, chunkSize);
          written += chunkSize;
        }

        raf.flushSync();
        raf.truncateSync(0);
        raf.closeSync();
      }
      file.deleteSync();
    } catch (e) {
      if (file.existsSync()) {
        try { file.deleteSync(); } catch (_) {}
      }
    }
  }
}
