import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:phf/data/repositories/app_meta_repository.dart';
import 'package:phf/logic/services/security_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:talker/talker.dart';

import 'security_service_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FlutterSecureStorage>(),
  MockSpec<AppMetaRepository>(),
  MockSpec<Talker>(),
  MockSpec<LocalAuthentication>(),
])
void main() {
  late MockFlutterSecureStorage mockStorage;
  late MockAppMetaRepository mockMetaRepo;
  late MockTalker mockTalker;
  late MockLocalAuthentication mockLocalAuth;
  late SecurityService securityService;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    mockMetaRepo = MockAppMetaRepository();
    mockTalker = MockTalker();
    mockLocalAuth = MockLocalAuthentication();
    securityService = SecurityService(
      secureStorage: mockStorage,
      metaRepo: mockMetaRepo,
      talker: mockTalker,
      localAuth: mockLocalAuth,
    );
  });

  group('SecurityService', () {
    const pin = '123456';

    test('setPin should hash and store PIN', () async {
      await securityService.setPin(pin);

      verify(mockStorage.write(key: 'user_pin_hash', value: anyNamed('value')))
          .called(1);
      verify(mockMetaRepo.setHasLock(true)).called(1);
    });

    test('validatePin should return true for correct PIN', () async {
      when(mockStorage.read(key: 'user_pin_hash')).thenAnswer(
        (_) async =>
            '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92',
      ); // SHA256 of 123456

      final isValid = await securityService.validatePin(pin);
      expect(isValid, isTrue);
    });

    test('changePin should update PIN only if old PIN is valid', () async {
      when(mockStorage.read(key: 'user_pin_hash')).thenAnswer(
        (_) async =>
            '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92',
      ); // 123456

      final success = await securityService.changePin(pin, '654321');
      expect(success, isTrue);
      verify(mockStorage.write(key: 'user_pin_hash', value: anyNamed('value')))
          .called(1);
    });

    test('enableBiometrics should store flag on success', () async {
      // ignore: deprecated_member_use
      when(mockLocalAuth.authenticate(
        localizedReason: anyNamed('localizedReason'),
        // ignore: deprecated_member_use
        biometricOnly: anyNamed('biometricOnly'),
      )).thenAnswer((_) async => true);

      final result = await securityService.enableBiometrics();
      expect(result, isTrue);
      verify(mockStorage.write(key: 'biometrics_enabled', value: 'true'))
          .called(1);
    });
  });
}
