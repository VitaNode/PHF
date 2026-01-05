/// # Core Providers
///
/// ## Description
/// 全局核心服务的依赖注入定义。
/// 使用 `riverpod_annotation` 生成 Provider。
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/security/file_security_helper.dart';
import '../../core/security/master_key_manager.dart';
import '../../core/services/path_provider_service.dart';
import '../../core/services/permission_service.dart';
import '../../data/datasources/local/database_service.dart';
import '../../data/repositories/image_repository.dart';
import '../../data/repositories/interfaces/image_repository.dart';
import '../../data/repositories/interfaces/record_repository.dart';
import '../../data/repositories/record_repository.dart';
import '../../data/repositories/interfaces/person_repository.dart';
import '../../data/repositories/person_repository.dart';
import '../../data/repositories/app_meta_repository.dart';
import '../../data/repositories/interfaces/tag_repository.dart';
import '../../data/repositories/tag_repository.dart';
import '../../data/repositories/interfaces/search_repository.dart';
import '../../data/repositories/search_repository.dart';
import '../../data/repositories/interfaces/ocr_queue_repository.dart';
import '../../data/repositories/ocr_queue_repository.dart';
import '../../data/models/tag.dart';
import 'person_provider.dart';
import 'logging_provider.dart';
import '../services/interfaces/backup_service.dart';
import '../services/backup_service.dart';
import '../services/crypto_service.dart';
import '../services/interfaces/security_service.dart';
import '../services/security_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/gallery_import_service.dart';
import '../services/image_processing_service.dart';
import '../services/interfaces/crypto_service.dart';
import '../services/interfaces/gallery_service.dart';
import '../services/interfaces/image_service.dart';

part 'core_providers.g.dart';

// --- Infrastructure Services ---

@Riverpod(keepAlive: true)
PathProviderService pathProviderService(Ref ref) {
  return PathProviderService();
}

@Riverpod(keepAlive: true)
PermissionService permissionService(Ref ref) {
  return PermissionService();
}

@Riverpod(keepAlive: true)
MasterKeyManager masterKeyManager(Ref ref) {
  return MasterKeyManager();
}

@Riverpod(keepAlive: true)
SQLCipherDatabaseService databaseService(Ref ref) {
  final km = ref.watch(masterKeyManagerProvider);
  final pp = ref.watch(pathProviderServiceProvider);
  final service = SQLCipherDatabaseService(keyManager: km, pathService: pp);
  ref.onDispose(() => service.close());
  return service;
}

@Riverpod(keepAlive: true)
FileSecurityHelper fileSecurityHelper(Ref ref) {
  final crypto = ref.watch(cryptoServiceProvider);
  return FileSecurityHelper(cryptoService: crypto);
}

// --- Domain Services ---

@Riverpod(keepAlive: true)
IImageService imageProcessingService(Ref ref) {
  return ImageProcessingService();
}

@Riverpod(keepAlive: true)
IGalleryService galleryService(Ref ref) {
  return GalleryImportService();
}

// --- Data Repositories ---

@Riverpod(keepAlive: true)
IRecordRepository recordRepository(Ref ref) {
  final db = ref.watch(databaseServiceProvider);
  return RecordRepository(db);
}

@Riverpod(keepAlive: true)
ICryptoService cryptoService(Ref ref) {
  return CryptoService();
}

@Riverpod(keepAlive: true)
IBackupService backupService(Ref ref) {
  final crypto = ref.watch(cryptoServiceProvider);
  final path = ref.watch(pathProviderServiceProvider);
  final key = ref.watch(masterKeyManagerProvider);
  final db = ref.watch(databaseServiceProvider);
  final talker = ref.watch(talkerProvider);
  return BackupService(
    cryptoService: crypto,
    pathService: path,
    keyManager: key,
    dbService: db,
    talker: talker,
  );
}

@Riverpod(keepAlive: true)
IImageRepository imageRepository(Ref ref) {
  final db = ref.watch(databaseServiceProvider);
  return ImageRepository(db);
}

@Riverpod(keepAlive: true)
IPersonRepository personRepository(Ref ref) {
  final db = ref.watch(databaseServiceProvider);
  return PersonRepository(db);
}

@Riverpod(keepAlive: true)
AppMetaRepository appMetaRepository(Ref ref) {
  final db = ref.watch(databaseServiceProvider);
  return AppMetaRepository(db);
}

@Riverpod(keepAlive: true)
ISecurityService securityService(Ref ref) {
  final metaRepo = ref.watch(appMetaRepositoryProvider);
  final talker = ref.watch(talkerProvider);
  return SecurityService(
    secureStorage: const FlutterSecureStorage(),
    metaRepo: metaRepo,
    talker: talker,
  );
}

@Riverpod(keepAlive: true)
ITagRepository tagRepository(Ref ref) {
  final db = ref.watch(databaseServiceProvider);
  final talker = ref.watch(talkerProvider);
  return TagRepository(db, talker);
}

@Riverpod(keepAlive: true)
ISearchRepository searchRepository(Ref ref) {
  final db = ref.watch(databaseServiceProvider);
  return SearchRepository(db);
}

@Riverpod(keepAlive: true)
IOCRQueueRepository ocrQueueRepository(Ref ref) {
  final db = ref.watch(databaseServiceProvider);
  return OCRQueueRepository(db);
}

@riverpod
Future<List<Tag>> allTags(Ref ref) async {
  final personId = await ref.watch(currentPersonIdControllerProvider.future);
  final repo = ref.watch(tagRepositoryProvider);
  return repo.getAllTags(personId: personId);
}
