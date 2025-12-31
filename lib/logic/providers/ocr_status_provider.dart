/// # OCR Status Provider
///
/// ## Description
/// 监听并广播 OCR 队列的待处理任务数量。
/// 采用定时轮询策略（离线环境下最稳健的跨 Isolate 状态同步方式）。
///
/// ## Mechanics
/// - 任务数 > 0 时：每 3 秒轮询一次。
/// - 任务数 = 0 时：每 10 秒轮询一次（降低功耗）。
///
/// ## Security
/// - 仅读取任务计数，不涉及敏感明文。
///
/// ## Repair Logs
/// - [2025-12-31] 优化：移除不必要的 keepAlive 以节省后台功耗；修复数据库错误时回退为 0 可能导致的 UI 误判；修正 Future.delayed 类型推导。
library;

import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'core_providers.dart';

part 'ocr_status_provider.g.dart';

@riverpod
Stream<int> ocrPendingCount(Ref ref) async* {
  final repo = ref.watch(ocrQueueRepositoryProvider);
  
  int lastCount = 0;

  while (true) {
    int currentCount = lastCount;
    try {
      currentCount = await repo.getPendingCount();
      lastCount = currentCount;
    } catch (e) {
      // 数据库忙或锁定，维持上一次的计数，避免 UI 误判为“处理完成”
    }
    
    yield currentCount;

    // 根据是否有任务调整轮询频率
    if (currentCount > 0) {
      await Future<void>.delayed(const Duration(seconds: 3));
    } else {
      await Future<void>.delayed(const Duration(seconds: 10));
    }
  }
}
