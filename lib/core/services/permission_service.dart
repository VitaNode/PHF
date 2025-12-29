/// # PermissionService
///
/// ## Description
/// 统一管理应用所需的系统权限。封装了 `permission_handler` 的调用。
///
/// ## Required Permissions
/// - **Camera**: 用于拍照录入病历。
/// - **Photos**: 用于从相册导入存量病历。
///
/// ## Handling
/// - 在 Android 上，`photos` 权限对应 `storage` 或 `photos` (API 33+)。
/// - 在 iOS 上，需要对应的 `Info.plist` 配置。

import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// 请求相机权限
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// 请求相册/存储读取权限
  Future<bool> requestPhotosPermission() async {
    // 根据系统版本和平台，permission_handler 会处理底层的差异
    final status = await Permission.photos.request();
    
    if (status.isPermanentlyDenied) {
      // 建议引导用户去设置页面
      return false;
    }
    
    return status.isGranted || status.isLimited;
  }

  /// 检查是否拥有核心权限
  Future<bool> hasCameraPermission() async {
    return Permission.camera.isGranted;
  }

  Future<bool> hasPhotosPermission() async {
    return Permission.photos.isGranted || Permission.photos.isLimited;
  }

  /// 打开系统设置页面
  Future<bool> openAppSettingsPage() async {
    return openAppSettings();
  }
}
