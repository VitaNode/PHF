// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hasLockHash() => r'97c7f28599e68af60c7a7352a30b4bc0ad98812e';

/// See also [hasLock].
@ProviderFor(hasLock)
final hasLockProvider = FutureProvider<bool>.internal(
  hasLock,
  name: r'hasLockProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$hasLockHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HasLockRef = FutureProviderRef<bool>;
String _$authStateControllerHash() =>
    r'58932b92492625c9e0a665ea3be992f8ff80953b';

/// See also [AuthStateController].
@ProviderFor(AuthStateController)
final authStateControllerProvider =
    NotifierProvider<AuthStateController, bool>.internal(
  AuthStateController.new,
  name: r'authStateControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authStateControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthStateController = Notifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
