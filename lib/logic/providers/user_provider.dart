import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/person.dart';
import 'core_providers.dart';

part 'user_provider.g.dart';

/// # CurrentUser Provider
///
/// ## Description
/// Returns the current active user (Person).
/// For Phase 1, this returns the default user.
@Riverpod(keepAlive: true)
class CurrentUser extends _$CurrentUser {
  @override
  FutureOr<Person?> build() async {
    final repo = ref.watch(personRepositoryProvider);
    return repo.getDefaultPerson();
  }
}
