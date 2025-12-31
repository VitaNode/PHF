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
library;

import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'core_providers.dart';
import 'logging_provider.dart';

part 'ocr_status_provider.g.dart';

@riverpod
Stream<int> ocrPendingCount(Ref ref) async* {
  final repo = ref.watch(ocrQueueRepositoryProvider);
  final talker = ref.watch(talkerProvider);
  
  // 保持 Provider 活跃，直到没有订阅者
  final link = ref.keepAlive();
  Timer? timer;

  // 使用 StreamController 来管理手动控制的轮询
  final controller = StreamController<int>();

  Future<void> poll() async {
    try {
      final count = await repo.getPendingCount();
      if (!controller.isClosed) {
        controller.add(count);
      }
    } catch (e, st) {
      talker.error('[OCRStatusProvider] Polling failed', e, st);
      if (!controller.isClosed) controller.add(0);
    }
  }

  // 初始执行一次
  await poll();

  // 动态调整频率的定时器
  void scheduleNext(int currentCount) {
    timer?.cancel();
    final delay = currentCount > 0 ? const Duration(seconds: 2) : const Duration(seconds: 10);
    timer = Timer(delay, () async {
      await poll();
    });
  }

  // 监听 controller 自身的数据以决定下次轮询时间
  final subscription = controller.stream.listen((count) {
    scheduleNext(count);
  });

  ref.onDispose(() {
    timer?.cancel();
    subscription.cancel();
    controller.close();
    link.close();
  });

  yield* controller.stream;
}