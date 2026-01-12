// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'PaperHealth';

  @override
  String get common_save => 'Guardar';

  @override
  String get common_edit => 'Editar';

  @override
  String get common_delete => 'Eliminar';

  @override
  String get common_cancel => 'Cancelar';

  @override
  String get common_confirm => 'Confirmar';

  @override
  String get common_retry => 'Reintentar';

  @override
  String get common_refresh => 'Refrescar';

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
  String get common_loading => 'Cargando...';

  @override
  String common_load_failed(String error) {
    return 'Error al cargar: $error';
  }

  @override
  String get lock_screen_title => 'Ingrese PIN para desbloquear';

  @override
  String get lock_screen_error => 'PIN incorrecto, intente de nuevo';

  @override
  String get lock_screen_biometric_tooltip => 'Desbloquear con biometría';

  @override
  String get ingestion_title => 'Vista previa y procesamiento';

  @override
  String get ingestion_empty_hint =>
      'Por favor agregue fotos de registros médicos';

  @override
  String get ingestion_add_now => 'Agregar ahora';

  @override
  String get ingestion_ocr_hint =>
      'Los metadatos se reconocerán por el OCR en segundo plano después de guardar';

  @override
  String get ingestion_submit_button => 'Iniciar procesamiento y archivo';

  @override
  String get ingestion_grouped_report =>
      'Marcar como informe de varias páginas';

  @override
  String get ingestion_grouped_report_hint =>
      'SLM tratará estas imágenes como un único documento continuo';

  @override
  String get ingestion_take_photo => 'Tomar foto';

  @override
  String get ingestion_pick_gallery => 'Elegir de la galería';

  @override
  String get ingestion_processing_queue =>
      'Añadido a la cola de OCR en segundo plano...';

  @override
  String ingestion_save_error(String error) {
    return 'Guardado bloqueado: $error';
  }

  @override
  String get review_edit_title => 'Verificar información';

  @override
  String get review_edit_confirm => 'Confirmar y archivar';

  @override
  String get review_edit_basic_info => 'Información básica (Tocar para editar)';

  @override
  String get review_edit_hospital_label => 'Hospital/Institución';

  @override
  String get review_edit_date_label => 'Fecha de visita';

  @override
  String get review_edit_confidence => 'Confianza de OCR';

  @override
  String review_edit_page_indicator(int current, int total) {
    return 'Imagen $current / $total (Verifique cada página)';
  }

  @override
  String get review_list_title => 'Registros pendientes';

  @override
  String get review_list_empty => 'No hay registros pendientes de revisión';

  @override
  String get review_edit_ocr_section =>
      'Resultados del reconocimiento (Tocar para editar)';

  @override
  String get review_edit_ocr_hint =>
      'Toque el texto para enfocar el área de la imagen correspondiente';

  @override
  String review_approve_failed(String error) {
    return 'Error al archivar: $error';
  }

  @override
  String get settings_title => 'Ajustes';

  @override
  String get settings_section_profiles => 'Perfiles y categorías';

  @override
  String get settings_manage_profiles => 'Gestionar perfiles';

  @override
  String get settings_manage_profiles_desc =>
      'Agregar o editar perfiles de personal';

  @override
  String get settings_tag_library => 'Biblioteca de etiquetas';

  @override
  String get settings_tag_library_desc =>
      'Mantener etiquetas de registros médicos';

  @override
  String get settings_language => 'Idioma';

  @override
  String get settings_language_desc =>
      'Cambiar el idioma de visualización de la aplicación';

  @override
  String get settings_section_security => 'Seguridad de datos';

  @override
  String get settings_privacy_security => 'Privacidad y seguridad';

  @override
  String get settings_privacy_security_desc => 'Modificar PIN y biometría';

  @override
  String get settings_backup_restore => 'Copia de seguridad y restauración';

  @override
  String get settings_backup_restore_desc =>
      'Exportar archivos de copia de seguridad cifrados';

  @override
  String get settings_section_support => 'Ayuda y soporte';

  @override
  String get settings_feedback => 'Comentarios';

  @override
  String get settings_feedback_desc => 'Informar problemas o sugerencias';

  @override
  String get settings_section_about => 'Acerca de';

  @override
  String get settings_privacy_policy => 'Política de privacidad';

  @override
  String get settings_privacy_policy_desc =>
      'Ver la política de privacidad de la aplicación';

  @override
  String get settings_version => 'Versión';

  @override
  String get settings_security_app_lock => 'Bloqueo de aplicación';

  @override
  String get settings_security_change_pin => 'Cambiar PIN';

  @override
  String get settings_security_change_pin_desc =>
      'Cambiar el código de 6 dígitos para desbloquear';

  @override
  String get settings_security_lock_timeout => 'Tiempo de espera de bloqueo';

  @override
  String get settings_security_timeout_immediate => 'Inmediato';

  @override
  String get settings_security_timeout_1min => 'Después de 1 minuto';

  @override
  String get settings_security_timeout_5min => 'Después de 5 minutos';

  @override
  String settings_security_timeout_custom(int minutes) {
    return 'Después de $minutes minutos';
  }

  @override
  String get settings_security_biometrics => 'Desbloqueo biométrico';

  @override
  String get settings_security_biometrics_desc =>
      'Habilitar huella dactilar o reconocimiento facial';

  @override
  String get settings_security_biometrics_enabled_failed =>
      'Failed to enable biometrics';

  @override
  String get settings_security_biometrics_disabled_failed =>
      'Failed to disable biometrics';

  @override
  String get settings_security_info_card =>
      'PaperHealth utiliza cifrado local. Su PIN y datos biométricos se almacenan solo en el enclave seguro de su dispositivo. Ningún tercero (incluidos los desarrolladores) puede acceder a ellos.';

  @override
  String get settings_security_pin_current => 'Ingrese PIN actual';

  @override
  String get settings_security_pin_new => 'Ingrese nuevo PIN';

  @override
  String get settings_security_pin_confirm => 'Confirme nuevo PIN';

  @override
  String get settings_security_pin_mismatch => 'Los PIN no coinciden';

  @override
  String get settings_security_pin_success => 'PIN cambiado con éxito';

  @override
  String get settings_security_pin_error => 'PIN actual incorrecto';

  @override
  String get person_management_empty => 'No se encontraron perfiles';

  @override
  String get person_management_default => 'Perfil predeterminado';

  @override
  String get person_delete_title => 'Eliminar perfil';

  @override
  String person_delete_confirm(String name) {
    return '¿Está seguro de que desea eliminar a $name? La eliminación se rechazará si hay registros en este perfil.';
  }

  @override
  String get person_edit_title => 'Editar perfil';

  @override
  String get person_add_title => 'Nuevo perfil';

  @override
  String get person_field_nickname => 'Apodo';

  @override
  String get person_field_nickname_hint => 'Ingrese nombre o título';

  @override
  String get person_field_color => 'Seleccionar color de perfil';

  @override
  String get tag_management_empty => 'No se encontraron etiquetas';

  @override
  String get tag_management_custom => 'Etiquetas personalizadas';

  @override
  String get tag_management_system => 'Etiquetas del sistema';

  @override
  String get tag_add_title => 'New Tag';

  @override
  String get tag_edit_title => 'Edit Tag';

  @override
  String get tag_delete_title => 'Eliminar etiqueta';

  @override
  String tag_delete_confirm(String name) {
    return '¿Está seguro de que desea eliminar la etiqueta $name? Esto la eliminará de todas las imágenes asociadas.';
  }

  @override
  String get tag_field_name => 'Nombre de la etiqueta';

  @override
  String get tag_field_name_hint => 'ej., Resultado de laboratorio, Rayos X';

  @override
  String get tag_reorder_title => 'Reorder Tags';

  @override
  String tag_create_new(String query) {
    return 'Crear nueva etiqueta: $query';
  }

  @override
  String get feedback_info =>
      'Estamos comprometidos con la protección de su privacidad. La aplicación funciona 100% fuera de línea.\nContáctenos a través de los siguientes métodos.';

  @override
  String get feedback_email => 'Enviar correo';

  @override
  String get feedback_github => 'GitHub Issues';

  @override
  String get feedback_github_desc => 'Informar errores o sugerencias';

  @override
  String get feedback_logs_section => 'Diagnóstico del sistema';

  @override
  String get feedback_logs_copy => 'Copiar registros';

  @override
  String get feedback_logs_exporting => 'Exportando...';

  @override
  String get feedback_logs_hint =>
      'Copie la información del dispositivo y los registros saneados al portapapeles para compartirlos.';

  @override
  String get feedback_error_email => 'No se pudo abrir el cliente de correo';

  @override
  String get feedback_error_browser => 'No se pudo abrir el navegador';

  @override
  String get feedback_copied => 'Copiado al portapapeles';

  @override
  String get detail_hospital_label => 'Hospital';

  @override
  String get detail_date_label => 'Fecha de visita';

  @override
  String get detail_tags_label => 'Etiquetas';

  @override
  String get detail_image_delete_title => 'Confirmar eliminación';

  @override
  String get detail_image_delete_confirm =>
      '¿Está seguro de que desea eliminar esta imagen? Esta acción no se puede deshacer.';

  @override
  String get detail_ocr_queued => 'Re-añadido a la cola, por favor espere...';

  @override
  String detail_ocr_failed(Object error) {
    return 'Error de OCR: $error';
  }

  @override
  String get detail_ocr_text => 'OCR Text';

  @override
  String get detail_ocr_title => 'Texto OCR';

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
  String get detail_view_raw => 'Texto sin procesar';

  @override
  String get detail_view_enhanced => 'Mejorado inteligente';

  @override
  String get detail_ocr_collapse => 'Contraer';

  @override
  String get detail_ocr_expand => 'Expandir';

  @override
  String get detail_record_not_found => 'Registro no encontrado';

  @override
  String get detail_manage_tags => 'Manage Tags';

  @override
  String get detail_no_tags => 'No Tags';

  @override
  String detail_save_error(String error) {
    return 'Save failed: $error';
  }

  @override
  String get home_empty_records => 'No hay registros aún';

  @override
  String timeline_pending_review(int count) {
    return '$count elementos pendientes de verificación';
  }

  @override
  String get timeline_pending_hint => 'Toque para verificar y archivar';

  @override
  String get disclaimer_title => 'Descargo de responsabilidad médica';

  @override
  String get disclaimer_welcome => 'Bienvenido a PaperHealth.';

  @override
  String get disclaimer_intro =>
      'Antes de comenzar a usar esta aplicación, lea atentamente el siguiente descargo de responsabilidad:';

  @override
  String get disclaimer_point_1_title => '1. No es consejo médico';

  @override
  String get disclaimer_point_1_desc =>
      'PaperHealth (en adelante, \"esta aplicación\") sirve solo como una herramienta personal de organización y digitalización de registros médicos. No proporciona ningún tipo de diagnóstico médico, consejo o tratamiento. Ningún contenido dentro de la aplicación debe considerarse consejo médico profesional.';

  @override
  String get disclaimer_point_2_title => '2. Precisión del OCR';

  @override
  String get disclaimer_point_2_desc =>
      'La información extraída mediante la tecnología OCR (Reconocimiento Óptico de Caracteres) puede contener errores. Los usuarios deben verificar esta información con los informes en papel originales o los originales digitales. El desarrollador no garantiza la precisión del 100% de los resultados del reconocimiento.';

  @override
  String get disclaimer_point_3_title => '3. Consulta profesional';

  @override
  String get disclaimer_point_3_desc =>
      'Cualquier decisión médica debe tomarse en consulta con instituciones médicas profesionales o médicos. Esta aplicación y sus desarrolladores no asumen ninguna responsabilidad legal por las consecuencias directas o indirectas resultantes de la confianza en la información proporcionada por esta aplicación.';

  @override
  String get disclaimer_point_4_title => '4. Almacenamiento local de datos';

  @override
  String get disclaimer_point_4_desc =>
      'Esta aplicación promete que todos los datos se almacenan solo localmente con cifrado y no se cargan a ningún servidor en la nube. Los usuarios son los únicos responsables de la seguridad física de sus dispositivos, la privacidad del PIN y las copias de seguridad de datos.';

  @override
  String get disclaimer_point_5_title => '5. Situaciones de emergencia';

  @override
  String get disclaimer_point_5_desc =>
      'Si se encuentra en una emergencia médica, llame a los servicios de emergencia locales o vaya al hospital más cercano de inmediato. No confíe en esta aplicación para juicios de emergencia.';

  @override
  String get disclaimer_footer =>
      'Al hacer clic en \"Aceptar\", reconoce que ha leído y aceptado todos los términos anteriores.';

  @override
  String get disclaimer_checkbox =>
      'He leído y acepto el descargo de responsabilidad médica anterior';

  @override
  String get disclaimer_accept_button => 'Aceptar y continuar';

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
  String get search_hint => 'Buscar OCR, hospital o notas...';

  @override
  String search_result_count(int count) {
    return 'Se encontraron $count resultados';
  }

  @override
  String get search_initial_title => 'Comenzar búsqueda';

  @override
  String get search_initial_desc =>
      'Ingrese hospital, medicamento o palabras clave de etiquetas';

  @override
  String get search_empty_title => 'No se encontraron resultados';

  @override
  String get search_empty_desc =>
      'Intente con diferentes palabras clave o verifique la ortografía';

  @override
  String search_searching_person(String name) {
    return 'Buscando: $name';
  }
}
