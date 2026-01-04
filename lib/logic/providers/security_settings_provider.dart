/// # Security Settings Provider
///
/// ## Description
/// 响应式管理安全设置状态。
/// 提供 PIN 修改、生物识别开关等高层操作。
///
/// ## 修复记录
/// - 在 `changePin` 和 `toggleBiometrics` 中实现 `isLoading` 状态处理，优化用户交互体验。
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'core_providers.dart';

part 'security_settings_provider.freezed.dart';
part 'security_settings_provider.g.dart';

@freezed
abstract class SecuritySettingsState with _$SecuritySettingsState {
  const factory SecuritySettingsState({
    @Default(false) bool hasPin,
    @Default(false) bool isBiometricsEnabled,
    @Default(false) bool canCheckBiometrics,
    @Default(false) bool isLoading,
  }) = _SecuritySettingsState;
}

@riverpod
class SecuritySettingsController extends _$SecuritySettingsController {
  @override
  FutureOr<SecuritySettingsState> build() async {
    final service = ref.watch(securityServiceProvider);

    return SecuritySettingsState(
      hasPin: await service.hasLock(),
      isBiometricsEnabled: await service.isBiometricsEnabled(),
      canCheckBiometrics: await service.canCheckBiometrics(),
    );
  }

  /// 修改 PIN 码
  Future<bool> changePin(String oldPin, String newPin) async {
    final currentState = state.asData?.value;
    if (currentState != null) {
      state = AsyncData(currentState.copyWith(isLoading: true));
    }

    final service = ref.read(securityServiceProvider);
    final success = await service.changePin(oldPin, newPin);

    if (success) {
      ref.invalidateSelf();
    } else {
      if (currentState != null) {
        state = AsyncData(currentState.copyWith(isLoading: false));
      }
    }
    return success;
  }

  /// 切换生物识别开关
  Future<bool> toggleBiometrics(bool enabled) async {
    final currentState = state.asData?.value;
    if (currentState != null) {
      state = AsyncData(currentState.copyWith(isLoading: true));
    }

    final service = ref.read(securityServiceProvider);
    bool success = false;

    if (enabled) {
      success = await service.enableBiometrics();
    } else {
      await service.disableBiometrics();
      success = true;
    }

    if (success) {
      ref.invalidateSelf();
    } else {
      if (currentState != null) {
        state = AsyncData(currentState.copyWith(isLoading: false));
      }
    }
    return success;
  }
}
