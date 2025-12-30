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
import '../../data/repositories/app_meta_repository.dart';
import '../../data/repositories/interfaces/tag_repository.dart';
import '../../data/repositories/tag_repository.dart';
import '../../data/models/tag.dart';
import '../services/crypto_service.dart';
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
PathProviderService pathProviderService(PathProviderServiceRef ref) {
  return PathProviderService();
}

@Riverpod(keepAlive: true)
PermissionService permissionService(PermissionServiceRef ref) {
  return PermissionService();
}

@Riverpod(keepAlive: true)
MasterKeyManager masterKeyManager(MasterKeyManagerRef ref) {
  return MasterKeyManager();
}

@Riverpod(keepAlive: true)
SQLCipherDatabaseService databaseService(DatabaseServiceRef ref) {
  final km = ref.watch(masterKeyManagerProvider);
  final pp = ref.watch(pathProviderServiceProvider);
  return SQLCipherDatabaseService(keyManager: km, pathService: pp);
}

@Riverpod(keepAlive: true)
FileSecurityHelper fileSecurityHelper(FileSecurityHelperRef ref) {
  final crypto = ref.watch(cryptoServiceProvider);
  return FileSecurityHelper(cryptoService: crypto);
}

// --- Domain Services ---

@Riverpod(keepAlive: true)
IImageService imageProcessingService(ImageProcessingServiceRef ref) {
  return ImageProcessingService();
}

@Riverpod(keepAlive: true)
IGalleryService galleryService(GalleryServiceRef ref) {
  return GalleryImportService();
}

// --- Data Repositories ---

@Riverpod(keepAlive: true)
IRecordRepository recordRepository(RecordRepositoryRef ref) {
  final db = ref.watch(databaseServiceProvider);
  return RecordRepository(db);
}

@Riverpod(keepAlive: true)
ICryptoService cryptoService(CryptoServiceRef ref) {
  return CryptoService();
}

@Riverpod(keepAlive: true)
IImageRepository imageRepository(ImageRepositoryRef ref) {
  final db = ref.watch(databaseServiceProvider);
  return ImageRepository(db);
}

@Riverpod(keepAlive: true)
AppMetaRepository appMetaRepository(AppMetaRepositoryRef ref) {
  final db = ref.watch(databaseServiceProvider);
  return AppMetaRepository(db);
}

@Riverpod(keepAlive: true)
SecurityService securityService(SecurityServiceRef ref) {
  final metaRepo = ref.watch(appMetaRepositoryProvider);
  return SecurityService(
    secureStorage: const FlutterSecureStorage(), 
    metaRepo: metaRepo,
  );
}
@Riverpod(keepAlive: true)
ITagRepository tagRepository(TagRepositoryRef ref) {
  final db = ref.watch(databaseServiceProvider);
  return TagRepository(db);
}

@riverpod
Future<List<Tag>> allTags(AllTagsRef ref) async {
  final repo = ref.watch(tagRepositoryProvider);
  return repo.getAllTags();
}
