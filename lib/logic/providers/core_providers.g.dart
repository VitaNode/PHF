// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'core_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(pathProviderService)
final pathProviderServiceProvider = PathProviderServiceProvider._();

final class PathProviderServiceProvider
    extends
        $FunctionalProvider<
          PathProviderService,
          PathProviderService,
          PathProviderService
        >
    with $Provider<PathProviderService> {
  PathProviderServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pathProviderServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pathProviderServiceHash();

  @$internal
  @override
  $ProviderElement<PathProviderService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PathProviderService create(Ref ref) {
    return pathProviderService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PathProviderService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PathProviderService>(value),
    );
  }
}

String _$pathProviderServiceHash() =>
    r'8ac5e6419686ea0b5a2cbab77944595dac2111b7';

@ProviderFor(permissionService)
final permissionServiceProvider = PermissionServiceProvider._();

final class PermissionServiceProvider
    extends
        $FunctionalProvider<
          PermissionService,
          PermissionService,
          PermissionService
        >
    with $Provider<PermissionService> {
  PermissionServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'permissionServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$permissionServiceHash();

  @$internal
  @override
  $ProviderElement<PermissionService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PermissionService create(Ref ref) {
    return permissionService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PermissionService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PermissionService>(value),
    );
  }
}

String _$permissionServiceHash() => r'c2d80eefe41d876497606e2f7f35e68b50a5d1d7';

@ProviderFor(masterKeyManager)
final masterKeyManagerProvider = MasterKeyManagerProvider._();

final class MasterKeyManagerProvider
    extends
        $FunctionalProvider<
          MasterKeyManager,
          MasterKeyManager,
          MasterKeyManager
        >
    with $Provider<MasterKeyManager> {
  MasterKeyManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'masterKeyManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$masterKeyManagerHash();

  @$internal
  @override
  $ProviderElement<MasterKeyManager> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MasterKeyManager create(Ref ref) {
    return masterKeyManager(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MasterKeyManager value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MasterKeyManager>(value),
    );
  }
}

String _$masterKeyManagerHash() => r'baa610668f63a9468e933fa5de2e59faceeebbae';

@ProviderFor(databaseService)
final databaseServiceProvider = DatabaseServiceProvider._();

final class DatabaseServiceProvider
    extends
        $FunctionalProvider<
          SQLCipherDatabaseService,
          SQLCipherDatabaseService,
          SQLCipherDatabaseService
        >
    with $Provider<SQLCipherDatabaseService> {
  DatabaseServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'databaseServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$databaseServiceHash();

  @$internal
  @override
  $ProviderElement<SQLCipherDatabaseService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SQLCipherDatabaseService create(Ref ref) {
    return databaseService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SQLCipherDatabaseService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SQLCipherDatabaseService>(value),
    );
  }
}

String _$databaseServiceHash() => r'4a6397efd932ef53bd6e69e8e7484d7973edaae7';

@ProviderFor(fileSecurityHelper)
final fileSecurityHelperProvider = FileSecurityHelperProvider._();

final class FileSecurityHelperProvider
    extends
        $FunctionalProvider<
          FileSecurityHelper,
          FileSecurityHelper,
          FileSecurityHelper
        >
    with $Provider<FileSecurityHelper> {
  FileSecurityHelperProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fileSecurityHelperProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fileSecurityHelperHash();

  @$internal
  @override
  $ProviderElement<FileSecurityHelper> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FileSecurityHelper create(Ref ref) {
    return fileSecurityHelper(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FileSecurityHelper value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FileSecurityHelper>(value),
    );
  }
}

String _$fileSecurityHelperHash() =>
    r'7a59118c3f9947841c7b1aad42e9983e627f4893';

@ProviderFor(imageProcessingService)
final imageProcessingServiceProvider = ImageProcessingServiceProvider._();

