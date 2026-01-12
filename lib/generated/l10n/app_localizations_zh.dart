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
  String get common_retry => '重试';

  @override
  String get common_refresh => '刷新';

  @override
  String get common_reset => '重置';

  @override
  String common_image_count(int count) {
    return '共 $count 张图片';
  }

  @override
  String get security_status_encrypted => '设备端 AES-256 加密';

  @override
  String get security_status_unverified => '加密未验证';

  @override
  String get common_loading => '加载中...';

  @override
  String common_load_failed(String error) {
    return '加载失败: $error';
  }

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
  String get ingestion_take_photo => '拍照';

  @override
  String get ingestion_pick_gallery => '从相册选择';

  @override
  String get ingestion_processing_queue => '已进入后台 OCR 处理队列...';

  @override
  String ingestion_save_error(String error) {
    return '保存受阻: $error';
  }

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

  @override
  String get review_list_title => '待确认病历';

  @override
  String get review_list_empty => '暂无待确认病历';

  @override
  String get review_edit_ocr_section => '识别内容 (可点击逐行校对)';

  @override
  String get review_edit_ocr_hint => '点击下方文字，上方将自动放大对应图片区域';

  @override
  String review_approve_failed(String error) {
    return '归档失败: $error';
  }

  @override
  String get settings_title => '设置';

  @override
  String get settings_section_profiles => '档案与分类';

  @override
  String get settings_manage_profiles => '管理档案';

  @override
  String get settings_manage_profiles_desc => '添加或编辑人员档案';

  @override
  String get settings_tag_library => '标签库管理';

  @override
  String get settings_tag_library_desc => '维护病历分类标签';

  @override
  String get settings_language => '语言设置';

  @override
  String get settings_language_desc => '切换应用显示语言';

  @override
  String get settings_section_security => '数据安全';

  @override
  String get settings_privacy_security => '隐私与安全';

  @override
  String get settings_privacy_security_desc => '修改 PIN 码及生物识别';

  @override
  String get settings_backup_restore => '备份与恢复';

  @override
  String get settings_backup_restore_desc => '导出加密备份文件';

  @override
  String get settings_section_support => '帮助与支持';

  @override
  String get settings_feedback => '问题反馈';

  @override
  String get settings_feedback_desc => '报告问题或提交建议';

  @override
  String get settings_section_about => '关于';

  @override
  String get settings_privacy_policy => '隐私政策';

  @override
  String get settings_privacy_policy_desc => '查看应用隐私保护声明';

  @override
  String get settings_version => '版本信息';

  @override
  String get settings_security_app_lock => '应用锁';

  @override
  String get settings_security_change_pin => '修改 PIN 码';

  @override
  String get settings_security_change_pin_desc => '更改用于解锁应用的 6 位数字密码';

  @override
  String get settings_security_lock_timeout => '自动锁定时间';

  @override
  String get settings_security_timeout_immediate => '立即';

  @override
  String get settings_security_timeout_1min => '离开 1 分钟后';

  @override
  String get settings_security_timeout_5min => '离开 5 分钟后';

  @override
  String settings_security_timeout_custom(int minutes) {
    return '离开 $minutes 分钟后';
  }

  @override
  String get settings_security_biometrics => '生物识别解锁';

  @override
  String get settings_security_biometrics_desc => '开启后支持使用指纹或面容识别';

  @override
  String get settings_security_biometrics_enabled_failed => '启用生物识别失败';

  @override
  String get settings_security_biometrics_disabled_failed => '禁用生物识别失败';

  @override
  String get settings_security_info_card =>
      'PaperHealth 采用本地加密技术，您的 PIN 码及生物识别信息仅存储在设备的系统安全隔离区，任何第三方（包括开发者）均无法获取。';

  @override
  String get settings_security_pin_current => '请输入当前 PIN 码';

  @override
  String get settings_security_pin_new => '请输入新 PIN 码';

  @override
  String get settings_security_pin_confirm => '请再次输入新 PIN 码';

  @override
  String get settings_security_pin_mismatch => '两次输入的新 PIN 码不一致';

  @override
  String get settings_security_pin_success => 'PIN 码修改成功';

  @override
  String get settings_security_pin_error => '当前 PIN 码错误，修改失败';

  @override
  String get person_management_empty => '暂无档案';

  @override
  String get person_management_default => '默认档案';

  @override
  String get person_delete_title => '删除档案';

  @override
  String person_delete_confirm(String name) {
    return '确定要删除 $name 吗？如果该档案下存在记录，删除将被拒绝。';
  }

  @override
  String get person_edit_title => '编辑档案';

  @override
  String get person_add_title => '新建档案';

  @override
  String get person_field_nickname => '昵称';

  @override
  String get person_field_nickname_hint => '请输入姓名或称呼';

  @override
  String get person_field_color => '选择档案颜色';

  @override
  String get tag_management_empty => '暂无标签';

  @override
  String get tag_management_custom => '自定义标签';

  @override
  String get tag_management_system => '系统内置';

  @override
  String get tag_add_title => '新建标签';

  @override
  String get tag_edit_title => '编辑标签';

  @override
  String get tag_delete_title => '删除标签';

  @override
  String tag_delete_confirm(String name) {
    return '确定要删除标签 $name 吗？此操作会从所有关联的图片中移除该标签。';
  }

  @override
  String get tag_field_name => '标签名称';

  @override
  String get tag_field_name_hint => '例：化验单、胸透';

  @override
  String get tag_reorder_title => '调整排序';

  @override
  String tag_create_new(String query) {
    return '创建新标签: $query';
  }

  @override
  String get feedback_info => '我们致力于保护您的隐私，App 为纯离线运行。\n如需反馈问题，请通过以下方式与我们联系。';

  @override
  String get feedback_email => '发送邮件';

  @override
  String get feedback_github => 'GitHub Issues';

  @override
  String get feedback_github_desc => '提交 Bug 或建议';

  @override
  String get feedback_logs_section => '系统诊断';

  @override
  String get feedback_logs_copy => '一键复制日志';

  @override
  String get feedback_logs_exporting => '正在导出...';

  @override
  String get feedback_logs_hint => '将复制设备信息及已脱敏的日志到剪贴板，方便您粘贴到邮件或 Issue 中。';

  @override
  String get feedback_error_email => '无法打开邮件客户端';

  @override
  String get feedback_error_browser => '无法打开浏览器';

  @override
  String get feedback_copied => '已复制到剪贴板';

  @override
  String get detail_hospital_label => '医院';

  @override
  String get detail_date_label => '就诊日期';

  @override
  String get detail_tags_label => '关联标签';

  @override
  String get detail_image_delete_title => '删除确认';

  @override
  String get detail_image_delete_confirm => '确定要删除当前这张图片吗？此操作不可撤销。';

  @override
  String get detail_ocr_queued => '已重新加入识别队列，请稍候...';

  @override
  String detail_ocr_failed(Object error) {
    return '重新识别失败: $error';
  }

  @override
  String get detail_ocr_text => '识别文本';

  @override
  String get detail_ocr_title => 'OCR 识别文本';

  @override
  String get detail_ocr_result => '识别结果';

  @override
  String get detail_title => '记录详情';

  @override
  String get detail_edit_title => '编辑记录';

  @override
  String get detail_save => '保存修改';

  @override
  String get detail_edit_page => '编辑图片';

  @override
  String get detail_retrigger_ocr => '重新识别';

  @override
  String get detail_delete_page => '删除图片';

  @override
  String get detail_cancel_edit => '取消编辑';

  @override
  String get detail_view_raw => '查看原文';

  @override
  String get detail_view_enhanced => '智能增强';

  @override
  String get detail_ocr_collapse => '收起';

  @override
  String get detail_ocr_expand => '展开全文';

  @override
  String get detail_record_not_found => '记录不存在';

  @override
  String get detail_manage_tags => '管理标签';

  @override
  String get detail_no_tags => '无标签';

  @override
  String detail_save_error(String error) {
    return '保存失败: $error';
  }

  @override
  String get home_empty_records => '暂无记录';

  @override
  String timeline_pending_review(int count) {
    return '有 $count 项病历待确认';
  }

  @override
  String get timeline_pending_hint => '点击核对并归档';

  @override
  String get disclaimer_title => '医疗免责声明';

  @override
  String get disclaimer_welcome => '欢迎使用 PaperHealth.';

  @override
  String get disclaimer_intro => '在您开始使用本应用之前，请务必仔细阅读以下免责声明：';

  @override
  String get disclaimer_point_1_title => '1. 非医疗建议';

  @override
  String get disclaimer_point_1_desc =>
      'PaperHealth (以下简称“本应用”) 仅作为个人医疗记录整理和数字化工具，不提供任何形式的医疗诊断、建议或治疗方案。应用内的任何内容均不应被视为专业医疗意见。';

  @override
  String get disclaimer_point_2_title => '2. OCR 准确性';

  @override
  String get disclaimer_point_2_desc =>
      '本应用通过 OCR (文字识别) 技术提取的信息可能存在误差。用户在参考这些信息时，必须核对原始纸质报告或数字原件。开发者不保证识别结果的 100% 准确性。';

  @override
  String get disclaimer_point_3_title => '3. 专业咨询';

  @override
  String get disclaimer_point_3_desc =>
      '任何医疗决策应咨询专业医疗机构或医生。因依赖本应用提供的信息而导致的任何直接或间接后果，本应用及其开发者不承担法律责任。';

  @override
  String get disclaimer_point_4_title => '4. 本地数据存储';

  @override
  String get disclaimer_point_4_desc =>
      '本应用承诺所有数据仅在本地加密存储，不上传至任何云端服务器。用户需自行负责其设备的物理安全、PIN 码隐私及数据备份。';

  @override
  String get disclaimer_point_5_title => '5. 紧急情况';

  @override
  String get disclaimer_point_5_desc =>
      '如果您正处于医疗紧急情况下，请立即拨打当地急救电话或前往最近的医院，切勿依赖本应用进行应急判断。';

  @override
  String get disclaimer_footer => '点击“同意”即表示您已阅读并接受以上全部条款。';

  @override
  String get disclaimer_checkbox => '我已阅读并同意上述医疗免责声明';

  @override
  String get disclaimer_accept_button => '同意并继续';

  @override
  String get seed_person_me => '本人';

  @override
  String get seed_tag_lab => '检验';

  @override
  String get seed_tag_exam => '检查';

  @override
  String get seed_tag_record => '病历';

  @override
  String get seed_tag_prescription => '处方';

  @override
  String get filter_title => '筛选条件';

  @override
  String get filter_date_range => '日期范围';

  @override
  String get filter_select_date_range => '选择日期范围';

  @override
  String get filter_date_to => '至';

  @override
  String get filter_tags_multi => '标签 (多选)';

  @override
  String get search_hint => '搜索 OCR 内容、医院或备注...';

  @override
  String search_result_count(int count) {
    return '找到 $count 条结果';
  }

  @override
  String get search_initial_title => '开始搜索';

  @override
  String get search_initial_desc => '输入医院、药物、指标或标签关键词';

  @override
  String get search_empty_title => '未找到相关内容';

  @override
  String get search_empty_desc => '尝试更换关键词或检查拼写';

  @override
  String search_searching_person(String name) {
    return '正在搜索: $name';
  }
}
