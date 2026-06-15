import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/core/storage/local_db.dart';
import 'package:suchigo_app/core/storage/local_db_tables.dart';
import 'package:suchigo_app/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:suchigo_app/features/profile/data/models/profile_model.dart';

class MockLocalDb extends Mock implements LocalDb {}

void main() {
  late ProfileLocalDataSource dataSource;
  late MockLocalDb mockLocalDb;

  final tProfile = const ProfileModel(
    id: 'uid123',
    name: 'Test User',
    email: 'test@example.com',
    phone: '+919999999999',
    wardId: 1,
  );

  setUp(() {
    mockLocalDb = MockLocalDb();
    dataSource = ProfileLocalDataSource(localDb: mockLocalDb);
  });

  group('getCachedProfile', () {
    test('returns Success<ProfileModel> when data is found', () async {
      when(() => mockLocalDb.query(LocalDbTables.users, limit: 1))
          .thenAnswer((_) async => Success([tProfile.toLocalDbMap()]));

      final result = await dataSource.getCachedProfile();

      expect(result, isA<Success<ProfileModel>>());
      expect((result as Success<ProfileModel>).data.id, 'uid123');
    });

    test('returns Failure(DbReadError) when data is empty', () async {
      when(() => mockLocalDb.query(LocalDbTables.users, limit: 1))
          .thenAnswer((_) async => const Success([]));

      final result = await dataSource.getCachedProfile();

      expect(result, isA<Failure>());
      expect((result as Failure).error, isA<DbReadError>());
    });
  });

  group('cacheProfile', () {
    test('clears old and inserts new profile successfully', () async {
      when(() => mockLocalDb.delete(LocalDbTables.users, where: '1=1', whereArgs: []))
          .thenAnswer((_) async => const Success(1));
      when(() => mockLocalDb.insert(LocalDbTables.users, any()))
          .thenAnswer((_) async => const Success(1));

      final result = await dataSource.cacheProfile(tProfile);

      expect(result, isA<Success<void>>());
      verify(() => mockLocalDb.delete(LocalDbTables.users, where: '1=1', whereArgs: [])).called(1);
      verify(() => mockLocalDb.insert(LocalDbTables.users, any())).called(1);
    });
  });
}
