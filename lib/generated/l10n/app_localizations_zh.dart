// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '纸上健康';

  @override
  String get common_save => '保存';

  @override
  String get common_edit => '编辑';

  @override
  String get common_delete => '删除';

  @override
  String get common_cancel => '取消';

  @override
  String get common_confirm => '确认';

  @override
  String get lock_screen_title => '请输入 PIN 码解锁';

  @override
  String get lock_screen_error => 'PIN 码错误，请重新输入';

  @override
  String get lock_screen_biometric_tooltip => '使用生物识别解锁';
}
