import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:phf/data/repositories/app_meta_repository.dart';
import 'package:phf/logic/services/security_service.dart';

@GenerateNiceMocks([
  MockSpec<FlutterSecureStorage>(),
  MockSpec<LocalAuthentication>(),
  MockSpec<AppMetaRepository>(),
])
import 'security_service_test.mocks.dart';

void main() {
  late MockFlutterSecureStorage mockStorage;
  late MockLocalAuthentication mockLocalAuth;
  late MockAppMetaRepository mockMetaRepo;
  late SecurityService securityService;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    mockLocalAuth = MockLocalAuthentication();
    mockMetaRepo = MockAppMetaRepository();
    securityService = SecurityService(
      secureStorage: mockStorage,
      localAuth: mockLocalAuth,
      metaRepo: mockMetaRepo,
    );
  });

  group('SecurityService', () {
    test('setPin should hash and store PIN', () async {
      await securityService.setPin('123456');

      verify(
        mockStorage.write(key: 'user_pin_hash', value: anyNamed('value')),
      ).called(1);
      verify(mockMetaRepo.setHasLock(true)).called(1);
    });

    test('validatePin should return true for correct PIN', () async {
      const pin = '123456';
      // Manual hash for '123456' or just let the service set it then mock read
      await securityService.setPin(pin);

      // We need to capture the hash or just mock return it
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
      );

      final success = await securityService.changePin('123456', '654321');
      expect(success, isTrue);
      verify(
        mockStorage.write(key: 'user_pin_hash', value: anyNamed('value')),
      ).called(1);

      final fail = await securityService.changePin('wrong', '000000');
      expect(fail, isFalse);
    });

    test('enableBiometrics should store flag on success', () async {
      // ignore: deprecated_member_use
      when(
        mockLocalAuth.authenticate(
          localizedReason: anyNamed('localizedReason'),
          // ignore: deprecated_member_use
          biometricOnly: true,
        ),
      ).thenAnswer((_) async => true);

      final success = await securityService.enableBiometrics();
      expect(success, isTrue);
      verify(
        mockStorage.write(key: 'biometrics_enabled', value: 'true'),
      ).called(1);
    });
  });
}
