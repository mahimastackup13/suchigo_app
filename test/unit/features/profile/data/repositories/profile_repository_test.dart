import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:suchigo_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:suchigo_app/features/profile/data/models/profile_model.dart';
import 'package:suchigo_app/features/profile/data/repositories/profile_repository.dart';

class MockRemoteDataSource extends Mock implements ProfileRemoteDataSource {}
class MockLocalDataSource extends Mock implements ProfileLocalDataSource {}

void main() {
  late ProfileRepository repository;
  late MockRemoteDataSource mockRemote;
  late MockLocalDataSource mockLocal;

  final tProfile = const ProfileModel(
    id: 'uid123',
    name: 'Test',
    email: 'test@example.com',
    phone: '1234567890',
    wardId: 1,
  );

  setUp(() {
    mockRemote = MockRemoteDataSource();
    mockLocal = MockLocalDataSource();
    repository = ProfileRepository(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
    );
  });

  group('getProfile', () {
    test('returns remote profile and caches it when network is successful', () async {
      when(() => mockRemote.fetchProfile()).thenAnswer((_) async => Success(tProfile));
      when(() => mockLocal.cacheProfile(tProfile)).thenAnswer((_) async => const Success(null));

      final result = await repository.getProfile();

      expect(result, isA<Success<ProfileModel>>());
      verify(() => mockRemote.fetchProfile()).called(1);
      verify(() => mockLocal.cacheProfile(tProfile)).called(1);
    });

    test('returns local profile when network fails with NoInternetError', () async {
      final tError = NoInternetError();
      when(() => mockRemote.fetchProfile()).thenAnswer((_) async => Failure(tError));
      when(() => mockLocal.getCachedProfile()).thenAnswer((_) async => Success(tProfile));

      final result = await repository.getProfile();

      expect(result, isA<Success<ProfileModel>>());
      verify(() => mockRemote.fetchProfile()).called(1);
      verify(() => mockLocal.getCachedProfile()).called(1);
    });

    test('returns original failure when network fails with ServerError and cache is empty', () async {
      final tError = ServerError(statusCode: 500);
      when(() => mockRemote.fetchProfile()).thenAnswer((_) async => Failure(tError));
      when(() => mockLocal.getCachedProfile()).thenAnswer((_) async => Failure(DbReadError(cause: 'Empty')));

      final result = await repository.getProfile();

      expect(result, isA<Failure>());
      expect((result as Failure).error, tError);
    });
  });
}
