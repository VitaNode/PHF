/// # OCR Status Provider
///
/// ## Description
/// 监听并广播 OCR 队列的待处理任务数量。
/// 采用定时轮询策略（离线环境下最稳健的跨 Isolate 状态同步方式）。
///
/// ## Mechanics
/// - 采用 WAL 模式配合高频轮询。
/// - 任务数 > 0 时：每 2 秒轮询。
/// - 任务数 = 0 时：每 5 秒轮询（提高活跃度）。
library;

import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'core_providers.dart';
import 'logging_provider.dart';
import 'person_provider.dart';

part 'ocr_status_provider.g.dart';

@riverpod
Stream<int> ocrPendingCount(Ref ref) async* {
  final repo = ref.watch(ocrQueueRepositoryProvider);
  final talker = ref.watch(talkerProvider);
  // 监听当前人员，切换人员时自动重置轮询
  final personId = await ref.watch(currentPersonIdControllerProvider.future);

  // 保持订阅状态
  // ignore: unused_local_variable
  final keepAlive = ref.keepAlive();

  int lastCount = -1;

  while (true) {
    try {
      final count = await repo.getPendingCount(personId: personId);

      // 只有当数字变化时才 yield，减少 UI 无谓重绘
      if (count != lastCount) {
        talker.debug('[OCRStatusProvider] Count changed: $lastCount -> $count');
        yield count;
        lastCount = count;
      }
    } catch (e) {
      talker.warning('[OCRStatusProvider] Polling database busy...');
    }

    // 动态调整探测频率
    if (lastCount > 0) {
      await Future<void>.delayed(const Duration(seconds: 2));
    } else {
      await Future<void>.delayed(const Duration(seconds: 5));
    }
  }
}
