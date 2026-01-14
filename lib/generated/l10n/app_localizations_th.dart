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
  String get common_retry => 'ลองใหม่';

  @override
  String get common_refresh => 'รีเฟรช';

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
  String get common_loading => 'กำลังโหลด...';

  @override
  String common_load_failed(String error) {
    return 'โหลดไม่สำเร็จ: $error';
  }

  @override
  String get lock_screen_title => 'กรุณาใส่ PIN เพื่อปลดล็อก';

  @override
  String get lock_screen_error => 'PIN ไม่ถูกต้อง กรุณาลองใหม่';

  @override
  String get lock_screen_biometric_tooltip => 'ปลดล็อกด้วยไบโอเมตริกซ์';

  @override
  String get ingestion_title => 'ตัวอย่างและการประมวลผล';

  @override
  String get ingestion_empty_hint => 'กรุณาเพิ่มรูปภาพบันทึกทางการแพทย์';

  @override
  String get ingestion_add_now => 'เพิ่มตอนนี้';

  @override
  String get ingestion_ocr_hint =>
      'ข้อมูลเมตาจะถูกจดจำโดย OCR พื้นหลังหลังจากบันทึก';

  @override
  String get ingestion_submit_button => 'เริ่มการประมวลผลและจัดเก็บ';

  @override
  String get ingestion_grouped_report => 'ทำเครื่องหมายเป็นรายงานหลายหน้า';

  @override
  String get ingestion_grouped_report_hint =>
      'SLM จะถือว่ารูปภาพเหล่านี้เป็นเอกสารต่อเนื่องชุดเดียวกัน';

  @override
  String get ingestion_take_photo => 'ถ่ายรูป';

  @override
  String get ingestion_pick_gallery => 'เลือกจากแกลเลอรี';

  @override
  String get ingestion_processing_queue => 'เพิ่มในคิว OCR พื้นหลังแล้ว...';

  @override
  String ingestion_save_error(String error) {
    return 'การบันทึกถูกขัดขวาง: $error';
  }

  @override
  String get review_edit_title => 'ตรวจสอบข้อมูล';

  @override
  String get review_edit_confirm => 'ยืนยันและจัดเก็บ';

  @override
  String get review_edit_basic_info => 'ข้อมูลพื้นฐาน (แตะเพื่อแก้ไข)';

  @override
  String get review_edit_hospital_label => 'โรงพยาบาล/สถาบัน';

  @override
  String get review_edit_date_label => 'วันที่รับบริการ';

  @override
  String get review_edit_confidence => 'ความมั่นใจของ OCR';

  @override
  String review_edit_page_indicator(int current, int total) {
    return 'รูปภาพ $current / $total (กรุณาตรวจสอบทุกหน้า)';
  }

  @override
  String get review_list_title => 'รายการที่รอการตรวจสอบ';

  @override
  String get review_list_empty => 'ไม่มีรายการที่รอการตรวจสอบ';

  @override
  String get review_edit_ocr_section => 'ผลการจดจำ (แตะเพื่อแก้ไข)';

  @override
  String get review_edit_ocr_hint =>
      'แตะข้อความเพื่อโฟกัสพื้นที่รูปภาพที่เกี่ยวข้อง';

  @override
  String review_approve_failed(String error) {
    return 'การจัดเก็บล้มเหลว: $error';
  }

  @override
  String get settings_title => 'การตั้งค่า';

  @override
  String get settings_section_profiles => 'โปรไฟล์และหมวดหมู่';

  @override
  String get settings_manage_profiles => 'จัดการโปรไฟล์';

  @override
  String get settings_manage_profiles_desc => 'เพิ่มหรือแก้ไขโปรไฟล์บุคคล';

  @override
  String get settings_tag_library => 'คลังแท็ก';

  @override
  String get settings_tag_library_desc => 'จัดการแท็กบันทึกทางการแพทย์';

  @override
  String get settings_language => 'ภาษา';

  @override
  String get settings_language_desc => 'เปลี่ยนภาษาที่แสดงในแอป';

  @override
  String get settings_section_security => 'ความปลอดภัยของข้อมูล';

  @override
  String get settings_privacy_security => 'ความเป็นส่วนตัวและความปลอดภัย';

  @override
  String get settings_privacy_security_desc => 'แก้ไข PIN และไบโอเมตริกซ์';

  @override
  String get settings_backup_restore => 'สำรองและกู้คืนข้อมูล';

  @override
  String get settings_backup_restore_desc => 'ส่งออกไฟล์สำรองข้อมูลที่เข้ารหัส';

  @override
  String get settings_section_support => 'ความช่วยเหลือและสนับสนุน';

  @override
  String get settings_feedback => 'คำติชม';

  @override
  String get settings_feedback_desc => 'รายงานปัญหาหรือข้อเสนอแนะ';

  @override
  String get settings_section_about => 'เกี่ยวกับ';

  @override
  String get settings_privacy_policy => 'นโยบายความเป็นส่วนตัว';

  @override
  String get settings_privacy_policy_desc => 'ดูนโยบายความเป็นส่วนตัวของแอป';

  @override
  String get settings_version => 'เวอร์ชัน';

  @override
  String get settings_security_app_lock => 'ล็อกแอป';

  @override
  String get settings_security_change_pin => 'เปลี่ยน PIN';

  @override
  String get settings_security_change_pin_desc =>
      'เปลี่ยนรหัส 6 หลักที่ใช้ปลดล็อก';

  @override
  String get settings_security_lock_timeout => 'เวลาล็อกอัตโนมัติ';

  @override
  String get settings_security_timeout_immediate => 'ทันที';

  @override
  String get settings_security_timeout_1min => 'หลังจาก 1 นาที';

  @override
  String get settings_security_timeout_5min => 'หลังจาก 5 นาที';

  @override
  String settings_security_timeout_custom(int minutes) {
    return 'หลังจาก $minutes นาที';
  }

  @override
  String get settings_security_biometrics => 'ปลดล็อกด้วยไบโอเมตริกซ์';

  @override
  String get settings_security_biometrics_desc =>
      'เปิดใช้งานลายนิ้วมือหรือการจดจำใบหน้า';

  @override
  String get settings_security_biometrics_enabled_failed =>
      'Failed to enable biometrics';

  @override
  String get settings_security_biometrics_disabled_failed =>
      'Failed to disable biometrics';

  @override
  String get settings_security_info_card =>
      'PaperHealth ใช้การเข้ารหัสภายในเครื่อง PIN และข้อมูลไบโอเมตริกซ์ของคุณจะถูกเก็บไว้ในส่วนที่ปลอดภัยของอุปกรณ์เท่านั้น ไม่มีบุคคลภายนอก (รวมถึงผู้พัฒนา) สามารถเข้าถึงได้';

  @override
  String get settings_security_pin_current => 'ใส่ PIN ปัจจุบัน';

  @override
  String get settings_security_pin_new => 'ใส่ PIN ใหม่';

  @override
  String get settings_security_pin_confirm => 'ยืนยัน PIN ใหม่';

  @override
  String get settings_security_pin_mismatch => 'PIN ไม่ตรงกัน';

  @override
  String get settings_security_pin_success => 'เปลี่ยน PIN สำเร็จ';

  @override
  String get settings_security_pin_error => 'PIN ปัจจุบันไม่ถูกต้อง';

  @override
  String get person_management_empty => 'ไม่พบโปรไฟล์';

  @override
  String get person_management_default => 'โปรไฟล์เริ่มต้น';

  @override
  String get person_delete_title => 'ลบโปรไฟล์';

  @override
  String person_delete_confirm(String name) {
    return 'คุณแน่ใจหรือไม่ว่าต้องการลบ $name? การลบจะถูกปฏิเสธหากมีบันทึกภายใต้โปรไฟล์นี้';
  }

  @override
  String get person_edit_title => 'แก้ไขโปรไฟล์';

  @override
  String get person_add_title => 'โปรไฟล์ใหม่';

  @override
  String get person_field_nickname => 'ชื่อเล่น';

  @override
  String get person_field_nickname_hint => 'ใส่ชื่อหรือคำเรียก';

  @override
  String get person_field_color => 'เลือกสีโปรไฟล์';

  @override
  String get tag_management_empty => 'ไม่พบแท็ก';

  @override
  String get tag_management_custom => 'แท็กที่กำหนดเอง';

  @override
  String get tag_management_system => 'แท็กระบบ';

  @override
  String get tag_add_title => 'New Tag';

  @override
  String get tag_edit_title => 'Edit Tag';

  @override
  String get tag_delete_title => 'ลบแท็ก';

  @override
  String tag_delete_confirm(String name) {
    return 'คุณแน่ใจหรือไม่ว่าต้องการลบแท็ก $name? การดำเนินการนี้จะลบแท็กออกจากรูปภาพที่เกี่ยวข้องทั้งหมด';
  }

  @override
  String get tag_field_name => 'ชื่อแท็ก';

  @override
  String get tag_field_name_hint => 'เช่น ผลแล็บ, เอ็กซเรย์';

  @override
  String get tag_reorder_title => 'Reorder Tags';

  @override
  String tag_create_new(String query) {
    return 'สร้างแท็กใหม่: $query';
  }

  @override
  String get feedback_info =>
      'เรามุ่งมั่นที่จะปกป้องความเป็นส่วนตัวของคุณ แอปทำงานแบบออฟไลน์ 100% ติดต่อเราผ่านช่องทางต่อไปนี้';

  @override
  String get feedback_email => 'ส่งอีเมล';

  @override
  String get feedback_github => 'GitHub Issues';

  @override
  String get feedback_github_desc => 'รายงานข้อบกพร่องหรือข้อเสนอแนะ';

  @override
  String get feedback_logs_section => 'การวินิจฉัยระบบ';

  @override
  String get feedback_logs_copy => 'คัดลอกบันทึก';

  @override
  String get feedback_logs_exporting => 'กำลังส่งออก...';

  @override
  String get feedback_logs_hint =>
      'คัดลอกข้อมูลอุปกรณ์และบันทึกที่ลบข้อมูลส่วนตัวแล้วไปยังคลิปบอร์ดเพื่อแชร์';

  @override
  String get feedback_error_email => 'ไม่สามารถเปิดแอปอีเมลได้';

  @override
  String get feedback_error_browser => 'ไม่สามารถเปิดเบราว์เซอร์ได้';

  @override
  String get feedback_copied => 'คัดลอกไปยังคลิปบอร์ดแล้ว';

  @override
  String get detail_hospital_label => 'โรงพยาบาล';

  @override
  String get detail_date_label => 'วันที่รับบริการ';

  @override
  String get detail_tags_label => 'แท็ก';

  @override
  String get detail_image_delete_title => 'ยืนยันการลบ';

  @override
  String get detail_image_delete_confirm =>
      'คุณแน่ใจหรือไม่ว่าต้องการลบรูปภาพนี้? การดำเนินการนี้ไม่สามารถย้อนกลับได้';

  @override
  String get detail_ocr_queued => 'เพิ่มกลับเข้าคิวแล้ว กรุณารอสักครู่...';

  @override
  String detail_ocr_failed(Object error) {
    return 'OCR ล้มเหลว: $error';
  }

  @override
  String get detail_ocr_text => 'OCR Text';

  @override
  String get detail_ocr_title => 'ข้อความจาก OCR';

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
  String get detail_view_raw => 'ข้อความต้นฉบับ';

  @override
  String get detail_view_enhanced => 'เพิ่มประสิทธิภาพอัจฉริยะ';

  @override
  String get detail_ocr_collapse => 'ย่อ';

  @override
  String get detail_ocr_expand => 'ดูทั้งหมด';

  @override
  String get detail_record_not_found => 'ไม่พบข้อมูลบันทึก';

  @override
  String get detail_manage_tags => 'Manage Tags';

  @override
  String get detail_no_tags => 'No Tags';

  @override
  String detail_save_error(String error) {
    return 'Save failed: $error';
  }

  @override
  String get home_empty_records => 'ยังไม่มีบันทึก';

  @override
  String timeline_pending_review(int count) {
    return 'มี $count รายการรอการตรวจสอบ';
  }

  @override
  String get timeline_pending_hint => 'แตะเพื่อตรวจสอบและจัดเก็บ';

  @override
  String get disclaimer_title => 'ข้อสงวนสิทธิ์ทางการแพทย์';

  @override
  String get disclaimer_welcome => 'ยินดีต้อนรับสู่ PaperHealth';

  @override
  String get disclaimer_intro =>
      'ก่อนที่คุณจะเริ่มใช้แอปพลิเคชันนี้ โปรดอ่านข้อสงวนสิทธิ์ต่อไปนี้อย่างละเอียด:';

  @override
  String get disclaimer_point_1_title => '1. ไม่ใช่คำแนะนำทางการแพทย์';

  @override
  String get disclaimer_point_1_desc =>
      'PaperHealth (ต่อไปนี้จะเรียกว่า \"แอปพลิเคชันนี้\") ทำหน้าที่เป็นเพียงเครื่องมือส่วนบุคคลในการจัดเก็บและแปลงบันทึกทางการแพทย์ให้เป็นดิจิทัลเท่านั้น ไม่มีการวินิจฉัย ให้คำแนะนำ หรือการรักษาทางการแพทย์ในรูปแบบใดๆ เนื้อหาภายในแอปไม่ถือเป็นคำแนะนำทางการแพทย์จากผู้เชี่ยวชาญ';

  @override
  String get disclaimer_point_2_title => '2. ความแม่นยำของ OCR';

  @override
  String get disclaimer_point_2_desc =>
      'ข้อมูลที่ดึงผ่านเทคโนโลยี OCR (Optical Character Recognition) อาจมีข้อผิดพลาด ผู้ใช้ต้องตรวจสอบข้อมูลนี้กับรายงานฉบับกระดาษต้นฉบับหรือไฟล์ดิจิทัลต้นฉบับ ผู้พัฒนาไม่รับประกันความถูกต้อง 100% ของผลลัพธ์';

  @override
  String get disclaimer_point_3_title => '3. การปรึกษาผู้เชี่ยวชาญ';

  @override
  String get disclaimer_point_3_desc =>
      'การตัดสินใจทางการแพทย์ใดๆ ควรทำหลังจากปรึกษาสถาบันการแพทย์หรือแพทย์ผู้เชี่ยวชาญ แอปพลิเคชันนี้และผู้พัฒนาจะไม่รับผิดชอบทางกฎหมายต่อผลที่ตามมาไม่ว่าโดยตรงหรือโดยอ้อมจากการอ้างอิงข้อมูลที่ได้รับจากแอปพลิเคชันนี้';

  @override
  String get disclaimer_point_4_title => '4. การจัดเก็บข้อมูลภายในเครื่อง';

  @override
  String get disclaimer_point_4_desc =>
      'แอปพลิเคชันนี้สัญญาว่าข้อมูลทั้งหมดจะถูกจัดเก็บไว้ภายในเครื่องพร้อมการเข้ารหัสเท่านั้น และจะไม่ถูกอัปโหลดไปยังเซิร์ฟเวอร์คลาวด์ใดๆ ผู้ใช้มีหน้าที่รับผิดชอบต่อความปลอดภัยทางกายภาพของอุปกรณ์ ความเป็นส่วนตัวของ PIN และการสำรองข้อมูลเอง';

  @override
  String get disclaimer_point_5_title => '5. สถานการณ์ฉุกเฉิน';

  @override
  String get disclaimer_point_5_desc =>
      'หากคุณอยู่ในสถานการณ์ฉุกเฉินทางการแพทย์ โปรดติดต่อบริการฉุกเฉินในพื้นที่หรือไปโรงพยาบาลที่ใกล้ที่สุดทันที อย่าพึ่งพาแอปพลิเคชันนี้ในการตัดสินใจในกรณีฉุกเฉิน';

  @override
  String get disclaimer_footer =>
      'โดยการคลิก \"ยอมรับ\" แสดงว่าคุณรับทราบว่าได้อ่านและยอมรับข้อกำหนดทั้งหมดข้างต้นแล้ว';

  @override
  String get disclaimer_checkbox =>
      'ฉันได้อ่านและยอมรับข้อสงวนสิทธิ์ทางการแพทย์ข้างต้นแล้ว';

  @override
  String get disclaimer_accept_button => 'ยอมรับและดำเนินการต่อ';

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
  String get search_hint => 'ค้นหา OCR, โรงพยาบาล หรือบันทึก...';

  @override
  String search_result_count(int count) {
    return 'พบ $count รายการ';
  }

  @override
  String get search_initial_title => 'เริ่มการค้นหา';

  @override
  String get search_initial_desc => 'ใส่ชื่อโรงพยาบาล, ยา หรือแท็ก';

  @override
  String get search_empty_title => 'ไม่พบผลลัพธ์';

  @override
  String get search_empty_desc => 'ลองใช้คำค้นหาอื่นหรือตรวจสอบการสะกด';

  @override
  String search_searching_person(String name) {
    return 'กำลังค้นหาให้: $name';
  }
}
