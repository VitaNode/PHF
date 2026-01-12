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
  String get common_retry => 'Thử lại';

  @override
  String get common_refresh => 'Làm mới';

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
  String get common_loading => 'Đang tải...';

  @override
  String common_load_failed(String error) {
    return 'Tải thất bại: $error';
  }

  @override
  String get lock_screen_title => 'Nhập mã PIN để mở khóa';

  @override
  String get lock_screen_error => 'Mã PIN không đúng, vui lòng thử lại';

  @override
  String get lock_screen_biometric_tooltip => 'Mở khóa bằng sinh trắc học';

  @override
  String get ingestion_title => 'Xem trước & Xử lý';

  @override
  String get ingestion_empty_hint => 'Vui lòng thêm ảnh hồ sơ bệnh án';

  @override
  String get ingestion_add_now => 'Thêm ngay';

  @override
  String get ingestion_ocr_hint =>
      'Siêu dữ liệu sẽ được OCR chạy ngầm nhận diện sau khi lưu';

  @override
  String get ingestion_submit_button => 'Bắt đầu Xử lý & Lưu trữ';

  @override
  String get ingestion_grouped_report => 'Đánh dấu là báo cáo nhiều trang';

  @override
  String get ingestion_grouped_report_hint =>
      'SLM sẽ xử lý các ảnh này như một tài liệu liên tục duy nhất';

  @override
  String get ingestion_take_photo => 'Chụp ảnh';

  @override
  String get ingestion_pick_gallery => 'Chọn từ thư viện';

  @override
  String get ingestion_processing_queue =>
      'Đã thêm vào hàng đợi OCR chạy ngầm...';

  @override
  String ingestion_save_error(String error) {
    return 'Lưu bị chặn: $error';
  }

  @override
  String get review_edit_title => 'Xác minh thông tin';

  @override
  String get review_edit_confirm => 'Xác nhận & Lưu trữ';

  @override
  String get review_edit_basic_info => 'Thông tin cơ bản (Chạm để sửa)';

  @override
  String get review_edit_hospital_label => 'Bệnh viện/Cơ sở';

  @override
  String get review_edit_date_label => 'Ngày khám';

  @override
  String get review_edit_confidence => 'Độ tin cậy OCR';

  @override
  String review_edit_page_indicator(int current, int total) {
    return 'Ảnh $current / $total (Vui lòng kiểm tra từng trang)';
  }

  @override
  String get review_list_title => 'Hồ sơ chờ duyệt';

  @override
  String get review_list_empty => 'Không có hồ sơ nào chờ kiểm tra';

  @override
  String get review_edit_ocr_section => 'Kết quả nhận diện (Chạm để sửa)';

  @override
  String get review_edit_ocr_hint =>
      'Chạm vào văn bản để tập trung vào vùng ảnh tương ứng';

  @override
  String review_approve_failed(String error) {
    return 'Lưu trữ thất bại: $error';
  }

  @override
  String get settings_title => 'Cài đặt';

  @override
  String get settings_section_profiles => 'Hồ sơ & Danh mục';

  @override
  String get settings_manage_profiles => 'Quản lý hồ sơ';

  @override
  String get settings_manage_profiles_desc =>
      'Thêm hoặc chỉnh sửa hồ sơ cá nhân';

  @override
  String get settings_tag_library => 'Thư viện nhãn';

  @override
  String get settings_tag_library_desc => 'Quản lý nhãn hồ sơ bệnh án';

  @override
  String get settings_language => 'Ngôn ngữ';

  @override
  String get settings_language_desc => 'Thay đổi ngôn ngữ hiển thị ứng dụng';

  @override
  String get settings_section_security => 'An toàn dữ liệu';

  @override
  String get settings_privacy_security => 'Quyền riêng tư & Bảo mật';

  @override
  String get settings_privacy_security_desc =>
      'Thay đổi mã PIN và sinh trắc học';

  @override
  String get settings_backup_restore => 'Sao lưu & Khôi phục';

  @override
  String get settings_backup_restore_desc => 'Xuất tệp sao lưu đã mã hóa';

  @override
  String get settings_section_support => 'Trợ giúp & Hỗ trợ';

  @override
  String get settings_feedback => 'Phản hồi';

  @override
  String get settings_feedback_desc => 'Báo cáo lỗi hoặc góp ý';

  @override
  String get settings_section_about => 'Giới thiệu';

  @override
  String get settings_privacy_policy => 'Chính sách bảo mật';

  @override
  String get settings_privacy_policy_desc =>
      'Xem chính sách bảo mật của ứng dụng';

  @override
  String get settings_version => 'Phiên bản';

  @override
  String get settings_security_app_lock => 'Khóa ứng dụng';

  @override
  String get settings_security_change_pin => 'Thay đổi mã PIN';

  @override
  String get settings_security_change_pin_desc =>
      'Thay đổi mã 6 chữ số dùng để mở khóa';

  @override
  String get settings_security_lock_timeout => 'Thời gian tự động khóa';

  @override
  String get settings_security_timeout_immediate => 'Ngay lập tức';

  @override
  String get settings_security_timeout_1min => 'Sau 1 phút';

  @override
  String get settings_security_timeout_5min => 'Sau 5 phút';

  @override
  String settings_security_timeout_custom(int minutes) {
    return 'Sau $minutes phút';
  }

  @override
  String get settings_security_biometrics => 'Mở khóa sinh trắc học';

  @override
  String get settings_security_biometrics_desc =>
      'Bật vân tay hoặc nhận diện khuôn mặt';

  @override
  String get settings_security_biometrics_enabled_failed =>
      'Failed to enable biometrics';

  @override
  String get settings_security_biometrics_disabled_failed =>
      'Failed to disable biometrics';

  @override
  String get settings_security_info_card =>
      'PaperHealth sử dụng mã hóa cục bộ. Mã PIN và dữ liệu sinh trắc học của bạn chỉ được lưu trữ trong vùng an toàn của thiết bị. Không bên thứ ba nào (kể cả nhà phát triển) có thể truy cập chúng.';

  @override
  String get settings_security_pin_current => 'Nhập mã PIN hiện tại';

  @override
  String get settings_security_pin_new => 'Nhập mã PIN mới';

  @override
  String get settings_security_pin_confirm => 'Xác nhận mã PIN mới';

  @override
  String get settings_security_pin_mismatch => 'Mã PIN không khớp';

  @override
  String get settings_security_pin_success => 'Thay đổi mã PIN thành công';

  @override
  String get settings_security_pin_error => 'Mã PIN hiện tại không đúng';

  @override
  String get person_management_empty => 'Không tìm thấy hồ sơ nào';

  @override
  String get person_management_default => 'Hồ sơ mặc định';

  @override
  String get person_delete_title => 'Xóa hồ sơ';

  @override
  String person_delete_confirm(String name) {
    return 'Bạn có chắc chắn muốn xóa $name? Yêu cầu xóa sẽ bị từ chối nếu có hồ sơ bệnh án thuộc hồ sơ này.';
  }

  @override
  String get person_edit_title => 'Sửa hồ sơ';

  @override
  String get person_add_title => 'Hồ sơ mới';

  @override
  String get person_field_nickname => 'Biệt danh';

  @override
  String get person_field_nickname_hint => 'Nhập tên hoặc danh xưng';

  @override
  String get person_field_color => 'Chọn màu hồ sơ';

  @override
  String get tag_management_empty => 'Không tìm thấy nhãn nào';

  @override
  String get tag_management_custom => 'Nhãn tùy chỉnh';

  @override
  String get tag_management_system => 'Nhãn hệ thống';

  @override
  String get tag_add_title => 'New Tag';

  @override
  String get tag_edit_title => 'Edit Tag';

  @override
  String get tag_delete_title => 'Xóa nhãn';

  @override
  String tag_delete_confirm(String name) {
    return 'Bạn có chắc chắn muốn xóa nhãn $name? Thao tác này sẽ gỡ nhãn khỏi tất cả các ảnh liên quan.';
  }

  @override
  String get tag_field_name => 'Tên nhãn';

  @override
  String get tag_field_name_hint => 'VD: Xét nghiệm, X-Quang';

  @override
  String get tag_reorder_title => 'Reorder Tags';

  @override
  String tag_create_new(String query) {
    return 'Tạo nhãn mới: $query';
  }

  @override
  String get feedback_info =>
      'Chúng tôi cam kết bảo vệ quyền riêng tư của bạn. Ứng dụng chạy 100% ngoại tuyến.\nLiên hệ với chúng tôi qua các phương thức sau.';

  @override
  String get feedback_email => 'Gửi Email';

  @override
  String get feedback_github => 'GitHub Issues';

  @override
  String get feedback_github_desc => 'Báo cáo lỗi hoặc góp ý';

  @override
  String get feedback_logs_section => 'Chẩn đoán hệ thống';

  @override
  String get feedback_logs_copy => 'Sao chép Nhật ký';

  @override
  String get feedback_logs_exporting => 'Đang xuất...';

  @override
  String get feedback_logs_hint =>
      'Sao chép thông tin thiết bị và nhật ký đã làm sạch vào bộ nhớ tạm để chia sẻ.';

  @override
  String get feedback_error_email => 'Không thể mở ứng dụng email';

  @override
  String get feedback_error_browser => 'Không thể mở trình duyệt';

  @override
  String get feedback_copied => 'Đã sao chép vào bộ nhớ tạm';

  @override
  String get detail_hospital_label => 'Bệnh viện';

  @override
  String get detail_date_label => 'Ngày khám';

  @override
  String get detail_tags_label => 'Nhãn';

  @override
  String get detail_image_delete_title => 'Xác nhận xóa';

  @override
  String get detail_image_delete_confirm =>
      'Bạn có chắc chắn muốn xóa ảnh này? Hành động này không thể hoàn tác.';

  @override
  String get detail_ocr_queued => 'Đã thêm lại vào hàng đợi, vui lòng đợi...';

  @override
  String detail_ocr_failed(Object error) {
    return 'OCR thất bại: $error';
  }

  @override
  String get detail_ocr_text => 'OCR Text';

  @override
  String get detail_ocr_title => 'Văn bản OCR';

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
  String get detail_view_raw => 'Văn bản gốc';

  @override
  String get detail_view_enhanced => 'Tăng cường thông minh';

  @override
  String get detail_ocr_collapse => 'Thu gọn';

  @override
  String get detail_ocr_expand => 'Xem tất cả';

  @override
  String get detail_record_not_found => 'Không tìm thấy hồ sơ';

  @override
  String get detail_manage_tags => 'Manage Tags';

  @override
  String get detail_no_tags => 'No Tags';

  @override
  String detail_save_error(String error) {
    return 'Save failed: $error';
  }

  @override
  String get home_empty_records => 'Chưa có hồ sơ nào';

  @override
  String timeline_pending_review(int count) {
    return 'Có $count mục chờ xác minh';
  }

  @override
  String get timeline_pending_hint => 'Chạm để kiểm tra và lưu trữ';

  @override
  String get disclaimer_title => 'Miễn trừ trách nhiệm y tế';

  @override
  String get disclaimer_welcome => 'Chào mừng bạn đến với PaperHealth.';

  @override
  String get disclaimer_intro =>
      'Trước khi bắt đầu sử dụng ứng dụng này, vui lòng đọc kỹ tuyên bố miễn trừ trách nhiệm sau đây:';

  @override
  String get disclaimer_point_1_title => '1. Không phải lời khuyên y tế';

  @override
  String get disclaimer_point_1_desc =>
      'PaperHealth (sau đây gọi là \"ứng dụng này\") chỉ đóng vai trò là một công cụ cá nhân để sắp xếp và số hóa hồ sơ bệnh án. Nó không cung cấp bất kỳ hình thức chẩn đoán, tư vấn hoặc điều trị y tế nào. Không có nội dung nào trong ứng dụng được coi là lời khuyên y tế chuyên nghiệp.';

  @override
  String get disclaimer_point_2_title => '2. Độ chính xác của OCR';

  @override
  String get disclaimer_point_2_desc =>
      'Thông tin được trích xuất qua công nghệ OCR (Nhận dạng ký tự quang học) có thể có sai sót. Người dùng phải xác minh thông tin này với các báo cáo giấy gốc hoặc bản gốc kỹ thuật số. Nhà phát triển không đảm bảo độ chính xác 100% của kết quả nhận dạng.';

  @override
  String get disclaimer_point_3_title => '3. Tư vấn chuyên môn';

  @override
  String get disclaimer_point_3_desc =>
      'Mọi quyết định y tế nên được thực hiện sau khi tham khảo ý kiến của các cơ sở y tế chuyên môn hoặc bác sĩ. Ứng dụng này và các nhà phát triển của nó không chịu trách nhiệm pháp lý cho bất kỳ hậu quả trực tiếp hoặc gián tiếp nào phát sinh từ việc tin tưởng vào thông tin do ứng dụng này cung cấp.';

  @override
  String get disclaimer_point_4_title => '4. Lưu trữ dữ liệu cục bộ';

  @override
  String get disclaimer_point_4_desc =>
      'Ứng dụng này cam kết rằng tất cả dữ liệu chỉ được lưu trữ cục bộ với mã hóa và không được tải lên bất kỳ máy chủ đám mây nào. Người dùng hoàn toàn chịu trách nhiệm về an ninh vật lý cho thiết bị của họ, tính riêng tư của mã PIN và sao lưu dữ liệu.';

  @override
  String get disclaimer_point_5_title => '5. Tình huống khẩn cấp';

  @override
  String get disclaimer_point_5_desc =>
      'Nếu bạn đang trong tình trạng khẩn cấp về y tế, vui lòng gọi dịch vụ cấp cứu địa phương hoặc đến bệnh viện gần nhất ngay lập tức. Không dựa vào ứng dụng này để đưa ra các phán đoán khẩn cấp.';

  @override
  String get disclaimer_footer =>
      'Bằng cách nhấp vào \"Đồng ý\", bạn xác nhận rằng bạn đã đọc và chấp nhận tất cả các điều khoản trên.';

  @override
  String get disclaimer_checkbox =>
      'Tôi đã đọc và đồng ý với miễn trừ trách nhiệm y tế trên';

  @override
  String get disclaimer_accept_button => 'Đồng ý & Tiếp tục';

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
  String get search_hint => 'Tìm OCR, bệnh viện hoặc ghi chú...';

  @override
  String search_result_count(int count) {
    return 'Tìm thấy $count kết quả';
  }

  @override
  String get search_initial_title => 'Bắt đầu tìm kiếm';

  @override
  String get search_initial_desc => 'Nhập từ khóa bệnh viện, thuốc hoặc nhãn';

  @override
  String get search_empty_title => 'Không tìm thấy kết quả';

  @override
  String get search_empty_desc => 'Thử từ khóa khác hoặc kiểm tra chính tả';

  @override
  String search_searching_person(String name) {
    return 'Đang tìm cho: $name';
  }
}