final class ImageProcessingServiceProvider
    extends $FunctionalProvider<IImageService, IImageService, IImageService>
    with $Provider<IImageService> {
  ImageProcessingServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'imageProcessingServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$imageProcessingServiceHash();

  @$internal
  @override
  $ProviderElement<IImageService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IImageService create(Ref ref) {
    return imageProcessingService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IImageService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IImageService>(value),
    );
  }
}

String _$imageProcessingServiceHash() =>
    r'943c0f3a5709deb4ed8ee118e51fff82d50c6c62';

@ProviderFor(galleryService)
final galleryServiceProvider = GalleryServiceProvider._();

final class GalleryServiceProvider
    extends
        $FunctionalProvider<IGalleryService, IGalleryService, IGalleryService>
    with $Provider<IGalleryService> {
  GalleryServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'galleryServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$galleryServiceHash();

  @$internal
  @override
  $ProviderElement<IGalleryService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IGalleryService create(Ref ref) {
    return galleryService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IGalleryService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IGalleryService>(value),
    );
  }
}

String _$galleryServiceHash() => r'c27c171329bb2a913915c82476b8287feacbbc3f';

@ProviderFor(recordRepository)
final recordRepositoryProvider = RecordRepositoryProvider._();

final class RecordRepositoryProvider
    extends
        $FunctionalProvider<
          IRecordRepository,
          IRecordRepository,
          IRecordRepository
        >
    with $Provider<IRecordRepository> {
  RecordRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recordRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recordRepositoryHash();

  @$internal
  @override
  $ProviderElement<IRecordRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IRecordRepository create(Ref ref) {
    return recordRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IRecordRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IRecordRepository>(value),
    );
  }
}

String _$recordRepositoryHash() => r'3b95d841fbeb3f7e7f393f32f0ca6927bfed267f';

@ProviderFor(cryptoService)
final cryptoServiceProvider = CryptoServiceProvider._();

final class CryptoServiceProvider
    extends $FunctionalProvider<ICryptoService, ICryptoService, ICryptoService>
    with $Provider<ICryptoService> {
  CryptoServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cryptoServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cryptoServiceHash();

  @$internal
  @override
  $ProviderElement<ICryptoService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ICryptoService create(Ref ref) {
    return cryptoService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ICryptoService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ICryptoService>(value),
    );
  }
}

String _$cryptoServiceHash() => r'7bf1c14754df33bf2bac1d9430f02e51b3c70e8d';

@ProviderFor(backupService)
final backupServiceProvider = BackupServiceProvider._();

final class BackupServiceProvider
    extends $FunctionalProvider<IBackupService, IBackupService, IBackupService>
    with $Provider<IBackupService> {
  BackupServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backupServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backupServiceHash();

  @$internal
  @override
  $ProviderElement<IBackupService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IBackupService create(Ref ref) {
    return backupService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IBackupService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IBackupService>(value),
    );
  }
}

String _$backupServiceHash() => r'986170c730f3b2cd420e42abea7a80dee1c8ec68';

@ProviderFor(imageRepository)
final imageRepositoryProvider = ImageRepositoryProvider._();

final class ImageRepositoryProvider
    extends
        $FunctionalProvider<
          IImageRepository,
          IImageRepository,
          IImageRepository
        >
    with $Provider<IImageRepository> {
  ImageRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'imageRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$imageRepositoryHash();

  @$internal
  @override
  $ProviderElement<IImageRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IImageRepository create(Ref ref) {
    return imageRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IImageRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IImageRepository>(value),
    );
  }
}

String _$imageRepositoryHash() => r'a818f6f215615efc5cc70caac9292da693082327';

@ProviderFor(personRepository)
final personRepositoryProvider = PersonRepositoryProvider._();

final class PersonRepositoryProvider
    extends
        $FunctionalProvider<
          IPersonRepository,
          IPersonRepository,
          IPersonRepository
        >
    with $Provider<IPersonRepository> {
  PersonRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'personRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$personRepositoryHash();

  @$internal
  @override
  $ProviderElement<IPersonRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IPersonRepository create(Ref ref) {
    return personRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IPersonRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IPersonRepository>(value),
    );
  }
}

