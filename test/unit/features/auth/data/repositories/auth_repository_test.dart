import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/core/storage/secure_storage.dart';
import 'package:suchigo_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:suchigo_app/features/auth/data/models/auth_requests.dart';
import 'package:suchigo_app/features/auth/data/models/user_model.dart';
import 'package:suchigo_app/features/auth/data/repositories/auth_repository.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}
class MockSecureStorage extends Mock implements SecureStorage {}
class FakeLoginRequest extends Fake implements LoginRequest {}

void main() {
  late MockAuthRemoteDataSource mockDataSource;
  late MockSecureStorage mockStorage;
  late AuthRepository repository;

  setUpAll(() {
    registerFallbackValue(FakeLoginRequest());
  });

  setUp(() {
    mockDataSource = MockAuthRemoteDataSource();
    mockStorage = MockSecureStorage();
    repository = AuthRepository(
      remoteDataSource: mockDataSource,
      secureStorage: mockStorage,
    );
  });

  group('AuthRepository', () {
    const testUser = UserModel(id: '1', username: 'test', email: 'test@t.com');

    test('login saves token and fetches profile on success', () async {
      when(() => mockDataSource.login(any())).thenAnswer((_) async => const Success({'token': 'jwt_123'}));
      when(() => mockStorage.saveToken('jwt_123')).thenAnswer((_) async => const Success(null));
      when(() => mockDataSource.fetchProfile()).thenAnswer((_) async => const Success(testUser));

      final result = await repository.login(const LoginRequest(username: 'u', password: 'p'));

      expect(result.isSuccess, isTrue);
      expect((result as Success<UserModel>).data, testUser);
      verify(() => mockStorage.saveToken('jwt_123')).called(1);
    });

    test('login returns Failure if no token is in response', () async {
      when(() => mockDataSource.login(any())).thenAnswer((_) async => const Success({'other': 'data'}));

      final result = await repository.login(const LoginRequest(username: 'u', password: 'p'));

      expect(result.isFailure, isTrue);
      expect((result as Failure).error, isA<ParseError>());
      verifyNever(() => mockStorage.saveToken(any()));
    });

    test('restoreSession fetches profile if token exists', () async {
      when(() => mockStorage.getToken()).thenAnswer((_) async => const Success('jwt_123'));
      when(() => mockDataSource.fetchProfile()).thenAnswer((_) async => const Success(testUser));

      final result = await repository.restoreSession();

      expect(result.isSuccess, isTrue);
      expect((result as Success<UserModel>).data, testUser);
    });

    test('restoreSession returns Failure if token is missing', () async {
      when(() => mockStorage.getToken()).thenAnswer((_) async => Failure(TokenNotFoundError()));

      final result = await repository.restoreSession();

      expect(result.isFailure, isTrue);
      expect((result as Failure).error, isA<TokenNotFoundError>());
      verifyNever(() => mockDataSource.fetchProfile());
    });

    test('logout clears secure storage', () async {
      when(() => mockStorage.clearAll()).thenAnswer((_) async => const Success(null));

      await repository.logout();

      verify(() => mockStorage.clearAll()).called(1);
    });
  });
}
