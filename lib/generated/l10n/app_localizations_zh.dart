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

  @override
  String get ingestion_title => '预览与处理';

  @override
  String get ingestion_empty_hint => '请添加病历照片';

  @override
  String get ingestion_add_now => '立即添加';

  @override
  String get ingestion_ocr_hint => '元数据将在保存后由背景 OCR 自动识别';

  @override
  String get ingestion_submit_button => '开始处理并归档';

  @override
  String get ingestion_grouped_report => '标记为同一份跨页报告';

  @override
  String get ingestion_grouped_report_hint => '开启后，SLM 将把这些图片视为一个连续的完整报告进行分析';

  @override
  String get review_edit_title => '校对信息';

  @override
  String get review_edit_confirm => '确认归档';

  @override
  String get review_edit_basic_info => '基本信息 (可点击修改)';

  @override
  String get review_edit_hospital_label => '医院/机构名称';

  @override
  String get review_edit_date_label => '就诊日期';

  @override
  String get review_edit_confidence => 'OCR 置信度';

  @override
  String review_edit_page_indicator(int current, int total) {
    return '图片 $current / $total (请核对每页信息)';
  }
}
