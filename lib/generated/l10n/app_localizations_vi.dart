// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'PaperHealth';

  @override
  String get common_save => 'Lưu';

  @override
  String get common_edit => 'Chỉnh sửa';

  @override
  String get common_delete => 'Xóa';

  @override
  String get common_cancel => 'Hủy';

  @override
  String get common_confirm => 'Xác nhận';

  @override
  String get lock_screen_title => 'Vui lòng nhập mã PIN để mở khóa';

  @override
  String get lock_screen_error => 'Mã PIN không đúng, vui lòng thử lại';

  @override
  String get lock_screen_biometric_tooltip => 'Mở khóa bằng sinh trắc học';

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
