import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/core/network/api_interceptor.dart';
import 'package:suchigo_app/core/storage/secure_storage.dart';

class MockSecureStorage extends Mock implements SecureStorage {}

void main() {
  late MockSecureStorage mockStorage;
  late ApiInterceptor interceptor;

  setUp(() {
    mockStorage = MockSecureStorage();
    interceptor = ApiInterceptor(secureStorage: mockStorage);
  });

  group('ApiInterceptor - attachAuthHeader', () {
    test('attaches Token header when token exists in storage', () async {
      when(() => mockStorage.getToken())
          .thenAnswer((_) async => const Success('abc123'));

      final headers = <String, String>{};
      final result = await interceptor.attachAuthHeader(headers);

      expect(result.isSuccess, isTrue);
      expect(headers['Authorization'], 'Token abc123');
    });

    test('returns Failure(TokenNotFoundError) when no token stored', () async {
      when(() => mockStorage.getToken())
          .thenAnswer((_) async => Failure(TokenNotFoundError()));

      final headers = <String, String>{};
      final result = await interceptor.attachAuthHeader(headers);

      expect(result.isFailure, isTrue);
      expect((result as Failure).error, isA<TokenNotFoundError>());
      expect(headers.containsKey('Authorization'), isFalse);
    });

    test('returns Failure(SecureStorageError) when storage throws', () async {
      when(() => mockStorage.getToken()).thenAnswer(
        (_) async => Failure(SecureStorageError(cause: 'Keychain locked')),
      );

      final headers = <String, String>{};
      final result = await interceptor.attachAuthHeader(headers);

      expect(result.isFailure, isTrue);
      expect((result as Failure).error, isA<SecureStorageError>());
    });

    test('does not overwrite existing headers', () async {
      when(() => mockStorage.getToken())
          .thenAnswer((_) async => const Success('tokenXYZ'));

      final headers = <String, String>{'Content-Type': 'application/json'};
      await interceptor.attachAuthHeader(headers);

      expect(headers['Content-Type'], 'application/json');
      expect(headers['Authorization'], 'Token tokenXYZ');
    });
  });

  group('ApiInterceptor - handle401', () {
    test('clears all secure storage on 401', () async {
      when(() => mockStorage.clearAll())
          .thenAnswer((_) async => const Success(null));

      await interceptor.handle401();

      verify(() => mockStorage.clearAll()).called(1);
    });

    test('calls onSessionExpired callback when provided', () async {
      when(() => mockStorage.clearAll())
          .thenAnswer((_) async => const Success(null));

      var callbackInvoked = false;
      final interceptorWithCallback = ApiInterceptor(
        secureStorage: mockStorage,
        onSessionExpired: () => callbackInvoked = true,
      );

      await interceptorWithCallback.handle401();

      expect(callbackInvoked, isTrue);
    });

    test('does not throw when onSessionExpired is null', () async {
      when(() => mockStorage.clearAll())
          .thenAnswer((_) async => const Success(null));

      expect(() async => interceptor.handle401(), returnsNormally);
    });
  });
}
