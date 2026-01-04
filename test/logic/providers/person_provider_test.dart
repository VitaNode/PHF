import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phf/data/repositories/interfaces/person_repository.dart';
import 'package:phf/data/repositories/app_meta_repository.dart';
import 'package:phf/data/models/person.dart';
import 'package:phf/logic/providers/core_providers.dart';
import 'package:phf/logic/providers/person_provider.dart';

@GenerateNiceMocks([
  MockSpec<IPersonRepository>(),
  MockSpec<AppMetaRepository>(),
])
import 'person_provider_test.mocks.dart';

void main() {
  late MockIPersonRepository mockPersonRepo;
  late MockAppMetaRepository mockMetaRepo;

  setUp(() {
    mockPersonRepo = MockIPersonRepository();
    mockMetaRepo = MockAppMetaRepository();
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        personRepositoryProvider.overrideWithValue(mockPersonRepo),
        appMetaRepositoryProvider.overrideWithValue(mockMetaRepo),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('PersonProvider Tests', () {
    test(
      'currentPersonIdController build returns saved ID if exists',
      () async {
        when(mockMetaRepo.getCurrentPersonId()).thenAnswer((_) async => 'p1');

        final container = createContainer();
        final id = await container.read(
          currentPersonIdControllerProvider.future,
        );

        expect(id, 'p1');
        verify(mockMetaRepo.getCurrentPersonId()).called(1);
      },
    );

    test(
      'currentPersonIdController build returns default person if no saved ID',
      () async {
        when(mockMetaRepo.getCurrentPersonId()).thenAnswer((_) async => null);
        final persons = [
          Person(
            id: 'p1',
            nickname: 'P1',
            createdAt: DateTime.now(),
            isDefault: false,
          ),
          Person(
            id: 'me',
            nickname: 'Me',
            createdAt: DateTime.now(),
            isDefault: true,
          ),
        ];
        when(mockPersonRepo.getAllPersons()).thenAnswer((_) async => persons);

        final container = createContainer();
        final id = await container.read(
          currentPersonIdControllerProvider.future,
        );

        expect(id, 'me');
      },
    );

    test('selectPerson updates state and repo', () async {
      when(mockMetaRepo.getCurrentPersonId()).thenAnswer((_) async => 'p1');

      final container = createContainer();
      await container
          .read(currentPersonIdControllerProvider.notifier)
          .selectPerson('p2');

      final id = await container.read(currentPersonIdControllerProvider.future);
      expect(id, 'p2');
      verify(mockMetaRepo.setCurrentPersonId('p2')).called(1);
    });

    test('currentPerson returns full person entity', () async {
      when(mockMetaRepo.getCurrentPersonId()).thenAnswer((_) async => 'me');
      final person = Person(
        id: 'me',
        nickname: 'Me',
        createdAt: DateTime.now(),
        isDefault: true,
      );
      when(mockPersonRepo.getAllPersons()).thenAnswer((_) async => [person]);

      final container = createContainer();
      final current = await container.read(currentPersonProvider.future);

      expect(current?.id, 'me');
      expect(current?.nickname, 'Me');
    });
  });
}
