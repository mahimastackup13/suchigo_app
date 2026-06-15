import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/features/profile/data/models/profile_model.dart';
import 'package:suchigo_app/features/profile/data/repositories/profile_repository.dart';
import 'package:suchigo_app/features/profile/presentation/providers/profile_notifier.dart';
import 'package:suchigo_app/features/profile/presentation/providers/profile_providers.dart';
import 'package:suchigo_app/features/profile/presentation/states/profile_state.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository mockRepository;

  final tProfile = const ProfileModel(
    id: 'uid123',
    name: 'Test',
    email: 'test@example.com',
    phone: '1234567890',
    wardId: 1,
  );

  setUp(() {
    mockRepository = MockProfileRepository();
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        profileRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('initial state is ProfileLoading', () {
    when(() => mockRepository.getProfile(forceRefresh: false))
        .thenAnswer((_) async => Success(tProfile));
    
    final container = createContainer();
    final state = container.read(profileProvider);
    
    expect(state, isA<ProfileLoading>());
  });

  test('emits ProfileLoaded on success', () async {
    when(() => mockRepository.getProfile(forceRefresh: false))
        .thenAnswer((_) async => Success(tProfile));

    final container = createContainer();
    
    // Wait for the microtask from build() to finish
    await container.read(profileProvider.notifier).loadProfile();
    
    final state = container.read(profileProvider);
    expect(state, isA<ProfileLoaded>());
    expect((state as ProfileLoaded).profile, tProfile);
  });

  test('emits ProfileError on failure', () async {
    final tError = ServerError(statusCode: 500);
    when(() => mockRepository.getProfile(forceRefresh: false))
        .thenAnswer((_) async => Failure(tError));

    final container = createContainer();
    
    await container.read(profileProvider.notifier).loadProfile();
    
    final state = container.read(profileProvider);
    expect(state, isA<ProfileError>());
    expect((state as ProfileError).error, tError);
  });
}
