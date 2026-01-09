// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'PaperHealth';

  @override
  String get common_save => 'บันทึก';

  @override
  String get common_edit => 'แก้ไข';

  @override
  String get common_delete => 'ลบ';

  @override
  String get common_cancel => 'ยกเลิก';

  @override
  String get common_confirm => 'ยืนยัน';

  @override
  String get lock_screen_title => 'กรุณาใส่รหัส PIN เพื่อปลดล็อก';

  @override
  String get lock_screen_error => 'รหัส PIN ไม่ถูกต้อง กรุณาลองใหม่อีกครั้ง';

  @override
  String get lock_screen_biometric_tooltip => 'ปลดล็อกด้วยไบโอเมตริกซ์';

  @override
  String get ingestion_title => 'Preview & Processing';

  @override
  String get ingestion_empty_hint => 'Please add medical record photos';

  @override
  String get ingestion_add_now => 'Add Now';

  @override
  String get ingestion_ocr_hint =>
      'Metadata will be recognized by background OCR after saving';

  @override
  String get ingestion_submit_button => 'Start Processing & Archive';

  @override
  String get ingestion_grouped_report => 'Mark as a multi-page report';

  @override
  String get ingestion_grouped_report_hint =>
      'SLM will treat these images as a single continuous document';

  @override
  String get review_edit_title => 'Verify Information';

  @override
  String get review_edit_confirm => 'Confirm & Archive';

  @override
  String get review_edit_basic_info => 'Basic Info (Tap to Edit)';

  @override
  String get review_edit_hospital_label => 'Hospital/Institution';

  @override
  String get review_edit_date_label => 'Visit Date';

  @override
  String get review_edit_confidence => 'OCR Confidence';

  @override
  String review_edit_page_indicator(int current, int total) {
    return 'Image $current / $total (Please verify each page)';
  }
}