String _$personRepositoryHash() => r'3e777378932b2ac4e9af168b9a23aa91e14631bf';

@ProviderFor(appMetaRepository)
final appMetaRepositoryProvider = AppMetaRepositoryProvider._();

final class AppMetaRepositoryProvider
    extends
        $FunctionalProvider<
          AppMetaRepository,
          AppMetaRepository,
          AppMetaRepository
        >
    with $Provider<AppMetaRepository> {
  AppMetaRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appMetaRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appMetaRepositoryHash();

  @$internal
  @override
  $ProviderElement<AppMetaRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AppMetaRepository create(Ref ref) {
    return appMetaRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppMetaRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppMetaRepository>(value),
    );
  }
}

String _$appMetaRepositoryHash() => r'e9091b67401ef415be39f15a9daf4ab9414b92ed';

@ProviderFor(securityService)
final securityServiceProvider = SecurityServiceProvider._();

final class SecurityServiceProvider
    extends
        $FunctionalProvider<SecurityService, SecurityService, SecurityService>
    with $Provider<SecurityService> {
  SecurityServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'securityServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$securityServiceHash();

  @$internal
  @override
  $ProviderElement<SecurityService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SecurityService create(Ref ref) {
    return securityService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SecurityService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SecurityService>(value),
    );
  }
}

String _$securityServiceHash() => r'8e7036d7cc50758efc34fb8f19faec6a1cdeefd8';

@ProviderFor(tagRepository)
final tagRepositoryProvider = TagRepositoryProvider._();

final class TagRepositoryProvider
    extends $FunctionalProvider<ITagRepository, ITagRepository, ITagRepository>
    with $Provider<ITagRepository> {
  TagRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tagRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tagRepositoryHash();

  @$internal
  @override
  $ProviderElement<ITagRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ITagRepository create(Ref ref) {
    return tagRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ITagRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ITagRepository>(value),
    );
  }
}

String _$tagRepositoryHash() => r'93305b9c45a923381656be0c101fcbd6339d8d48';

@ProviderFor(searchRepository)
final searchRepositoryProvider = SearchRepositoryProvider._();

final class SearchRepositoryProvider
    extends
        $FunctionalProvider<
          ISearchRepository,
          ISearchRepository,
          ISearchRepository
        >
    with $Provider<ISearchRepository> {
  SearchRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchRepositoryHash();

  @$internal
  @override
  $ProviderElement<ISearchRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ISearchRepository create(Ref ref) {
    return searchRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ISearchRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ISearchRepository>(value),
    );
  }
}

String _$searchRepositoryHash() => r'1fcc9063bbf4a2b83823d515e9c69d41088307f6';

@ProviderFor(ocrQueueRepository)
final ocrQueueRepositoryProvider = OcrQueueRepositoryProvider._();

final class OcrQueueRepositoryProvider
    extends
        $FunctionalProvider<
          IOCRQueueRepository,
          IOCRQueueRepository,
          IOCRQueueRepository
        >
    with $Provider<IOCRQueueRepository> {
  OcrQueueRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ocrQueueRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ocrQueueRepositoryHash();

  @$internal
  @override
  $ProviderElement<IOCRQueueRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IOCRQueueRepository create(Ref ref) {
    return ocrQueueRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IOCRQueueRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IOCRQueueRepository>(value),
    );
  }
}

String _$ocrQueueRepositoryHash() =>
    r'4aae7f48301a7a6107e82afcbf09f45dfc4036df';

@ProviderFor(allTags)
final allTagsProvider = AllTagsProvider._();

final class AllTagsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Tag>>,
          List<Tag>,
          FutureOr<List<Tag>>
        >
    with $FutureModifier<List<Tag>>, $FutureProvider<List<Tag>> {
  AllTagsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allTagsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allTagsHash();

  @$internal
  @override
  $FutureProviderElement<List<Tag>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Tag>> create(Ref ref) {
    return allTags(ref);
  }
}

String _$allTagsHash() => r'b59a84310ef7b42ada4934bb728d8e7fad886721';
