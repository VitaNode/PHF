import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthStateController extends _$AuthStateController with WidgetsBindingObserver {
  @override
  bool build() {
    // 注册生命周期观察者
    WidgetsBinding.instance.addObserver(this);
    // 记得在析构时移除观察者，但这是全局 Provider，通常存活于应用镜像周期
    
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
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    // 当由于进入后台或者被杀掉而重新进入时，触发锁定逻辑
    if (lifecycleState == AppLifecycleState.paused) {
      lock();
    }
  }
}
