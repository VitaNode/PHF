/// # ISecurityService
///
/// ## Description
/// 安全服务的业务契约。
/// 负责应用锁（PIN 码、生物识别）的设置、验证与持久化管理。
library;

abstract interface class ISecurityService {
  /// 设置或初始化 PIN 码
  Future<void> setPin(String pin);

  /// 验证输入的 PIN 码是否正确
  Future<bool> validatePin(String inputPin);

  /// 修改 PIN 码
  ///
  /// 需验证 [oldPin] 成功后方可设置 [newPin]。
  Future<bool> changePin(String oldPin, String newPin);

  /// 检查设备是否支持生物识别（指纹/面容）
  Future<bool> canCheckBiometrics();

  /// 启用生物识别
  ///
  /// 成功通过一次原生验证后开启。
  Future<bool> enableBiometrics();

  /// 禁用生物识别
  Future<void> disableBiometrics();

  /// 检查当前是否已启用生物识别
  Future<bool> isBiometricsEnabled();

  /// 检查是否已设置安全锁（PIN）
  Future<bool> hasLock();
}
