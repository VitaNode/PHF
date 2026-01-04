// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// # CurrentUser Provider
///
/// ## Description
/// Returns the current active user (Person).
/// For Phase 1, this returns the default user.

@ProviderFor(CurrentUser)
final currentUserProvider = CurrentUserProvider._();

/// # CurrentUser Provider
///
/// ## Description
/// Returns the current active user (Person).
/// For Phase 1, this returns the default user.
final class CurrentUserProvider
    extends $AsyncNotifierProvider<CurrentUser, Person?> {
  /// # CurrentUser Provider
  ///
  /// ## Description
  /// Returns the current active user (Person).
  /// For Phase 1, this returns the default user.
  CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  CurrentUser create() => CurrentUser();
}

String _$currentUserHash() => r'c9a3e0218d6ae8fedc9ac3e2131ef8833eda6202';

/// # CurrentUser Provider
///
/// ## Description
/// Returns the current active user (Person).
/// For Phase 1, this returns the default user.

abstract class _$CurrentUser extends $AsyncNotifier<Person?> {
  FutureOr<Person?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Person?>, Person?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Person?>, Person?>,
              AsyncValue<Person?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
