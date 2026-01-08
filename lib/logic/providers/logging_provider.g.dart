// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logging_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(encryptedLogService)
final encryptedLogServiceProvider = EncryptedLogServiceProvider._();

final class EncryptedLogServiceProvider
    extends
        $FunctionalProvider<
          EncryptedLogService,
          EncryptedLogService,
          EncryptedLogService
        >
    with $Provider<EncryptedLogService> {
  EncryptedLogServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'encryptedLogServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$encryptedLogServiceHash();

  @$internal
  @override
  $ProviderElement<EncryptedLogService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EncryptedLogService create(Ref ref) {
    return encryptedLogService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EncryptedLogService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EncryptedLogService>(value),
    );
  }
}

String _$encryptedLogServiceHash() =>
    r'307822e44c128b4d54d8882b1af34d58e312a50f';

@ProviderFor(talker)
final talkerProvider = TalkerProvider._();

final class TalkerProvider extends $FunctionalProvider<Talker, Talker, Talker>
    with $Provider<Talker> {
  TalkerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'talkerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$talkerHash();

  @$internal
  @override
  $ProviderElement<Talker> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Talker create(Ref ref) {
    return talker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Talker value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Talker>(value),
    );
  }
}

String _$talkerHash() => r'db58250700350e300f5a1d0edcd4948b46d1291f';
