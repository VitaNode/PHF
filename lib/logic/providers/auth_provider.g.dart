// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(hasLock)
final hasLockProvider = HasLockProvider._();

final class HasLockProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  HasLockProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'hasLockProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$hasLockHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return hasLock(ref);
  }
}

String _$hasLockHash() => r'e67d146f32cfeeb365ccda93bee351016d7e9ed7';

@ProviderFor(AuthStateController)
final authStateControllerProvider = AuthStateControllerProvider._();

final class AuthStateControllerProvider
    extends $NotifierProvider<AuthStateController, bool> {
  AuthStateControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'authStateControllerProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$authStateControllerHash();

  @$internal
  @override
  AuthStateController create() => AuthStateController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$authStateControllerHash() =>
    r'58932b92492625c9e0a665ea3be992f8ff80953b';

abstract class _$AuthStateController extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<bool, bool>, bool, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
