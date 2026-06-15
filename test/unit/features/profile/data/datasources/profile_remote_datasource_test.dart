import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/core/network/api_client.dart';
import 'package:suchigo_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:suchigo_app/features/profile/data/models/profile_model.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late ProfileRemoteDataSource dataSource;
  late MockApiClient mockApiClient;

  setUpAll(() {
    registerFallbackValue(Uri.parse('http://example.com'));
  });

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = ProfileRemoteDataSource(apiClient: mockApiClient);
  });

  group('fetchProfile', () {
    test('returns Success<ProfileModel> on valid API response', () async {
      final tResponse = {
        'id': '1',
        'name': 'Test User',
        'email': 'test@example.com',
        'phone': '1234567890',
        'ward_id': 5,
      };

      when(() => mockApiClient.get(any(), requiresAuth: true, retry: true))
          .thenAnswer((_) async => Success(tResponse));

      final result = await dataSource.fetchProfile();

      expect(result, isA<Success<ProfileModel>>());
      expect((result as Success<ProfileModel>).data.name, 'Test User');
    });

    test('returns original Failure on network error', () async {
      final tError = ServerError(statusCode: 500);
      when(() => mockApiClient.get(any(), requiresAuth: true, retry: true))
          .thenAnswer((_) async => Failure(tError));

      final result = await dataSource.fetchProfile();

      expect(result, isA<Failure>());
      expect((result as Failure).error, tError);
    });
  });
}
