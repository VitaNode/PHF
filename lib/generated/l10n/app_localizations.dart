import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_th.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('hi'),
    Locale('id'),
    Locale('pt'),
    Locale('th'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'PaperHealth'**
  String get appTitle;

  /// No description provided for @common_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get common_save;

  /// No description provided for @common_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get common_edit;

  /// No description provided for @common_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get common_delete;

  /// No description provided for @common_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get common_cancel;

  /// No description provided for @common_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get common_confirm;

  /// No description provided for @common_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get common_retry;

  /// No description provided for @common_refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get common_refresh;

  /// No description provided for @common_reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get common_reset;

  /// No description provided for @common_image_count.
  ///
  /// In en, this message translates to:
  /// **'{count} images'**
  String common_image_count(int count);

  /// No description provided for @security_status_encrypted.
  ///
  /// In en, this message translates to:
  /// **'AES-256 Encrypted On-Device'**
  String get security_status_encrypted;

  /// No description provided for @security_status_unverified.
  ///
  /// In en, this message translates to:
  /// **'Encryption Not Verified'**
  String get security_status_unverified;

  /// No description provided for @common_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get common_loading;

  /// No description provided for @common_load_failed.
  ///
  /// In en, this message translates to:
  /// **'Load failed: {error}'**
  String common_load_failed(String error);

  /// No description provided for @lock_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Please enter PIN to unlock'**
  String get lock_screen_title;

  /// No description provided for @lock_screen_error.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN, please try again'**
  String get lock_screen_error;

  /// No description provided for @lock_screen_biometric_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Unlock with biometrics'**
  String get lock_screen_biometric_tooltip;

  /// No description provided for @ingestion_title.
  ///
  /// In en, this message translates to:
  /// **'Preview & Processing'**
  String get ingestion_title;

  /// No description provided for @ingestion_empty_hint.
  ///
  /// In en, this message translates to:
  /// **'Please add medical record photos'**
  String get ingestion_empty_hint;

  /// No description provided for @ingestion_add_now.
  ///
  /// In en, this message translates to:
  /// **'Add Now'**
  String get ingestion_add_now;

  /// No description provided for @ingestion_ocr_hint.
  ///
  /// In en, this message translates to:
  /// **'Metadata will be recognized by background OCR after saving'**
  String get ingestion_ocr_hint;

  /// No description provided for @ingestion_submit_button.
  ///
  /// In en, this message translates to:
  /// **'Start Processing & Archive'**
  String get ingestion_submit_button;

  /// No description provided for @ingestion_grouped_report.
  ///
  /// In en, this message translates to:
  /// **'Mark as a multi-page report'**
  String get ingestion_grouped_report;

  /// No description provided for @ingestion_grouped_report_hint.
  ///
  /// In en, this message translates to:
  /// **'SLM will treat these images as a single continuous document'**
  String get ingestion_grouped_report_hint;

  /// No description provided for @ingestion_take_photo.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get ingestion_take_photo;

  /// No description provided for @ingestion_pick_gallery.
  ///
  /// In en, this message translates to:
  /// **'Pick from Gallery'**
  String get ingestion_pick_gallery;

  /// No description provided for @ingestion_processing_queue.
  ///
  /// In en, this message translates to:
  /// **'Added to background OCR queue...'**
  String get ingestion_processing_queue;

  /// No description provided for @ingestion_save_error.
  ///
  /// In en, this message translates to:
  /// **'Save blocked: {error}'**
  String ingestion_save_error(String error);

  /// No description provided for @review_edit_title.
  ///
  /// In en, this message translates to:
  /// **'Verify Information'**
  String get review_edit_title;

  /// No description provided for @review_edit_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Archive'**
  String get review_edit_confirm;

  /// No description provided for @review_edit_basic_info.
  ///
  /// In en, this message translates to:
  /// **'Basic Info (Tap to Edit)'**
  String get review_edit_basic_info;

  /// No description provided for @review_edit_hospital_label.
  ///
  /// In en, this message translates to:
  /// **'Hospital/Institution'**
  String get review_edit_hospital_label;

  /// No description provided for @review_edit_date_label.
  ///
  /// In en, this message translates to:
  /// **'Visit Date'**
  String get review_edit_date_label;

  /// No description provided for @review_edit_confidence.
  ///
  /// In en, this message translates to:
  /// **'OCR Confidence'**
  String get review_edit_confidence;

  /// No description provided for @review_edit_page_indicator.
  ///
  /// In en, this message translates to:
  /// **'Image {current} / {total} (Please verify each page)'**
  String review_edit_page_indicator(int current, int total);

  /// No description provided for @review_list_title.
  ///
  /// In en, this message translates to:
  /// **'Pending Records'**
  String get review_list_title;

  /// No description provided for @review_list_empty.
  ///
  /// In en, this message translates to:
  /// **'No records pending review'**
  String get review_list_empty;

  /// No description provided for @review_edit_ocr_section.
  ///
  /// In en, this message translates to:
  /// **'Recognition Results (Tap to edit)'**
  String get review_edit_ocr_section;

  /// No description provided for @review_edit_ocr_hint.
  ///
  /// In en, this message translates to:
  /// **'Tap text to focus on the corresponding image area'**
  String get review_edit_ocr_hint;

  /// No description provided for @review_approve_failed.
  ///
  /// In en, this message translates to:
  /// **'Archive failed: {error}'**
  String review_approve_failed(String error);

  /// No description provided for @settings_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_title;

  /// No description provided for @settings_section_profiles.
  ///
  /// In en, this message translates to:
  /// **'Profiles & Categories'**
  String get settings_section_profiles;

  /// No description provided for @settings_manage_profiles.
  ///
  /// In en, this message translates to:
  /// **'Manage Profiles'**
  String get settings_manage_profiles;

  /// No description provided for @settings_manage_profiles_desc.
  ///
  /// In en, this message translates to:
  /// **'Add or edit personnel profiles'**
  String get settings_manage_profiles_desc;

  /// No description provided for @settings_tag_library.
  ///
  /// In en, this message translates to:
  /// **'Tag Library'**
  String get settings_tag_library;

  /// No description provided for @settings_tag_library_desc.
  ///
  /// In en, this message translates to:
  /// **'Maintain medical record tags'**
  String get settings_tag_library_desc;

  /// No description provided for @settings_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_language;

  /// No description provided for @settings_language_desc.
  ///
  /// In en, this message translates to:
  /// **'Switch application display language'**
  String get settings_language_desc;

  /// No description provided for @settings_section_security.
  ///
  /// In en, this message translates to:
  /// **'Data Security'**
  String get settings_section_security;

  /// No description provided for @settings_privacy_security.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get settings_privacy_security;

  /// No description provided for @settings_privacy_security_desc.
  ///
  /// In en, this message translates to:
  /// **'Modify PIN and biometrics'**
  String get settings_privacy_security_desc;

  /// No description provided for @settings_backup_restore.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get settings_backup_restore;

  /// No description provided for @settings_backup_restore_desc.
  ///
  /// In en, this message translates to:
  /// **'Export encrypted backup files'**
  String get settings_backup_restore_desc;

  /// No description provided for @settings_section_support.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get settings_section_support;

  /// No description provided for @settings_feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get settings_feedback;

  /// No description provided for @settings_feedback_desc.
  ///
  /// In en, this message translates to:
  /// **'Report issues or suggestions'**
  String get settings_feedback_desc;

  /// No description provided for @settings_section_about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settings_section_about;

  /// No description provided for @settings_privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settings_privacy_policy;

  /// No description provided for @settings_privacy_policy_desc.
  ///
  /// In en, this message translates to:
  /// **'View application privacy policy'**
  String get settings_privacy_policy_desc;

  /// No description provided for @settings_version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settings_version;

  /// No description provided for @settings_security_app_lock.
  ///
  /// In en, this message translates to:
  /// **'App Lock'**
  String get settings_security_app_lock;

  /// No description provided for @settings_security_change_pin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get settings_security_change_pin;

  /// No description provided for @settings_security_change_pin_desc.
  ///
  /// In en, this message translates to:
  /// **'Change the 6-digit code used to unlock'**
  String get settings_security_change_pin_desc;

  /// No description provided for @settings_security_lock_timeout.
  ///
  /// In en, this message translates to:
  /// **'Auto-Lock Timeout'**
  String get settings_security_lock_timeout;

  /// No description provided for @settings_security_timeout_immediate.
  ///
  /// In en, this message translates to:
  /// **'Immediate'**
  String get settings_security_timeout_immediate;

  /// No description provided for @settings_security_timeout_1min.
  ///
  /// In en, this message translates to:
  /// **'After 1 minute'**
  String get settings_security_timeout_1min;

  /// No description provided for @settings_security_timeout_5min.
  ///
  /// In en, this message translates to:
  /// **'After 5 minutes'**
  String get settings_security_timeout_5min;

  /// No description provided for @settings_security_timeout_custom.
  ///
  /// In en, this message translates to:
  /// **'After {minutes} minutes'**
  String settings_security_timeout_custom(int minutes);

  /// No description provided for @settings_security_biometrics.
  ///
  /// In en, this message translates to:
  /// **'Biometric Unlock'**
  String get settings_security_biometrics;

  /// No description provided for @settings_security_biometrics_desc.
  ///
  /// In en, this message translates to:
  /// **'Enable fingerprint or face recognition'**
  String get settings_security_biometrics_desc;

  /// No description provided for @settings_security_biometrics_enabled_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to enable biometrics'**
  String get settings_security_biometrics_enabled_failed;

  /// No description provided for @settings_security_biometrics_disabled_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to disable biometrics'**
  String get settings_security_biometrics_disabled_failed;

  /// No description provided for @settings_security_info_card.
  ///
  /// In en, this message translates to:
  /// **'PaperHealth uses local encryption. Your PIN and biometric data are stored only in your device\'s secure enclave. No third party (including developers) can access them.'**
  String get settings_security_info_card;

  /// No description provided for @settings_security_pin_current.
  ///
  /// In en, this message translates to:
  /// **'Enter current PIN'**
  String get settings_security_pin_current;

  /// No description provided for @settings_security_pin_new.
  ///
  /// In en, this message translates to:
  /// **'Enter new PIN'**
  String get settings_security_pin_new;

  /// No description provided for @settings_security_pin_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm new PIN'**
  String get settings_security_pin_confirm;

  /// No description provided for @settings_security_pin_mismatch.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match'**
  String get settings_security_pin_mismatch;

  /// No description provided for @settings_security_pin_success.
  ///
  /// In en, this message translates to:
  /// **'PIN changed successfully'**
  String get settings_security_pin_success;

  /// No description provided for @settings_security_pin_error.
  ///
  /// In en, this message translates to:
  /// **'Incorrect current PIN'**
  String get settings_security_pin_error;

  /// No description provided for @person_management_empty.
  ///
  /// In en, this message translates to:
  /// **'No profiles found'**
  String get person_management_empty;

  /// No description provided for @person_management_default.
  ///
  /// In en, this message translates to:
  /// **'Default Profile'**
  String get person_management_default;

  /// No description provided for @person_delete_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Profile'**
  String get person_delete_title;

  /// No description provided for @person_delete_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}? Deletion will be rejected if there are records under this profile.'**
  String person_delete_confirm(String name);

  /// No description provided for @person_edit_title.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get person_edit_title;

  /// No description provided for @person_add_title.
  ///
  /// In en, this message translates to:
  /// **'New Profile'**
  String get person_add_title;

  /// No description provided for @person_field_nickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get person_field_nickname;

  /// No description provided for @person_field_nickname_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter name or title'**
  String get person_field_nickname_hint;

  /// No description provided for @person_field_color.
  ///
  /// In en, this message translates to:
  /// **'Select Profile Color'**
  String get person_field_color;

  /// No description provided for @tag_management_empty.
  ///
  /// In en, this message translates to:
  /// **'No tags found'**
  String get tag_management_empty;

  /// No description provided for @tag_management_custom.
  ///
  /// In en, this message translates to:
  /// **'Custom Tags'**
  String get tag_management_custom;

  /// No description provided for @tag_management_system.
  ///
  /// In en, this message translates to:
  /// **'System Tags'**
  String get tag_management_system;

  /// No description provided for @tag_add_title.
  ///
  /// In en, this message translates to:
  /// **'New Tag'**
  String get tag_add_title;

  /// No description provided for @tag_edit_title.
  ///
  /// In en, this message translates to:
  /// **'Edit Tag'**
  String get tag_edit_title;

  /// No description provided for @tag_delete_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Tag'**
  String get tag_delete_title;

  /// No description provided for @tag_delete_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}? This will remove it from all associated images.'**
  String tag_delete_confirm(String name);

  /// No description provided for @tag_field_name.
  ///
  /// In en, this message translates to:
  /// **'Tag Name'**
  String get tag_field_name;

  /// No description provided for @tag_field_name_hint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Lab Result, X-Ray'**
  String get tag_field_name_hint;

  /// No description provided for @tag_reorder_title.
  ///
  /// In en, this message translates to:
  /// **'Reorder Tags'**
  String get tag_reorder_title;

  /// No description provided for @tag_create_new.
  ///
  /// In en, this message translates to:
  /// **'Create new tag: {query}'**
  String tag_create_new(String query);

  /// No description provided for @feedback_info.
  ///
  /// In en, this message translates to:
  /// **'We are committed to protecting your privacy. The app runs 100% offline.\nContact us via the following methods.'**
  String get feedback_info;

  /// No description provided for @feedback_email.
  ///
  /// In en, this message translates to:
  /// **'Send Email'**
  String get feedback_email;

  /// No description provided for @feedback_github.
  ///
  /// In en, this message translates to:
  /// **'GitHub Issues'**
  String get feedback_github;

  /// No description provided for @feedback_github_desc.
  ///
  /// In en, this message translates to:
  /// **'Report bugs or suggestions'**
  String get feedback_github_desc;

  /// No description provided for @feedback_logs_section.
  ///
  /// In en, this message translates to:
  /// **'System Diagnostics'**
  String get feedback_logs_section;

  /// No description provided for @feedback_logs_copy.
  ///
  /// In en, this message translates to:
  /// **'Copy Logs'**
  String get feedback_logs_copy;

  /// No description provided for @feedback_logs_exporting.
  ///
  /// In en, this message translates to:
  /// **'Exporting...'**
  String get feedback_logs_exporting;

  /// No description provided for @feedback_logs_hint.
  ///
  /// In en, this message translates to:
  /// **'Copy device info and sanitized logs to clipboard for sharing.'**
  String get feedback_logs_hint;

  /// No description provided for @feedback_error_email.
  ///
  /// In en, this message translates to:
  /// **'Could not open email client'**
  String get feedback_error_email;

  /// No description provided for @feedback_error_browser.
  ///
  /// In en, this message translates to:
  /// **'Could not open browser'**
  String get feedback_error_browser;

  /// No description provided for @feedback_copied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get feedback_copied;

  /// No description provided for @detail_hospital_label.
  ///
  /// In en, this message translates to:
  /// **'Hospital'**
  String get detail_hospital_label;

  /// No description provided for @detail_date_label.
  ///
  /// In en, this message translates to:
  /// **'Visit Date'**
  String get detail_date_label;

  /// No description provided for @detail_tags_label.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get detail_tags_label;

  /// No description provided for @detail_image_delete_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get detail_image_delete_title;

  /// No description provided for @detail_image_delete_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this image? This action cannot be undone.'**
  String get detail_image_delete_confirm;

  /// No description provided for @detail_ocr_queued.
  ///
  /// In en, this message translates to:
  /// **'Re-added to queue, please wait...'**
  String get detail_ocr_queued;

  /// No description provided for @detail_ocr_failed.
  ///
  /// In en, this message translates to:
  /// **'OCR failed: {error}'**
  String detail_ocr_failed(Object error);

  /// No description provided for @detail_ocr_text.
  ///
  /// In en, this message translates to:
  /// **'OCR Text'**
  String get detail_ocr_text;

  /// No description provided for @detail_ocr_title.
  ///
  /// In en, this message translates to:
  /// **'OCR Text'**
  String get detail_ocr_title;

  /// No description provided for @detail_ocr_result.
  ///
  /// In en, this message translates to:
  /// **'OCR Result'**
  String get detail_ocr_result;

  /// No description provided for @detail_title.
  ///
  /// In en, this message translates to:
  /// **'Record Detail'**
  String get detail_title;

  /// No description provided for @detail_edit_title.
  ///
  /// In en, this message translates to:
  /// **'Edit Record'**
  String get detail_edit_title;

  /// No description provided for @detail_save.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get detail_save;

  /// No description provided for @detail_edit_page.
  ///
  /// In en, this message translates to:
  /// **'Edit Page'**
  String get detail_edit_page;

  /// No description provided for @detail_retrigger_ocr.
  ///
  /// In en, this message translates to:
  /// **'Retrigger OCR'**
  String get detail_retrigger_ocr;

  /// No description provided for @detail_delete_page.
  ///
  /// In en, this message translates to:
  /// **'Delete Page'**
  String get detail_delete_page;

  /// No description provided for @detail_cancel_edit.
  ///
  /// In en, this message translates to:
  /// **'Cancel Edit'**
  String get detail_cancel_edit;

  /// No description provided for @detail_view_raw.
  ///
  /// In en, this message translates to:
  /// **'Raw Text'**
  String get detail_view_raw;

  /// No description provided for @detail_view_enhanced.
  ///
  /// In en, this message translates to:
  /// **'Smart Enhanced'**
  String get detail_view_enhanced;

  /// No description provided for @detail_ocr_collapse.
  ///
  /// In en, this message translates to:
  /// **'Collapse'**
  String get detail_ocr_collapse;

  /// No description provided for @detail_ocr_expand.
  ///
  /// In en, this message translates to:
  /// **'Expand'**
  String get detail_ocr_expand;

  /// No description provided for @detail_record_not_found.
  ///
  /// In en, this message translates to:
  /// **'Record not found'**
  String get detail_record_not_found;

  /// No description provided for @detail_manage_tags.
  ///
  /// In en, this message translates to:
  /// **'Manage Tags'**
  String get detail_manage_tags;

  /// No description provided for @detail_no_tags.
  ///
  /// In en, this message translates to:
  /// **'No Tags'**
  String get detail_no_tags;

  /// No description provided for @detail_save_error.
  ///
  /// In en, this message translates to:
  /// **'Save failed: {error}'**
  String detail_save_error(String error);

  /// No description provided for @home_empty_records.
  ///
  /// In en, this message translates to:
  /// **'No records yet'**
  String get home_empty_records;

  /// No description provided for @timeline_pending_review.
  ///
  /// In en, this message translates to:
  /// **'{count} items pending verification'**
  String timeline_pending_review(int count);

  /// No description provided for @timeline_pending_hint.
  ///
  /// In en, this message translates to:
  /// **'Tap to verify and archive'**
  String get timeline_pending_hint;

  /// No description provided for @disclaimer_title.
  ///
  /// In en, this message translates to:
  /// **'Medical Disclaimer'**
  String get disclaimer_title;

  /// No description provided for @disclaimer_welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to PaperHealth.'**
  String get disclaimer_welcome;

  /// No description provided for @disclaimer_intro.
  ///
  /// In en, this message translates to:
  /// **'Before you start using this application, please read the following disclaimer carefully:'**
  String get disclaimer_intro;

  /// No description provided for @disclaimer_point_1_title.
  ///
  /// In en, this message translates to:
  /// **'1. Not Medical Advice'**
  String get disclaimer_point_1_title;

  /// No description provided for @disclaimer_point_1_desc.
  ///
  /// In en, this message translates to:
  /// **'PaperHealth (hereinafter referred to as \"this application\") serves only as a personal medical record organization and digitization tool. It does not provide any form of medical diagnosis, advice, or treatment. No content within the app should be considered professional medical advice.'**
  String get disclaimer_point_1_desc;

  /// No description provided for @disclaimer_point_2_title.
  ///
  /// In en, this message translates to:
  /// **'2. OCR Accuracy'**
  String get disclaimer_point_2_title;

  /// No description provided for @disclaimer_point_2_desc.
  ///
  /// In en, this message translates to:
  /// **'Information extracted via OCR (Optical Character Recognition) technology may contain errors. Users must verify this information against original paper reports or digital originals. The developer does not guarantee 100% accuracy of the recognition results.'**
  String get disclaimer_point_2_desc;

  /// No description provided for @disclaimer_point_3_title.
  ///
  /// In en, this message translates to:
  /// **'3. Professional Consultation'**
  String get disclaimer_point_3_title;

  /// No description provided for @disclaimer_point_3_desc.
  ///
  /// In en, this message translates to:
  /// **'Any medical decision should be made in consultation with professional medical institutions or doctors. This application and its developers assume no legal responsibility for any direct or indirect consequences resulting from reliance on the information provided by this application.'**
  String get disclaimer_point_3_desc;

  /// No description provided for @disclaimer_point_4_title.
  ///
  /// In en, this message translates to:
  /// **'4. Local Data Storage'**
  String get disclaimer_point_4_title;

  /// No description provided for @disclaimer_point_4_desc.
  ///
  /// In en, this message translates to:
  /// **'This application promises that all data is stored only locally with encryption and is not uploaded to any cloud server. Users are solely responsible for the physical security of their devices, PIN privacy, and data backups.'**
  String get disclaimer_point_4_desc;

  /// No description provided for @disclaimer_point_5_title.
  ///
  /// In en, this message translates to:
  /// **'5. Emergency Situations'**
  String get disclaimer_point_5_title;

  /// No description provided for @disclaimer_point_5_desc.
  ///
  /// In en, this message translates to:
  /// **'If you are in a medical emergency, please call your local emergency services or go to the nearest hospital immediately. Do not rely on this application for emergency judgment.'**
  String get disclaimer_point_5_desc;

  /// No description provided for @disclaimer_footer.
  ///
  /// In en, this message translates to:
  /// **'By clicking \"Accept\", you acknowledge that you have read and accepted all the terms above.'**
  String get disclaimer_footer;

  /// No description provided for @disclaimer_checkbox.
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to the medical disclaimer above'**
  String get disclaimer_checkbox;

  /// No description provided for @disclaimer_accept_button.
  ///
  /// In en, this message translates to:
  /// **'Accept & Continue'**
  String get disclaimer_accept_button;

  /// No description provided for @seed_person_me.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get seed_person_me;

  /// No description provided for @seed_tag_lab.
  ///
  /// In en, this message translates to:
  /// **'Lab Result'**
  String get seed_tag_lab;

  /// No description provided for @seed_tag_exam.
  ///
  /// In en, this message translates to:
  /// **'Examination'**
  String get seed_tag_exam;

  /// No description provided for @seed_tag_record.
  ///
  /// In en, this message translates to:
  /// **'Medical Record'**
  String get seed_tag_record;

  /// No description provided for @seed_tag_prescription.
  ///
  /// In en, this message translates to:
  /// **'Prescription'**
  String get seed_tag_prescription;

  /// No description provided for @filter_title.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filter_title;

  /// No description provided for @filter_date_range.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get filter_date_range;

  /// No description provided for @filter_select_date_range.
  ///
  /// In en, this message translates to:
  /// **'Select Date Range'**
  String get filter_select_date_range;

  /// No description provided for @filter_date_to.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get filter_date_to;

  /// No description provided for @filter_tags_multi.
  ///
  /// In en, this message translates to:
  /// **'Tags (Multi-select)'**
  String get filter_tags_multi;

  /// No description provided for @search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search OCR, hospital, or notes...'**
  String get search_hint;

  /// No description provided for @search_result_count.
  ///
  /// In en, this message translates to:
  /// **'Found {count} results'**
  String search_result_count(int count);

  /// No description provided for @search_initial_title.
  ///
  /// In en, this message translates to:
  /// **'Start Searching'**
  String get search_initial_title;

  /// No description provided for @search_initial_desc.
  ///
  /// In en, this message translates to:
  /// **'Enter hospital, medication, or tag keywords'**
  String get search_initial_desc;

  /// No description provided for @search_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get search_empty_title;

  /// No description provided for @search_empty_desc.
  ///
  /// In en, this message translates to:
  /// **'Try different keywords or check spelling'**
  String get search_empty_desc;

  /// No description provided for @search_searching_person.
  ///
  /// In en, this message translates to:
  /// **'Searching: {name}'**
  String search_searching_person(String name);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'en',
    'es',
    'hi',
    'id',
    'pt',
    'th',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'pt':
      return AppLocalizationsPt();
    case 'th':
      return AppLocalizationsTh();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
