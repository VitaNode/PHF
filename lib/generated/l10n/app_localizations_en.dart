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
  String get lock_screen_title => 'Please enter PIN to unlock';

  @override
  String get lock_screen_error => 'Incorrect PIN, please try again';

  @override
  String get lock_screen_biometric_tooltip => 'Unlock with biometrics';
}
