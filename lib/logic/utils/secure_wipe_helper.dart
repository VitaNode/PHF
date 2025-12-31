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
library;

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

class SecureWipeHelper {
  /// 异步安全擦除文件
  static Future<void> wipe(File file) async {
    try {
      if (!await file.exists()) return;

      final length = await file.length();
      if (length > 0) {
        // 1. 生成随机数据进行覆盖 (单次覆盖)
        final random = Random.secure();
        final buffer = Uint8List(length);
        for (var i = 0; i < length; i++) {
          buffer[i] = random.nextInt(256);
        }

        // 2. 写入随机数据并强制刷入磁盘
        final raf = await file.open(mode: FileMode.write);
        await raf.writeFrom(buffer);
        await raf.flush();
        
        // 3. 截断文件
        await raf.truncate(0);
        await raf.close();
      }

      // 4. 物理删除
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
        final buffer = Uint8List(length);
        for (var i = 0; i < length; i++) {
          buffer[i] = random.nextInt(256);
        }

        final raf = file.openSync(mode: FileMode.write);
        raf.writeFromSync(buffer);
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
