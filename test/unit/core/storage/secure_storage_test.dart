import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/core/storage/secure_storage.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late SecureStorage secureStorage;
  late MockFlutterSecureStorage mockStorage;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    secureStorage = SecureStorage(storage: mockStorage);
  });

  group('SecureStorage - Token Operations', () {
    const testToken = 'jwt_token_123';

    test('saveToken returns Success on successful write', () async {
      when(() => mockStorage.write(key: 'auth_token', value: testToken))
          .thenAnswer((_) async {});

      final result = await secureStorage.saveToken(testToken);

      expect(result.isSuccess, isTrue);
      verify(() => mockStorage.write(key: 'auth_token', value: testToken)).called(1);
    });

    test('saveToken returns Failure when write throws', () async {
      when(() => mockStorage.write(key: 'auth_token', value: testToken))
          .thenThrow(Exception('Platform Exception'));

      final result = await secureStorage.saveToken(testToken);

      expect(result.isFailure, isTrue);
      expect((result as Failure).error, isA<SecureStorageError>());
    });

    test('getToken returns Success when token exists', () async {
      when(() => mockStorage.read(key: 'auth_token'))
          .thenAnswer((_) async => testToken);

      final result = await secureStorage.getToken();

      expect(result.isSuccess, isTrue);
      expect((result as Success).data, testToken);
    });

    test('getToken returns Failure(TokenNotFoundError) when token is null', () async {
      when(() => mockStorage.read(key: 'auth_token'))
          .thenAnswer((_) async => null);

      final result = await secureStorage.getToken();

      expect(result.isFailure, isTrue);
      expect((result as Failure).error, isA<TokenNotFoundError>());
    });

    test('deleteToken returns Success', () async {
      when(() => mockStorage.delete(key: 'auth_token'))
          .thenAnswer((_) async {});

      final result = await secureStorage.deleteToken();

      expect(result.isSuccess, isTrue);
      verify(() => mockStorage.delete(key: 'auth_token')).called(1);
    });
  });

  group('SecureStorage - Lifecycle', () {
    test('clearAll returns Success', () async {
      when(() => mockStorage.deleteAll()).thenAnswer((_) async {});

      final result = await secureStorage.clearAll();

      expect(result.isSuccess, isTrue);
      verify(() => mockStorage.deleteAll()).called(1);
    });
  });
}
