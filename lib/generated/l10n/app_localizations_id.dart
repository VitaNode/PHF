// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'PaperHealth';

  @override
  String get common_save => 'Simpan';

  @override
  String get common_edit => 'Edit';

  @override
  String get common_delete => 'Hapus';

  @override
  String get common_cancel => 'Batal';

  @override
  String get common_confirm => 'Konfirmasi';

  @override
  String get common_retry => 'Coba lagi';

  @override
  String get common_refresh => 'Segarkan';

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
  String get common_loading => 'Memuat...';

  @override
  String common_load_failed(String error) {
    return 'Gagal memuat: $error';
  }

  @override
  String get lock_screen_title => 'Masukkan PIN untuk membuka';

  @override
  String get lock_screen_error => 'PIN salah, silakan coba lagi';

  @override
  String get lock_screen_biometric_tooltip => 'Buka dengan biometrik';

  @override
  String get ingestion_title => 'Pratinjau & Pemrosesan';

  @override
  String get ingestion_empty_hint => 'Harap tambahkan foto catatan medis';

  @override
  String get ingestion_add_now => 'Tambah Sekarang';

  @override
  String get ingestion_ocr_hint =>
      'Metadata akan dikenali oleh OCR latar belakang setelah disimpan';

  @override
  String get ingestion_submit_button => 'Mulai Pemrosesan & Arsipkan';

  @override
  String get ingestion_grouped_report => 'Tandai sebagai laporan multi-halaman';

  @override
  String get ingestion_grouped_report_hint =>
      'SLM akan menganggap gambar-gambar ini sebagai satu dokumen berkelanjutan';

  @override
  String get ingestion_take_photo => 'Ambil Foto';

  @override
  String get ingestion_pick_gallery => 'Pilih dari Galeri';

  @override
  String get ingestion_processing_queue =>
      'Ditambahkan ke antrean OCR latar belakang...';

  @override
  String ingestion_save_error(String error) {
    return 'Penyimpanan terhambat: $error';
  }

  @override
  String get review_edit_title => 'Verifikasi Informasi';

  @override
  String get review_edit_confirm => 'Konfirmasi & Arsipkan';

  @override
  String get review_edit_basic_info => 'Info Dasar (Ketuk untuk Edit)';

  @override
  String get review_edit_hospital_label => 'Rumah Sakit/Institusi';

  @override
  String get review_edit_date_label => 'Tanggal Kunjungan';

  @override
  String get review_edit_confidence => 'Keyakinan OCR';

  @override
  String review_edit_page_indicator(int current, int total) {
    return 'Gambar $current / $total (Harap verifikasi setiap halaman)';
  }

  @override
  String get review_list_title => 'Catatan Menunggu';

  @override
  String get review_list_empty => 'Tidak ada catatan menunggu tinjauan';

  @override
  String get review_edit_ocr_section => 'Hasil Pengenalan (Ketuk untuk edit)';

  @override
  String get review_edit_ocr_hint =>
      'Ketuk teks untuk fokus pada area gambar yang sesuai';

  @override
  String review_approve_failed(String error) {
    return 'Gagal mengarsipkan: $error';
  }

  @override
  String get settings_title => 'Pengaturan';

  @override
  String get settings_section_profiles => 'Profil & Kategori';

  @override
  String get settings_manage_profiles => 'Kelola Profil';

  @override
  String get settings_manage_profiles_desc =>
      'Tambah atau edit profil personel';

  @override
  String get settings_tag_library => 'Pustaka Tag';

  @override
  String get settings_tag_library_desc => 'Kelola tag catatan medis';

  @override
  String get settings_language => 'Bahasa';

  @override
  String get settings_language_desc => 'Ganti bahasa tampilan aplikasi';

  @override
  String get settings_section_security => 'Keamanan Data';

  @override
  String get settings_privacy_security => 'Privasi & Keamanan';

  @override
  String get settings_privacy_security_desc => 'Ubah PIN dan biometrik';

  @override
  String get settings_backup_restore => 'Cadangkan & Pulihkan';

  @override
  String get settings_backup_restore_desc => 'Ekspor file cadangan terenkripsi';

  @override
  String get settings_section_support => 'Bantuan & Dukungan';

  @override
  String get settings_feedback => 'Umpan Balik';

  @override
  String get settings_feedback_desc => 'Laporkan masalah atau saran';

  @override
  String get settings_section_about => 'Tentang';

  @override
  String get settings_privacy_policy => 'Kebijakan Privasi';

  @override
  String get settings_privacy_policy_desc => 'Lihat kebijakan privasi aplikasi';

  @override
  String get settings_version => 'Versi';

  @override
  String get settings_security_app_lock => 'Kunci Aplikasi';

  @override
  String get settings_security_change_pin => 'Ubah PIN';

  @override
  String get settings_security_change_pin_desc =>
      'Ubah kode 6 digit untuk membuka kunci';

  @override
  String get settings_security_lock_timeout => 'Waktu Kunci Otomatis';

  @override
  String get settings_security_timeout_immediate => 'Segera';

  @override
  String get settings_security_timeout_1min => 'Setelah 1 menit';

  @override
  String get settings_security_timeout_5min => 'Setelah 5 menit';

  @override
  String settings_security_timeout_custom(int minutes) {
    return 'Setelah $minutes menit';
  }

  @override
  String get settings_security_biometrics => 'Buka Kunci Biometrik';

  @override
  String get settings_security_biometrics_desc =>
      'Aktifkan sidik jari atau pengenalan wajah';

  @override
  String get settings_security_biometrics_enabled_failed =>
      'Failed to enable biometrics';

  @override
  String get settings_security_biometrics_disabled_failed =>
      'Failed to disable biometrics';

  @override
  String get settings_security_info_card =>
      'PaperHealth menggunakan enkripsi lokal. PIN dan data biometrik Anda hanya disimpan di enclave aman perangkat Anda. Tidak ada pihak ketiga (termasuk pengembang) yang dapat mengaksesnya.';

  @override
  String get settings_security_pin_current => 'Masukkan PIN saat ini';

  @override
  String get settings_security_pin_new => 'Masukkan PIN baru';

  @override
  String get settings_security_pin_confirm => 'Konfirmasi PIN baru';

  @override
  String get settings_security_pin_mismatch => 'PIN tidak cocok';

  @override
  String get settings_security_pin_success => 'PIN berhasil diubah';

  @override
  String get settings_security_pin_error => 'PIN saat ini salah';

  @override
  String get person_management_empty => 'Tidak ada profil ditemukan';

  @override
  String get person_management_default => 'Profil Default';

  @override
  String get person_delete_title => 'Hapus Profil';

  @override
  String person_delete_confirm(String name) {
    return 'Apakah Anda yakin ingin menghapus $name? Penghapusan akan ditolak jika ada catatan di bawah profil ini.';
  }

  @override
  String get person_edit_title => 'Edit Profil';

  @override
  String get person_add_title => 'Profil Baru';

  @override
  String get person_field_nickname => 'Nama Panggilan';

  @override
  String get person_field_nickname_hint => 'Masukkan nama atau gelar';

  @override
  String get person_field_color => 'Pilih Warna Profil';

  @override
  String get tag_management_empty => 'Tidak ada tag ditemukan';

  @override
  String get tag_management_custom => 'Tag Kustom';

  @override
  String get tag_management_system => 'Tag Sistem';

  @override
  String get tag_add_title => 'New Tag';

  @override
  String get tag_edit_title => 'Edit Tag';

  @override
  String get tag_delete_title => 'Hapus Tag';

  @override
  String tag_delete_confirm(String name) {
    return 'Apakah Anda yakin ingin menghapus tag $name? Ini akan menghapusnya dari semua gambar terkait.';
  }

  @override
  String get tag_field_name => 'Nama Tag';

  @override
  String get tag_field_name_hint => 'misal, Hasil Lab, Rontgen';

  @override
  String get tag_reorder_title => 'Reorder Tags';

  @override
  String tag_create_new(String query) {
    return 'Buat tag baru: $query';
  }

  @override
  String get feedback_info =>
      'Kami berkomitmen untuk melindungi privasi Anda. Aplikasi ini berjalan 100% offline.\nHubungi kami melalui metode berikut.';

  @override
  String get feedback_email => 'Kirim Email';

  @override
  String get feedback_github => 'GitHub Issues';

  @override
  String get feedback_github_desc => 'Laporkan bug atau saran';

  @override
  String get feedback_logs_section => 'Diagnostik Sistem';

  @override
  String get feedback_logs_copy => 'Salin Log';

  @override
  String get feedback_logs_exporting => 'Mengekspor...';

  @override
  String get feedback_logs_hint =>
      'Salin info perangkat dan log yang telah dibersihkan ke clipboard untuk dibagikan.';

  @override
  String get feedback_error_email => 'Tidak dapat membuka klien email';

  @override
  String get feedback_error_browser => 'Tidak dapat membuka browser';

  @override
  String get feedback_copied => 'Disalin ke clipboard';

  @override
  String get detail_hospital_label => 'Rumah Sakit';

  @override
  String get detail_date_label => 'Tanggal Kunjungan';

  @override
  String get detail_tags_label => 'Tag';

  @override
  String get detail_image_delete_title => 'Konfirmasi Hapus';

  @override
  String get detail_image_delete_confirm =>
      'Apakah Anda yakin ingin menghapus gambar ini? Tindakan ini tidak dapat dibatalkan.';

  @override
  String get detail_ocr_queued =>
      'Ditambahkan kembali ke antrean, harap tunggu...';

  @override
  String detail_ocr_failed(Object error) {
    return 'OCR gagal: $error';
  }

  @override
  String get detail_ocr_text => 'OCR Text';

  @override
  String get detail_ocr_title => 'Teks OCR';

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
  String get detail_view_raw => 'Teks Mentah';

  @override
  String get detail_view_enhanced => 'Peningkatan Pintar';

  @override
  String get detail_ocr_collapse => 'Sembunyikan';

  @override
  String get detail_ocr_expand => 'Lihat Semua';

  @override
  String get detail_record_not_found => 'Catatan tidak ditemukan';

  @override
  String get detail_manage_tags => 'Manage Tags';

  @override
  String get detail_no_tags => 'No Tags';

  @override
  String detail_save_error(String error) {
    return 'Save failed: $error';
  }

  @override
  String get home_empty_records => 'Belum ada catatan';

  @override
  String timeline_pending_review(int count) {
    return '$count item menunggu verifikasi';
  }

  @override
  String get timeline_pending_hint => 'Ketuk untuk verifikasi dan arsipkan';

  @override
  String get disclaimer_title => 'Penafian Medis';

  @override
  String get disclaimer_welcome => 'Selamat datang di PaperHealth.';

  @override
  String get disclaimer_intro =>
      'Sebelum Anda mulai menggunakan aplikasi ini, harap baca penafian berikut dengan saksama:';

  @override
  String get disclaimer_point_1_title => '1. Bukan Saran Medis';

  @override
  String get disclaimer_point_1_desc =>
      'PaperHealth (selanjutnya disebut sebagai \"aplikasi ini\") hanya berfungsi sebagai alat pengorganisasian dan digitalisasi catatan medis pribadi. Aplikasi ini tidak memberikan diagnosis medis, saran, atau perawatan dalam bentuk apa pun. Tidak ada konten di dalam aplikasi yang boleh dianggap sebagai saran medis profesional.';

  @override
  String get disclaimer_point_2_title => '2. Akurasi OCR';

  @override
  String get disclaimer_point_2_desc =>
      'Informasi yang diekstraksi melalui teknologi OCR (Optical Character Recognition) mungkin mengandung kesalahan. Pengguna harus memverifikasi informasi ini terhadap laporan kertas asli atau dokumen digital asli. Pengembang tidak menjamin akurasi 100% dari hasil pengenalan.';

  @override
  String get disclaimer_point_3_title => '3. Konsultasi Profesional';

  @override
  String get disclaimer_point_3_desc =>
      'Setiap keputusan medis harus dibuat dengan berkonsultasi dengan lembaga medis profesional atau dokter. Aplikasi ini dan pengembangnya tidak bertanggung jawab secara hukum atas konsekuensi langsung atau tidak langsung yang diakibatkan oleh ketergantungan pada informasi yang disediakan oleh aplikasi ini.';

  @override
  String get disclaimer_point_4_title => '4. Penyimpanan Data Lokal';

  @override
  String get disclaimer_point_4_desc =>
      'Aplikasi ini menjanjikan bahwa semua data disimpan hanya secara lokal dengan enkripsi dan tidak diunggah ke server cloud mana pun. Pengguna bertanggung jawab penuh atas keamanan fisik perangkat mereka, privasi PIN, dan cadangan data.';

  @override
  String get disclaimer_point_5_title => '5. Situasi Darurat';

  @override
  String get disclaimer_point_5_desc =>
      'Jika Anda berada dalam keadaan darurat medis, harap segera hubungi layanan darurat setempat atau pergi ke rumah sakit terdekat. Jangan mengandalkan aplikasi ini untuk penilaian darurat.';

  @override
  String get disclaimer_footer =>
      'Dengan mengklik \"Setuju\", Anda mengakui bahwa Anda telah membaca dan menerima semua persyaratan di atas.';

  @override
  String get disclaimer_checkbox =>
      'Saya telah membaca dan menyetujui penafian medis di atas';

  @override
  String get disclaimer_accept_button => 'Setuju & Lanjutkan';

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
  String get search_hint => 'Cari OCR, rumah sakit, atau catatan...';

  @override
  String search_result_count(int count) {
    return 'Ditemukan $count hasil';
  }

  @override
  String get search_initial_title => 'Mulai Mencari';

  @override
  String get search_initial_desc =>
      'Masukkan kata kunci rumah sakit, obat, atau tag';

  @override
  String get search_empty_title => 'Hasil tidak ditemukan';

  @override
  String get search_empty_desc =>
      'Coba kata kunci yang berbeda atau periksa ejaan';

  @override
  String search_searching_person(String name) {
    return 'Mencari: $name';
  }
}
