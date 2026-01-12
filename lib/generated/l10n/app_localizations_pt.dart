// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'PaperHealth';

  @override
  String get common_save => 'Salvar';

  @override
  String get common_edit => 'Editar';

  @override
  String get common_delete => 'Excluir';

  @override
  String get common_cancel => 'Cancelar';

  @override
  String get common_confirm => 'Confirmar';

  @override
  String get common_retry => 'Tentar novamente';

  @override
  String get common_refresh => 'Atualizar';

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
  String get common_loading => 'Carregando...';

  @override
  String common_load_failed(String error) {
    return 'Falha ao carregar: $error';
  }

  @override
  String get lock_screen_title => 'Digite o PIN para desbloquear';

  @override
  String get lock_screen_error => 'PIN incorreto, tente novamente';

  @override
  String get lock_screen_biometric_tooltip => 'Desbloquear com biometria';

  @override
  String get ingestion_title => 'Visualização e Processamento';

  @override
  String get ingestion_empty_hint =>
      'Por favor, adicione fotos de registros médicos';

  @override
  String get ingestion_add_now => 'Adicionar Agora';

  @override
  String get ingestion_ocr_hint =>
      'Os metadados serão reconhecidos pelo OCR em segundo plano após salvar';

  @override
  String get ingestion_submit_button => 'Iniciar Processamento e Arquivamento';

  @override
  String get ingestion_grouped_report =>
      'Marcar como relatório de várias páginas';

  @override
  String get ingestion_grouped_report_hint =>
      'O SLM tratará essas imagens como um único documento contínuo';

  @override
  String get ingestion_take_photo => 'Tirar Foto';

  @override
  String get ingestion_pick_gallery => 'Escolher da Galeria';

  @override
  String get ingestion_processing_queue =>
      'Adicionado à fila de OCR em segundo plano...';

  @override
  String ingestion_save_error(String error) {
    return 'Salvamento bloqueado: $error';
  }

  @override
  String get review_edit_title => 'Verificar Informações';

  @override
  String get review_edit_confirm => 'Confirmar e Arquivar';

  @override
  String get review_edit_basic_info =>
      'Informações Básicas (Toque para Editar)';

  @override
  String get review_edit_hospital_label => 'Hospital/Instituição';

  @override
  String get review_edit_date_label => 'Data da Visita';

  @override
  String get review_edit_confidence => 'Confiança do OCR';

  @override
  String review_edit_page_indicator(int current, int total) {
    return 'Imagem $current / $total (Verifique cada página)';
  }

  @override
  String get review_list_title => 'Registros Pendentes';

  @override
  String get review_list_empty => 'Nenhum registro pendente de revisão';

  @override
  String get review_edit_ocr_section =>
      'Resultados do Reconhecimento (Toque para editar)';

  @override
  String get review_edit_ocr_hint =>
      'Toque no texto para focar na área da imagem correspondente';

  @override
  String review_approve_failed(String error) {
    return 'Falha ao arquivar: $error';
  }

  @override
  String get settings_title => 'Configurações';

  @override
  String get settings_section_profiles => 'Perfis e Categorias';

  @override
  String get settings_manage_profiles => 'Gerenciar Perfis';

  @override
  String get settings_manage_profiles_desc =>
      'Adicionar ou editar perfis de pessoal';

  @override
  String get settings_tag_library => 'Biblioteca de Etiquetas';

  @override
  String get settings_tag_library_desc =>
      'Manter etiquetas de registros médicos';

  @override
  String get settings_language => 'Idioma';

  @override
  String get settings_language_desc =>
      'Alterar o idioma de exibição do aplicativo';

  @override
  String get settings_section_security => 'Segurança de Dados';

  @override
  String get settings_privacy_security => 'Privacidade e Segurança';

  @override
  String get settings_privacy_security_desc => 'Modificar PIN e biometria';

  @override
  String get settings_backup_restore => 'Backup e Restauração';

  @override
  String get settings_backup_restore_desc =>
      'Exportar arquivos de backup criptografados';

  @override
  String get settings_section_support => 'Ajuda e Suporte';

  @override
  String get settings_feedback => 'Feedback';

  @override
  String get settings_feedback_desc => 'Relatar problemas ou sugestões';

  @override
  String get settings_section_about => 'Sobre';

  @override
  String get settings_privacy_policy => 'Política de Privacidade';

  @override
  String get settings_privacy_policy_desc =>
      'Ver a política de privacidade do aplicativo';

  @override
  String get settings_version => 'Versão';

  @override
  String get settings_security_app_lock => 'Bloqueio do Aplicativo';

  @override
  String get settings_security_change_pin => 'Alterar PIN';

  @override
  String get settings_security_change_pin_desc =>
      'Alterar o código de 6 dígitos usado para desbloquear';

  @override
  String get settings_security_lock_timeout => 'Tempo de Bloqueio Automático';

  @override
  String get settings_security_timeout_immediate => 'Imediato';

  @override
  String get settings_security_timeout_1min => 'Após 1 minuto';

  @override
  String get settings_security_timeout_5min => 'Após 5 minutos';

  @override
  String settings_security_timeout_custom(int minutes) {
    return 'Após $minutes minutos';
  }

  @override
  String get settings_security_biometrics => 'Desbloqueio Biométrico';

  @override
  String get settings_security_biometrics_desc =>
      'Ativar impressão digital ou reconhecimento facial';

  @override
  String get settings_security_biometrics_enabled_failed =>
      'Failed to enable biometrics';

  @override
  String get settings_security_biometrics_disabled_failed =>
      'Failed to disable biometrics';

  @override
  String get settings_security_info_card =>
      'O PaperHealth usa criptografia local. Seu PIN e dados biométricos são armazenados apenas no enclave seguro do seu dispositivo. Nenhum terceiro (incluindo desenvolvedores) pode acessá-los.';

  @override
  String get settings_security_pin_current => 'Digite o PIN atual';

  @override
  String get settings_security_pin_new => 'Digite o novo PIN';

  @override
  String get settings_security_pin_confirm => 'Confirme o novo PIN';

  @override
  String get settings_security_pin_mismatch => 'Os PINs não coincidem';

  @override
  String get settings_security_pin_success => 'PIN alterado com sucesso';

  @override
  String get settings_security_pin_error => 'PIN atual incorreto';

  @override
  String get person_management_empty => 'Nenhum perfil encontrado';

  @override
  String get person_management_default => 'Perfil Padrão';

  @override
  String get person_delete_title => 'Excluir Perfil';

  @override
  String person_delete_confirm(String name) {
    return 'Tem certeza de que deseja excluir $name? A exclusão será rejeitada se houver registros neste perfil.';
  }

  @override
  String get person_edit_title => 'Editar Perfil';

  @override
  String get person_add_title => 'Novo Perfil';

  @override
  String get person_field_nickname => 'Apelido';

  @override
  String get person_field_nickname_hint => 'Digite o nome ou título';

  @override
  String get person_field_color => 'Selecionar Cor do Perfil';

  @override
  String get tag_management_empty => 'Nenhuma etiqueta encontrada';

  @override
  String get tag_management_custom => 'Etiquetas Personalizadas';

  @override
  String get tag_management_system => 'Etiquetas do Sistema';

  @override
  String get tag_add_title => 'New Tag';

  @override
  String get tag_edit_title => 'Edit Tag';

  @override
  String get tag_delete_title => 'Excluir Etiqueta';

  @override
  String tag_delete_confirm(String name) {
    return 'Tem certeza de que deseja excluir a etiqueta $name? Isso a removerá de todas as imagens associadas.';
  }

  @override
  String get tag_field_name => 'Nome da Etiqueta';

  @override
  String get tag_field_name_hint => 'ex: Resultado de Exame, Raio-X';

  @override
  String get tag_reorder_title => 'Reorder Tags';

  @override
  String tag_create_new(String query) {
    return 'Criar nova etiqueta: $query';
  }

  @override
  String get feedback_info =>
      'Estamos comprometidos em proteger sua privacidade. O aplicativo funciona 100% offline.\nEntre em contato conosco através dos seguintes métodos.';

  @override
  String get feedback_email => 'Enviar E-mail';

  @override
  String get feedback_github => 'GitHub Issues';

  @override
  String get feedback_github_desc => 'Relatar bugs ou sugestões';

  @override
  String get feedback_logs_section => 'Diagnóstico do Sistema';

  @override
  String get feedback_logs_copy => 'Copiar Logs';

  @override
  String get feedback_logs_exporting => 'Exportando...';

  @override
  String get feedback_logs_hint =>
      'Copie as informações do dispositivo e os logs limpos para a área de transferência para compartilhar.';

  @override
  String get feedback_error_email =>
      'Não foi possível abrir o cliente de e-mail';

  @override
  String get feedback_error_browser => 'Não foi possível abrir o navegador';

  @override
  String get feedback_copied => 'Copiado para a área de transferência';

  @override
  String get detail_hospital_label => 'Hospital';

  @override
  String get detail_date_label => 'Data da Visita';

  @override
  String get detail_tags_label => 'Etiquetas';

  @override
  String get detail_image_delete_title => 'Confirmar Exclusão';

  @override
  String get detail_image_delete_confirm =>
      'Tem certeza de que deseja excluir esta imagem? Esta ação não pode ser desfeita.';

  @override
  String get detail_ocr_queued => 'Readicionado à fila, por favor aguarde...';

  @override
  String detail_ocr_failed(Object error) {
    return 'Falha no OCR: $error';
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
  String get detail_view_raw => 'Texto Original';

  @override
  String get detail_view_enhanced => 'Aprimorado Inteligente';

  @override
  String get detail_ocr_collapse => 'Recolher';

  @override
  String get detail_ocr_expand => 'Expandir';

  @override
  String get detail_record_not_found => 'Registro não encontrado';

  @override
  String get detail_manage_tags => 'Manage Tags';

  @override
  String get detail_no_tags => 'No Tags';

  @override
  String detail_save_error(String error) {
    return 'Save failed: $error';
  }

  @override
  String get home_empty_records => 'Nenhum registro ainda';

  @override
  String timeline_pending_review(int count) {
    return '$count itens pendentes de verificação';
  }

  @override
  String get timeline_pending_hint => 'Toque para verificar e arquivar';

  @override
  String get disclaimer_title => 'Aviso Legal Médico';

  @override
  String get disclaimer_welcome => 'Bem-vindo ao PaperHealth.';

  @override
  String get disclaimer_intro =>
      'Antes de começar a usar este aplicativo, leia atentamente o seguinte aviso legal:';

  @override
  String get disclaimer_point_1_title => '1. Não é Aconselhamento Médico';

  @override
  String get disclaimer_point_1_desc =>
      'O PaperHealth (doravante denominado \"este aplicativo\") serve apenas como uma ferramenta pessoal de organização e digitalização de registros médicos. Não fornece nenhum tipo de diagnóstico médico, aconselhamento ou tratamento. Nenhum conteúdo do aplicativo deve ser considerado aconselhamento médico profissional.';

  @override
  String get disclaimer_point_2_title => '2. Precisão do OCR';

  @override
  String get disclaimer_point_2_desc =>
      'As informações extraídas via tecnologia OCR (Reconhecimento Óptico de Caracteres) podem conter erros. Os usuários devem verificar essas informações em relação aos relatórios em papel originais ou originais digitais. O desenvolvedor não garante 100% de precisão nos resultados do reconhecimento.';

  @override
  String get disclaimer_point_3_title => '3. Consulta Profissional';

  @override
  String get disclaimer_point_3_desc =>
      'Qualquer decisão médica deve ser tomada em consulta com instituições médicas profissionais ou médicos. Este aplicativo e seus desenvolvedores não assumem qualquer responsabilidade legal por quaisquer consequências diretas ou indiretas resultantes da confiança nas informações fornecidas por este aplicativo.';

  @override
  String get disclaimer_point_4_title => '4. Armazenamento Local de Dados';

  @override
  String get disclaimer_point_4_desc =>
      'Este aplicativo promete que todos os dados são armazenados apenas localmente com criptografia e não são enviados para nenhum servidor na nuvem. Os usuários são os únicos responsáveis pela segurança física de seus dispositivos, privacidade do PIN e backups de dados.';

  @override
  String get disclaimer_point_5_title => '5. Situações de Emergência';

  @override
  String get disclaimer_point_5_desc =>
      'Se você estiver em uma emergência médica, ligue para os serviços de emergência locais ou vá ao hospital mais próximo imediatamente. Não confie neste aplicativo para julgamentos de emergência.';

  @override
  String get disclaimer_footer =>
      'Ao clicar em \"Aceitar\", você reconhece que leu e aceitou todos os termos acima.';

  @override
  String get disclaimer_checkbox =>
      'Li e concordo com o aviso legal médico acima';

  @override
  String get disclaimer_accept_button => 'Aceitar e Continuar';

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
  String get search_hint => 'Buscar OCR, hospital ou notas...';

  @override
  String search_result_count(int count) {
    return 'Encontrados $count resultados';
  }

  @override
  String get search_initial_title => 'Começar a Buscar';

  @override
  String get search_initial_desc =>
      'Digite hospital, medicamento ou palavras-chave de etiquetas';

  @override
  String get search_empty_title => 'Nenhum resultado encontrado';

  @override
  String get search_empty_desc =>
      'Tente palavras-chave diferentes ou verifique a ortografia';

  @override
  String search_searching_person(String name) {
    return 'Buscando: $name';
  }
}
