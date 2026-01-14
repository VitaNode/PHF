// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'PaperHealth';

  @override
  String get common_save => 'Save';

  @override
  String get common_edit => 'Edit';

  @override
  String get common_delete => 'Delete';

  @override
  String get common_cancel => 'Cancel';

  @override
  String get common_confirm => 'Confirm';

  @override
  String get common_retry => 'Retry';

  @override
  String get common_refresh => 'Refresh';

  @override
  String get common_reset => 'Reset';

  @override
  String common_image_count(int count) {
    return '$count images';
  }

  @override
  String get security_status_encrypted => 'AES-256 Encrypted On-Device';

  @override
  String get security_status_unverified => 'Encryption Not Verified';

  @override
  String get common_loading => 'Loading...';

  @override
  String common_load_failed(String error) {
    return 'Load failed: $error';
  }

  @override
  String get lock_screen_title => 'Please enter PIN to unlock';

  @override
  String get lock_screen_error => 'Incorrect PIN, please try again';

  @override
  String get lock_screen_biometric_tooltip => 'Unlock with biometrics';

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
  String get ingestion_take_photo => 'Take Photo';

  @override
  String get ingestion_pick_gallery => 'Pick from Gallery';

  @override
  String get ingestion_processing_queue => 'Added to background OCR queue...';

  @override
  String ingestion_save_error(String error) {
    return 'Save blocked: $error';
  }

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

  @override
  String get review_list_title => 'Pending Records';

  @override
  String get review_list_empty => 'No records pending review';

  @override
  String get review_edit_ocr_section => 'Recognition Results (Tap to edit)';

  @override
  String get review_edit_ocr_hint =>
      'Tap text to focus on the corresponding image area';

  @override
  String review_approve_failed(String error) {
    return 'Archive failed: $error';
  }

  @override
  String get settings_title => 'Settings';

  @override
  String get settings_section_profiles => 'Profiles & Categories';

  @override
  String get settings_manage_profiles => 'Manage Profiles';

  @override
  String get settings_manage_profiles_desc => 'Add or edit personnel profiles';

  @override
  String get settings_tag_library => 'Tag Library';

  @override
  String get settings_tag_library_desc => 'Maintain medical record tags';

  @override
  String get settings_language => 'Language';

  @override
  String get settings_language_desc => 'Switch application display language';

  @override
  String get settings_section_security => 'Data Security';

  @override
  String get settings_privacy_security => 'Privacy & Security';

  @override
  String get settings_privacy_security_desc => 'Modify PIN and biometrics';

  @override
  String get settings_backup_restore => 'Backup & Restore';

  @override
  String get settings_backup_restore_desc => 'Export encrypted backup files';

  @override
  String get settings_section_support => 'Help & Support';

  @override
  String get settings_feedback => 'Feedback';

  @override
  String get settings_feedback_desc => 'Report issues or suggestions';

  @override
  String get settings_section_about => 'About';

  @override
  String get settings_privacy_policy => 'Privacy Policy';

  @override
  String get settings_privacy_policy_desc => 'View application privacy policy';

  @override
  String get settings_version => 'Version';

  @override
  String get settings_security_app_lock => 'App Lock';

  @override
  String get settings_security_change_pin => 'Change PIN';

  @override
  String get settings_security_change_pin_desc =>
      'Change the 6-digit code used to unlock';

  @override
  String get settings_security_lock_timeout => 'Auto-Lock Timeout';

  @override
  String get settings_security_timeout_immediate => 'Immediate';

  @override
  String get settings_security_timeout_1min => 'After 1 minute';

  @override
  String get settings_security_timeout_5min => 'After 5 minutes';

  @override
  String settings_security_timeout_custom(int minutes) {
    return 'After $minutes minutes';
  }

  @override
  String get settings_security_biometrics => 'Biometric Unlock';

  @override
  String get settings_security_biometrics_desc =>
      'Enable fingerprint or face recognition';

  @override
  String get settings_security_biometrics_enabled_failed =>
      'Failed to enable biometrics';

  @override
  String get settings_security_biometrics_disabled_failed =>
      'Failed to disable biometrics';

  @override
  String get settings_security_info_card =>
      'PaperHealth uses local encryption. Your PIN and biometric data are stored only in your device\'s secure enclave. No third party (including developers) can access them.';

  @override
  String get settings_security_pin_current => 'Enter current PIN';

  @override
  String get settings_security_pin_new => 'Enter new PIN';

  @override
  String get settings_security_pin_confirm => 'Confirm new PIN';

  @override
  String get settings_security_pin_mismatch => 'PINs do not match';

  @override
  String get settings_security_pin_success => 'PIN changed successfully';

  @override
  String get settings_security_pin_error => 'Incorrect current PIN';

  @override
  String get person_management_empty => 'No profiles found';

  @override
  String get person_management_default => 'Default Profile';

  @override
  String get person_delete_title => 'Delete Profile';

  @override
  String person_delete_confirm(String name) {
    return 'Are you sure you want to delete $name? Deletion will be rejected if there are records under this profile.';
  }

  @override
  String get person_edit_title => 'Edit Profile';

  @override
  String get person_add_title => 'New Profile';

  @override
  String get person_field_nickname => 'Nickname';

  @override
  String get person_field_nickname_hint => 'Enter name or title';

  @override
  String get person_field_color => 'Select Profile Color';

  @override
  String get tag_management_empty => 'No tags found';

  @override
  String get tag_management_custom => 'Custom Tags';

  @override
  String get tag_management_system => 'System Tags';

  @override
  String get tag_add_title => 'New Tag';

  @override
  String get tag_edit_title => 'Edit Tag';

  @override
  String get tag_delete_title => 'Delete Tag';

  @override
  String tag_delete_confirm(String name) {
    return 'Are you sure you want to delete $name? This will remove it from all associated images.';
  }

  @override
  String get tag_field_name => 'Tag Name';

  @override
  String get tag_field_name_hint => 'e.g., Lab Result, X-Ray';

  @override
  String get tag_reorder_title => 'Reorder Tags';

  @override
  String tag_create_new(String query) {
    return 'Create new tag: $query';
  }

  @override
  String get feedback_info =>
      'We are committed to protecting your privacy. The app runs 100% offline.\nContact us via the following methods.';

  @override
  String get feedback_email => 'Send Email';

  @override
  String get feedback_github => 'GitHub Issues';

  @override
  String get feedback_github_desc => 'Report bugs or suggestions';

  @override
  String get feedback_logs_section => 'System Diagnostics';

  @override
  String get feedback_logs_copy => 'Copy Logs';

  @override
  String get feedback_logs_exporting => 'Exporting...';

  @override
  String get feedback_logs_hint =>
      'Copy device info and sanitized logs to clipboard for sharing.';

  @override
  String get feedback_error_email => 'Could not open email client';

  @override
  String get feedback_error_browser => 'Could not open browser';

  @override
  String get feedback_copied => 'Copied to clipboard';

  @override
  String get detail_hospital_label => 'Hospital';

  @override
  String get detail_date_label => 'Visit Date';

  @override
  String get detail_tags_label => 'Tags';

  @override
  String get detail_image_delete_title => 'Confirm Delete';

  @override
  String get detail_image_delete_confirm =>
      'Are you sure you want to delete this image? This action cannot be undone.';

  @override
  String get detail_ocr_queued => 'Re-added to queue, please wait...';

  @override
  String detail_ocr_failed(Object error) {
    return 'OCR failed: $error';
  }

  @override
  String get detail_ocr_text => 'OCR Text';

  @override
  String get detail_ocr_title => 'OCR Text';

  @override
  String get detail_ocr_result => 'OCR Result';

  @override
  String get detail_title => 'Record Detail';

  @override
  String get detail_edit_title => 'Edit Record';

  @override
  String get detail_save => 'Save Changes';

  @override
  String get detail_edit_page => 'Edit Page';

  @override
  String get detail_retrigger_ocr => 'Retrigger OCR';

  @override
  String get detail_delete_page => 'Delete Page';

  @override
  String get detail_cancel_edit => 'Cancel Edit';

  @override
  String get detail_view_raw => 'Raw Text';

  @override
  String get detail_view_enhanced => 'Smart Enhanced';

  @override
  String get detail_ocr_collapse => 'Collapse';

  @override
  String get detail_ocr_expand => 'Expand';

  @override
  String get detail_record_not_found => 'Record not found';

  @override
  String get detail_manage_tags => 'Manage Tags';

  @override
  String get detail_no_tags => 'No Tags';

  @override
  String detail_save_error(String error) {
    return 'Save failed: $error';
  }

  @override
  String get home_empty_records => 'No records yet';

  @override
  String timeline_pending_review(int count) {
    return '$count items pending verification';
  }

  @override
  String get timeline_pending_hint => 'Tap to verify and archive';

  @override
  String get disclaimer_title => 'Medical Disclaimer';

  @override
  String get disclaimer_welcome => 'Welcome to PaperHealth.';

  @override
  String get disclaimer_intro =>
      'Before you start using this application, please read the following disclaimer carefully:';

  @override
  String get disclaimer_point_1_title => '1. Not Medical Advice';

  @override
  String get disclaimer_point_1_desc =>
      'PaperHealth (hereinafter referred to as \"this application\") serves only as a personal medical record organization and digitization tool. It does not provide any form of medical diagnosis, advice, or treatment. No content within the app should be considered professional medical advice.';

  @override
  String get disclaimer_point_2_title => '2. OCR Accuracy';

  @override
  String get disclaimer_point_2_desc =>
      'Information extracted via OCR (Optical Character Recognition) technology may contain errors. Users must verify this information against original paper reports or digital originals. The developer does not guarantee 100% accuracy of the recognition results.';

  @override
  String get disclaimer_point_3_title => '3. Professional Consultation';

  @override
  String get disclaimer_point_3_desc =>
      'Any medical decision should be made in consultation with professional medical institutions or doctors. This application and its developers assume no legal responsibility for any direct or indirect consequences resulting from reliance on the information provided by this application.';

  @override
  String get disclaimer_point_4_title => '4. Local Data Storage';

  @override
  String get disclaimer_point_4_desc =>
      'This application promises that all data is stored only locally with encryption and is not uploaded to any cloud server. Users are solely responsible for the physical security of their devices, PIN privacy, and data backups.';

  @override
  String get disclaimer_point_5_title => '5. Emergency Situations';

  @override
  String get disclaimer_point_5_desc =>
      'If you are in a medical emergency, please call your local emergency services or go to the nearest hospital immediately. Do not rely on this application for emergency judgment.';

  @override
  String get disclaimer_footer =>
      'By clicking \"Accept\", you acknowledge that you have read and accepted all the terms above.';

  @override
  String get disclaimer_checkbox =>
      'I have read and agree to the medical disclaimer above';

  @override
  String get disclaimer_accept_button => 'Accept & Continue';

  @override
  String get seed_person_me => 'Me';

  @override
  String get seed_tag_lab => 'Lab Result';

  @override
  String get seed_tag_exam => 'Examination';

  @override
  String get seed_tag_record => 'Medical Record';

  @override
  String get seed_tag_prescription => 'Prescription';

  @override
  String get filter_title => 'Filters';

  @override
  String get filter_date_range => 'Date Range';

  @override
  String get filter_select_date_range => 'Select Date Range';

  @override
  String get filter_date_to => 'to';

  @override
  String get filter_tags_multi => 'Tags (Multi-select)';

  @override
  String get search_hint => 'Search OCR, hospital, or notes...';

  @override
  String search_result_count(int count) {
    return 'Found $count results';
  }

  @override
  String get search_initial_title => 'Start Searching';

  @override
  String get search_initial_desc =>
      'Enter hospital, medication, or tag keywords';

  @override
  String get search_empty_title => 'No results found';

  @override
  String get search_empty_desc => 'Try different keywords or check spelling';

  @override
  String search_searching_person(String name) {
    return 'Searching: $name';
  }
}
