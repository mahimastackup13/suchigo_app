import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/core/network/api_client.dart';
import 'package:suchigo_app/core/network/api_interceptor.dart';
import 'package:suchigo_app/core/network/connectivity_service.dart';
import 'package:suchigo_app/core/storage/secure_storage.dart';

class MockSecureStorage extends Mock implements SecureStorage {}
class MockConnectivityService extends Mock implements ConnectivityService {}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

ApiClient _buildClient({
  required http.Client httpClient,
  String? token,
  bool storageThrows = false,
  bool isConnected = true,
  void Function()? onSessionExpired,
}) {
  final mockStorage = MockSecureStorage();
  final mockConnectivity = MockConnectivityService();

  when(() => mockConnectivity.isConnected).thenAnswer((_) async => isConnected);

  if (storageThrows) {
    when(() => mockStorage.getToken()).thenAnswer(
      (_) async => Failure(SecureStorageError(cause: 'Keychain unavailable')),
    );
  } else if (token != null) {
    when(() => mockStorage.getToken())
        .thenAnswer((_) async => Success(token));
  } else {
    when(() => mockStorage.getToken())
        .thenAnswer((_) async => Failure(TokenNotFoundError()));
  }

  when(() => mockStorage.clearAll()).thenAnswer((_) async => const Success(null));

  final interceptor = ApiInterceptor(
    secureStorage: mockStorage,
    onSessionExpired: onSessionExpired,
  );

  return ApiClient(
    httpClient: httpClient,
    interceptor: interceptor,
    connectivity: mockConnectivity,
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  final testUri = Uri.parse('https://example.com/api/resource/');

  group('ApiClient - GET success', () {
    test('GET returns Success with decoded JSON body', () async {
      final mockHttp = MockClient((_) async => http.Response(
            '{"id": 1, "name": "Test"}',
            200,
            headers: {'content-type': 'application/json'},
          ));

      final client = _buildClient(httpClient: mockHttp, token: 'valid_token');
      final result = await client.get(testUri);

      expect(result.isSuccess, isTrue);
      expect((result as Success).data['name'], 'Test');
    });

    test('GET with 204 No Content returns Success with empty map', () async {
      final mockHttp = MockClient((_) async => http.Response('', 204));

      final client = _buildClient(httpClient: mockHttp, token: 'valid_token');
      final result = await client.get(testUri);

      expect(result.isSuccess, isTrue);
      expect((result as Success).data, isEmpty);
    });
  });

  group('ApiClient - POST success', () {
    test('POST sends body and returns Success with decoded JSON', () async {
      late http.Request capturedRequest;

      final mockHttp = MockClient((request) async {
        capturedRequest = request;
        return http.Response('{"token": "jwt_xyz"}', 200);
      });

      final client = _buildClient(httpClient: mockHttp, token: 'valid_token');
      final result = await client.post(
        testUri,
        body: {'username': 'user1', 'password': 'pass1'},
      );

      expect(result.isSuccess, isTrue);
      expect((result as Success).data['token'], 'jwt_xyz');
      expect(capturedRequest.body, contains('username'));
    });
  });

  group('ApiClient - Auth header injection', () {
    test('requiresAuth=true attaches Authorization header', () async {
      late http.Request capturedRequest;

      final mockHttp = MockClient((request) async {
        capturedRequest = request;
        return http.Response('{}', 200);
      });

      final client =
          _buildClient(httpClient: mockHttp, token: 'my_secure_token');
      await client.get(testUri, requiresAuth: true);

      expect(
        capturedRequest.headers['Authorization'],
        'Token my_secure_token',
      );
    });

    test('requiresAuth=false does NOT attach Authorization header', () async {
      late http.Request capturedRequest;

      final mockHttp = MockClient((request) async {
        capturedRequest = request;
        return http.Response('{}', 200);
      });

      final client =
          _buildClient(httpClient: mockHttp, token: 'my_secure_token');
      await client.get(testUri, requiresAuth: false);

      expect(capturedRequest.headers.containsKey('Authorization'), isFalse);
    });

    test('requiresAuth=true with no token returns Failure(TokenNotFoundError)',
        () async {
      final mockHttp = MockClient((_) async => http.Response('{}', 200));

      // token: null → TokenNotFoundError
      final client = _buildClient(httpClient: mockHttp);
      final result = await client.get(testUri, requiresAuth: true);

      expect(result.isFailure, isTrue);
      expect((result as Failure).error, isA<TokenNotFoundError>());
    });
  });

  group('ApiClient - 401 handling', () {
    test('401 triggers onSessionExpired callback', () async {
      var sessionExpiredCalled = false;

      final mockHttp = MockClient((_) async => http.Response(
            '{"detail": "Invalid token."}',
            401,
          ));

      final client = _buildClient(
        httpClient: mockHttp,
        token: 'expired_token',
        onSessionExpired: () => sessionExpiredCalled = true,
      );

      final result = await client.get(testUri);

      expect(result.isFailure, isTrue);
      expect((result as Failure).error, isA<InvalidCredentialsError>());
      expect(sessionExpiredCalled, isTrue);
    });
  });

  group('ApiClient - Error handling', () {
    test('Fails fast with NoInternetError when connectivity is false', () async {
      final mockHttp = MockClient((_) async => http.Response('{}', 200));

      final client = _buildClient(
        httpClient: mockHttp,
        token: 'valid_token',
        isConnected: false,
      );
      final result = await client.get(testUri);

      expect(result.isFailure, isTrue);
      expect((result as Failure).error, isA<NoInternetError>());
    });

    test('TimeoutException returns Failure(TimeoutError)', () async {
      final mockHttp = MockClient((_) async {
        await Future.delayed(const Duration(seconds: 20));
        return http.Response('', 200);
      });

      final client = _buildClient(httpClient: mockHttp, token: 'valid_token');
      final result = await client
          .get(testUri)
          .timeout(const Duration(milliseconds: 100), onTimeout: () {
        return Failure(TimeoutError());
      });

      expect(result.isFailure, isTrue);
      expect((result as Failure).error, isA<TimeoutError>());
    });

    test('500 response returns Failure(ServerError)', () async {
      final mockHttp = MockClient(
          (_) async => http.Response('{"detail": "Server error"}', 500));

      final client = _buildClient(httpClient: mockHttp, token: 'valid_token');
      final result = await client.get(testUri);

      expect(result.isFailure, isTrue);
      expect((result as Failure).error, isA<ServerError>());
    });

    test('Malformed JSON body returns Failure(ParseError)', () async {
      final mockHttp = MockClient(
          (_) async => http.Response('not-valid-json', 200));

      final client = _buildClient(httpClient: mockHttp, token: 'valid_token');
      final result = await client.get(testUri);

      expect(result.isFailure, isTrue);
      expect((result as Failure).error, isA<ParseError>());
    });

    test('400 with field errors returns Failure(RegistrationError)', () async {
      final mockHttp = MockClient((_) async => http.Response(
            '{"username": ["A user with that username already exists."]}',
            400,
          ));

      final client = _buildClient(httpClient: mockHttp, token: 'valid_token');
      final result = await client.post(
        testUri,
        body: {'username': 'taken'},
      );

      expect(result.isFailure, isTrue);
      expect((result as Failure).error, isA<RegistrationError>());
    });
  });

  group('ApiClient - Retry policy', () {
    test('Retries on 500 error and eventually succeeds', () async {
      int attempts = 0;
      final mockHttp = MockClient((_) async {
        attempts++;
        if (attempts < 3) {
          return http.Response('Server Error', 500);
        }
        return http.Response('{"success": true}', 200);
      });

      final client = _buildClient(httpClient: mockHttp, token: 'valid_token');
      final result = await client.get(testUri, retry: true);

      expect(attempts, 3);
      expect(result.isSuccess, isTrue);
    });
  });
}
