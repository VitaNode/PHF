// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'PaperHealth';

  @override
  String get common_save => 'सहेजें';

  @override
  String get common_edit => 'संपादित करें';

  @override
  String get common_delete => 'हटाएं';

  @override
  String get common_cancel => 'रद्द करें';

  @override
  String get common_confirm => 'पुष्टि करें';

  @override
  String get lock_screen_title => 'अनलॉक करने के लिए कृपया पिन दर्ज करें';

  @override
  String get lock_screen_error => 'गलत पिन, कृपया पुनः प्रयास करें';

  @override
  String get lock_screen_biometric_tooltip => 'बायोमेट्रिक्स के साथ अनलॉक करें';

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
