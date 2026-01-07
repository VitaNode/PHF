import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phf/logic/providers/auth_provider.dart';
import 'package:phf/logic/providers/core_providers.dart';
import 'package:phf/data/repositories/app_meta_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter/material.dart';

@GenerateNiceMocks([MockSpec<AppMetaRepository>()])
import 'auth_provider_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockAppMetaRepository mockRepo;
  late ProviderContainer container;

  setUp(() {
    mockRepo = MockAppMetaRepository();
    container = ProviderContainer(
      overrides: [appMetaRepositoryProvider.overrideWithValue(mockRepo)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('AuthStateController initial state is locked', () {
    final state = container.read(authStateControllerProvider);
    expect(state, isTrue);
  });

  test('unlock sets state to false', () {
    final notifier = container.read(authStateControllerProvider.notifier);
    notifier.unlock();
    expect(container.read(authStateControllerProvider), isFalse);
  });

  test('lock sets state to true', () {
    final notifier = container.read(authStateControllerProvider.notifier);
    notifier.unlock(); // first unlock
    notifier.lock();
    expect(container.read(authStateControllerProvider), isTrue);
  });

  test(
    'didChangeAppLifecycleState paused then resumed within timeout does not lock',
    () async {
      final notifier = container.read(authStateControllerProvider.notifier);
      notifier.unlock();
      expect(container.read(authStateControllerProvider), isFalse);

      when(mockRepo.getLockTimeout()).thenAnswer((_) async => 60);

      // Pause
      notifier.didChangeAppLifecycleState(AppLifecycleState.paused);

      // Wait less than 60s (mocked by time or just calling resumed)
      // In our implementation, we use DateTime.now(), so we can't easily control time without mocking it.
      // But we can test the logic by calling it.

      notifier.didChangeAppLifecycleState(AppLifecycleState.resumed);
      // Should still be false because it was immediate
      expect(container.read(authStateControllerProvider), isFalse);
    },
  );

  test(
    'didChangeAppLifecycleState paused then resumed after timeout locks',
    () async {
      final notifier = container.read(authStateControllerProvider.notifier);
      notifier.unlock();

      when(
        mockRepo.getLockTimeout(),
      ).thenAnswer((_) async => 0); // Immediate lock

      // Pause
      notifier.didChangeAppLifecycleState(AppLifecycleState.paused);

      // We need to wait a bit because _handleImmediateLock is unawaited
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(container.read(authStateControllerProvider), isTrue);
    },
  );
}
