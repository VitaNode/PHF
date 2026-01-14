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
  String get common_retry => 'पुनः प्रयास करें';

  @override
  String get common_refresh => 'रीफ्रेश करें';

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
  String get common_loading => 'लोड हो रहा है...';

  @override
  String common_load_failed(String error) {
    return 'लोड करने में विफल: $error';
  }

  @override
  String get lock_screen_title => 'अनलॉक करने के लिए पिन दर्ज करें';

  @override
  String get lock_screen_error => 'गलत पिन, कृपया पुनः प्रयास करें';

  @override
  String get lock_screen_biometric_tooltip => 'बायोमेट्रिक्स के साथ अनलॉक करें';

  @override
  String get ingestion_title => 'पूर्वावलोकन और प्रसंस्करण';

  @override
  String get ingestion_empty_hint => 'कृपया मेडिकल रिकॉर्ड की तस्वीरें जोड़ें';

  @override
  String get ingestion_add_now => 'अभी जोड़ें';

  @override
  String get ingestion_ocr_hint =>
      'सहेजने के बाद बैकग्राउंड OCR द्वारा मेटाडेटा की पहचान की जाएगी';

  @override
  String get ingestion_submit_button => 'प्रसंस्करण और संग्रह शुरू करें';

  @override
  String get ingestion_grouped_report =>
      'बहु-पृष्ठ रिपोर्ट के रूप में चिह्नित करें';

  @override
  String get ingestion_grouped_report_hint =>
      'SLM इन छवियों को एक एकल निरंतर दस्तावेज़ के रूप में मानेगा';

  @override
  String get ingestion_take_photo => 'तस्वीर लें';

  @override
  String get ingestion_pick_gallery => 'गैलरी से चुनें';

  @override
  String get ingestion_processing_queue =>
      'बैकग्राउंड OCR कतार में जोड़ा गया...';

  @override
  String ingestion_save_error(String error) {
    return 'सहेजने में बाधा आई: $error';
  }

  @override
  String get review_edit_title => 'जानकारी सत्यापित करें';

  @override
  String get review_edit_confirm => 'पुष्टि करें और संग्रहित करें';

  @override
  String get review_edit_basic_info =>
      'मूल जानकारी (संपादित करने के लिए टैप करें)';

  @override
  String get review_edit_hospital_label => 'अस्पताल/संस्थान';

  @override
  String get review_edit_date_label => 'मुलाकात की तिथि';

  @override
  String get review_edit_confidence => 'OCR विश्वास';

  @override
  String review_edit_page_indicator(int current, int total) {
    return 'छवि $current / $total (कृपया प्रत्येक पृष्ठ सत्यापित करें)';
  }

  @override
  String get review_list_title => 'लंबित रिकॉर्ड';

  @override
  String get review_list_empty => 'समीक्षा के लिए कोई रिकॉर्ड लंबित नहीं है';

  @override
  String get review_edit_ocr_section =>
      'पहचान के परिणाम (संपादित करने के लिए टैप करें)';

  @override
  String get review_edit_ocr_hint =>
      'संबंधित छवि क्षेत्र पर ध्यान केंद्रित करने के लिए टेक्स्ट टैप करें';

  @override
  String review_approve_failed(String error) {
    return 'संग्रहित करने में विफल: $error';
  }

  @override
  String get settings_title => 'सेटिंग्स';

  @override
  String get settings_section_profiles => 'प्रोफाइल और श्रेणियां';

  @override
  String get settings_manage_profiles => 'प्रोफाइल प्रबंधित करें';

  @override
  String get settings_manage_profiles_desc =>
      'कार्मिक प्रोफाइल जोड़ें या संपादित करें';

  @override
  String get settings_tag_library => 'टैग लाइब्रेरी';

  @override
  String get settings_tag_library_desc => 'मेडिकल रिकॉर्ड टैग बनाए रखें';

  @override
  String get settings_language => 'भाषा';

  @override
  String get settings_language_desc => 'एप्लिकेशन प्रदर्शन भाषा बदलें';

  @override
  String get settings_section_security => 'डेटा सुरक्षा';

  @override
  String get settings_privacy_security => 'गोपनीयता और सुरक्षा';

  @override
  String get settings_privacy_security_desc =>
      'पिन और बायोमेट्रिक्स संशोधित करें';

  @override
  String get settings_backup_restore => 'बैकअप और पुनर्स्थापना';

  @override
  String get settings_backup_restore_desc =>
      'एन्क्रिप्टेड बैकअप फाइलें निर्यात करें';

  @override
  String get settings_section_support => 'सहायता और समर्थन';

  @override
  String get settings_feedback => 'प्रतिक्रिया';

  @override
  String get settings_feedback_desc => 'मुद्दों या सुझावों की रिपोर्ट करें';

  @override
  String get settings_section_about => 'के बारे में';

  @override
  String get settings_privacy_policy => 'गोपनीयता नीति';

  @override
  String get settings_privacy_policy_desc => 'एप्लिकेशन गोपनीयता नीति देखें';

  @override
  String get settings_version => 'संस्करण';

  @override
  String get settings_security_app_lock => 'ऐप लॉक';

  @override
  String get settings_security_change_pin => 'पिन बदलें';

  @override
  String get settings_security_change_pin_desc =>
      'अनलॉक करने के लिए उपयोग किए जाने वाले 6-अंकीय कोड को बदलें';

  @override
  String get settings_security_lock_timeout => 'ऑटो-लॉक टाइमआउट';

  @override
  String get settings_security_timeout_immediate => 'तुरंत';

  @override
  String get settings_security_timeout_1min => '1 मिनट बाद';

  @override
  String get settings_security_timeout_5min => '5 मिनट बाद';

  @override
  String settings_security_timeout_custom(int minutes) {
    return '$minutes मिनट बाद';
  }

  @override
  String get settings_security_biometrics => 'बायोमेट्रिक अनलॉक';

  @override
  String get settings_security_biometrics_desc =>
      'फिंगरप्रिंट या चेहरा पहचान सक्षम करें';

  @override
  String get settings_security_biometrics_enabled_failed =>
      'Failed to enable biometrics';

  @override
  String get settings_security_biometrics_disabled_failed =>
      'Failed to disable biometrics';

  @override
  String get settings_security_info_card =>
      'PaperHealth स्थानीय एन्क्रिप्शन का उपयोग करता है। आपका पिन और बायोमेट्रिक डेटा केवल आपके डिवाइस के सुरक्षित एन्क्लेव में संग्रहीत किया जाता है। कोई भी तीसरा पक्ष (डेवलपर्स सहित) उन्हें एक्सेस नहीं कर सकता है।';

  @override
  String get settings_security_pin_current => 'वर्तमान पिन दर्ज करें';

  @override
  String get settings_security_pin_new => 'नया पिन दर्ज करें';

  @override
  String get settings_security_pin_confirm => 'नए पिन की पुष्टि करें';

  @override
  String get settings_security_pin_mismatch => 'पिन मेल नहीं खाते';

  @override
  String get settings_security_pin_success => 'पिन सफलतापूर्वक बदला गया';

  @override
  String get settings_security_pin_error => 'गलत वर्तमान पिन';

  @override
  String get person_management_empty => 'कोई प्रोफाइल नहीं मिली';

  @override
  String get person_management_default => 'डिफ़ॉल्ट प्रोफाइल';

  @override
  String get person_delete_title => 'प्रोफाइल हटाएं';

  @override
  String person_delete_confirm(String name) {
    return 'क्या आप वाकई $name को हटाना चाहते हैं? यदि इस प्रोफाइल के तहत रिकॉर्ड हैं तो हटाना अस्वीकार कर दिया जाएगा।';
  }

  @override
  String get person_edit_title => 'प्रोफाइल संपादित करें';

  @override
  String get person_add_title => 'नई प्रोफाइल';

  @override
  String get person_field_nickname => 'उपनाम';

  @override
  String get person_field_nickname_hint => 'नाम या शीर्षक दर्ज करें';

  @override
  String get person_field_color => 'प्रोफाइल रंग चुनें';

  @override
  String get tag_management_empty => 'कोई टैग नहीं मिला';

  @override
  String get tag_management_custom => 'कस्टम टैग';

  @override
  String get tag_management_system => 'सिस्टम टैग';

  @override
  String get tag_add_title => 'New Tag';

  @override
  String get tag_edit_title => 'Edit Tag';

  @override
  String get tag_delete_title => 'टैग हटाएं';

  @override
  String tag_delete_confirm(String name) {
    return 'क्या आप वाकई $name टैग को हटाना चाहते हैं? यह इसे सभी संबंधित छवियों से हटा देगा।';
  }

  @override
  String get tag_field_name => 'टैग का नाम';

  @override
  String get tag_field_name_hint => 'उदा. लैब परिणाम, एक्स-रे';

  @override
  String get tag_reorder_title => 'Reorder Tags';

  @override
  String tag_create_new(String query) {
    return 'नया टैग बनाएं: $query';
  }

  @override
  String get feedback_info =>
      'हम आपकी गोपनीयता की रक्षा के लिए प्रतिबद्ध हैं। ऐप 100% ऑफलाइन चलता है।\nनिम्नलिखित तरीकों से हमसे संपर्क करें।';

  @override
  String get feedback_email => 'ईमेल भेजें';

  @override
  String get feedback_github => 'GitHub Issues';

  @override
  String get feedback_github_desc => 'बग या सुझावों की रिपोर्ट करें';

  @override
  String get feedback_logs_section => 'सिस्टम निदान';

  @override
  String get feedback_logs_copy => 'लॉग्स कॉपी करें';

  @override
  String get feedback_logs_exporting => 'निर्यात हो रहा है...';

  @override
  String get feedback_logs_hint =>
      'साझा करने के लिए डिवाइस की जानकारी और लॉग्स को क्लिपबोर्ड पर कॉपी करें।';

  @override
  String get feedback_error_email => 'ईमेल क्लाइंट नहीं खोल सका';

  @override
  String get feedback_error_browser => 'ब्राउज़र नहीं खोल सका';

  @override
  String get feedback_copied => 'क्लिपबोर्ड पर कॉपी किया गया';

  @override
  String get detail_hospital_label => 'अस्पताल';

  @override
  String get detail_date_label => 'मुलाकात की तिथि';

  @override
  String get detail_tags_label => 'टैग';

  @override
  String get detail_image_delete_title => 'हटाने की पुष्टि करें';

  @override
  String get detail_image_delete_confirm =>
      'क्या आप वाकई इस छवि को हटाना चाहते हैं? इस क्रिया को पूर्ववत नहीं किया जा सकता।';

  @override
  String get detail_ocr_queued =>
      'कतार में वापस जोड़ा गया, कृपया प्रतीक्षा करें...';

  @override
  String detail_ocr_failed(Object error) {
    return 'OCR विफल: $error';
  }

  @override
  String get detail_ocr_text => 'OCR Text';

  @override
  String get detail_ocr_title => 'OCR टेक्स्ट';

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
  String get detail_view_raw => 'मूल टेक्स्ट';

  @override
  String get detail_view_enhanced => 'स्मार्ट एन्हांस्ड';

  @override
  String get detail_ocr_collapse => 'छोटा करें';

  @override
  String get detail_ocr_expand => 'पूरा देखें';

  @override
  String get detail_record_not_found => 'रिकॉर्ड नहीं मिला';

  @override
  String get detail_manage_tags => 'Manage Tags';

  @override
  String get detail_no_tags => 'No Tags';

  @override
  String detail_save_error(String error) {
    return 'Save failed: $error';
  }

  @override
  String get home_empty_records => 'अभी तक कोई रिकॉर्ड नहीं';

  @override
  String timeline_pending_review(int count) {
    return '$count आइटम सत्यापन के लिए लंबित हैं';
  }

  @override
  String get timeline_pending_hint =>
      'सत्यापित और संग्रहित करने के लिए टैप करें';

  @override
  String get disclaimer_title => 'चिकित्सा अस्वीकरण';

  @override
  String get disclaimer_welcome => 'PaperHealth में आपका स्वागत है।';

  @override
  String get disclaimer_intro =>
      'इस एप्लिकेशन का उपयोग शुरू करने से पहले, कृपया निम्नलिखित अस्वीकरण को ध्यान से पढ़ें:';

  @override
  String get disclaimer_point_1_title => '1. चिकित्सा सलाह नहीं';

  @override
  String get disclaimer_point_1_desc =>
      'PaperHealth (इसके बाद \"यह एप्लिकेशन\") केवल व्यक्तिगत चिकित्सा रिकॉर्ड संगठन और डिजिटलीकरण उपकरण के रूप में कार्य करता है। यह किसी भी प्रकार का चिकित्सा निदान, सलाह या उपचार प्रदान नहीं करता है। ऐप के भीतर किसी भी सामग्री को पेशेवर चिकित्सा सलाह नहीं माना जाना चाहिए।';

  @override
  String get disclaimer_point_2_title => '2. OCR सटीकता';

  @override
  String get disclaimer_point_2_desc =>
      'OCR (ऑप्टिकल कैरेक्टर रिकग्निशन) तकनीक के माध्यम से निकाली गई जानकारी में त्रुटियां हो सकती हैं। उपयोगकर्ताओं को मूल कागजी रिपोर्ट या डिजिटल मूल के खिलाफ इस जानकारी को सत्यापित करना चाहिए। डेवलपर पहचान परिणामों की 100% सटीकता की गारंटी नहीं देता है।';

  @override
  String get disclaimer_point_3_title => '3. पेशेवर परामर्श';

  @override
  String get disclaimer_point_3_desc =>
      'कोई भी चिकित्सा निर्णय पेशेवर चिकित्सा संस्थानों या डॉक्टरों के परामर्श से लिया जाना चाहिए। यह एप्लिकेशन और इसके डेवलपर इस एप्लिकेशन द्वारा प्रदान की गई जानकारी पर निर्भरता के परिणामस्वरूप होने वाले किसी भी प्रत्यक्ष या अप्रत्यक्ष परिणाम के लिए कोई कानूनी जिम्मेदारी नहीं लेते हैं।';

  @override
  String get disclaimer_point_4_title => '4. स्थानीय डेटा भंडारण';

  @override
  String get disclaimer_point_4_desc =>
      'यह एप्लिकेशन वादा करता है कि सभी डेटा केवल एन्क्रिप्शन के साथ स्थानीय रूप से संग्रहीत किया जाता है और किसी भी क्लाउड सर्वर पर अपलोड नहीं किया जाता है। उपयोगकर्ता अपने उपकरणों की भौतिक सुरक्षा, पिन गोपनीयता और डेटा बैकअप के लिए पूरी तरह जिम्मेदार हैं।';

  @override
  String get disclaimer_point_5_title => '5. आपातकालीन स्थितियां';

  @override
  String get disclaimer_point_5_desc =>
      'यदि आप चिकित्सा आपात स्थिति में हैं, तो कृपया तुरंत अपनी स्थानीय आपातकालीन सेवाओं को कॉल करें या निकटतम अस्पताल जाएं। आपातकालीन निर्णय के लिए इस एप्लिकेशन पर भरोसा न करें।';

  @override
  String get disclaimer_footer =>
      '\"सहमत\" पर क्लिक करके, आप स्वीकार करते हैं कि आपने उपरोक्त सभी शर्तों को पढ़ और स्वीकार कर लिया है।';

  @override
  String get disclaimer_checkbox =>
      'मैंने उपरोक्त चिकित्सा अस्वीकरण को पढ़ लिया है और उससे सहमत हूँ';

  @override
  String get disclaimer_accept_button => 'सहमत हों और जारी रखें';

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
  String get search_hint => 'OCR, अस्पताल या नोट्स खोजें...';

  @override
  String search_result_count(int count) {
    return '$count परिणाम मिले';
  }

  @override
  String get search_initial_title => 'खोजना शुरू करें';

  @override
  String get search_initial_desc => 'अस्पताल, दवा या टैग कीवर्ड दर्ज करें';

  @override
  String get search_empty_title => 'कोई परिणाम नहीं मिला';

  @override
  String get search_empty_desc => 'अलग कीवर्ड आज़माएं या वर्तनी की जाँच करें';

  @override
  String search_searching_person(String name) {
    return 'खोज रहे हैं: $name';
  }
}
