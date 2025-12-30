import 'package:flutter/material.dart';
import 'package:phf/logic/providers/core_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
Future<bool> hasLock(HasLockRef ref) async {
  final repo = ref.watch(appMetaRepositoryProvider);
  return repo.hasLock();
}

@Riverpod(keepAlive: true)
class AuthStateController extends _$AuthStateController with WidgetsBindingObserver {
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
    state = false;
  }

  void lock() {
    state = true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 当由于进入后台或者被杀掉而重新进入时，触发锁定逻辑
    if (state == AppLifecycleState.paused) {
      lock();
    }
  }
}
