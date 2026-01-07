import 'dart:async';
import 'package:flutter/material.dart';
import 'package:phf/logic/providers/core_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
Future<bool> hasLock(Ref ref) async {
  final repo = ref.watch(appMetaRepositoryProvider);
  return repo.hasLock();
}

@Riverpod(keepAlive: true)
Future<bool> isDisclaimerAccepted(Ref ref) async {
  final repo = ref.watch(appMetaRepositoryProvider);
  return repo.isDisclaimerAccepted();
}

@Riverpod(keepAlive: true)
class AuthStateController extends _$AuthStateController
    with WidgetsBindingObserver {
  DateTime? _lastPausedTime;

  @override
  bool build() {
    // 注册生命周期观察者
    WidgetsBinding.instance.addObserver(this);

    // 监听销毁，移除观察者
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
    });

    // 初始状态：如果应用设置了锁，冷启动应该处于锁定状态
    return true; // 默认启动时锁定 (AppLoader 会检查是否需要显示 LockScreen)
  }

  void unlock() {
    _lastPausedTime = null;
    state = false;
  }

  void lock() {
    state = true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 当进入后台时记录时间
    if (state == AppLifecycleState.paused) {
      _lastPausedTime = DateTime.now();
      // 如果设置为立即锁定，则直接锁定
      unawaited(_handleImmediateLock());
    }

    // 当从后台切回时，检查是否需要锁定
    if (state == AppLifecycleState.resumed) {
      unawaited(_checkLockTimeout());
    }
  }

  Future<void> _handleImmediateLock() async {
    final repository = ref.read(appMetaRepositoryProvider);
    final timeoutSeconds = await repository.getLockTimeout();
    if (timeoutSeconds <= 0) {
      lock();
    }
  }

  Future<void> _checkLockTimeout() async {
    // 如果已经处于锁定状态，不需要再次检查
    if (state) return;

    final lastPaused = _lastPausedTime;
    if (lastPaused == null) return;

    final repository = ref.read(appMetaRepositoryProvider);
    final timeoutSeconds = await repository.getLockTimeout();

    final now = DateTime.now();
    final difference = now.difference(lastPaused).inSeconds;

    if (difference >= timeoutSeconds) {
      lock();
    }
  }
}
