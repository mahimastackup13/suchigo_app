import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/features/auth/data/models/user_model.dart';
import 'package:suchigo_app/features/auth/data/repositories/auth_repository.dart';
import 'package:suchigo_app/features/auth/presentation/providers/auth_notifier.dart';
import 'package:suchigo_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:suchigo_app/features/auth/presentation/states/auth_state.dart';
import 'package:suchigo_app/features/auth/data/models/auth_requests.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class FakeLoginRequest extends Fake implements LoginRequest {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeLoginRequest());
  });

  late MockAuthRepository mockRepository;

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    mockRepository = MockAuthRepository();
  });

  group('AuthNotifier', () {
    const testUser = UserModel(id: '1', username: 'test', email: 'test@t.com');

    test('initial state is AuthInitial', () {
      final container = makeContainer();
      final state = container.read(authProvider);
      expect(state, isA<AuthInitial>());
    });

    test('restoreSession sets state to AuthAuthenticated on success', () async {
      when(() => mockRepository.restoreSession()).thenAnswer((_) async => const Success(testUser));
      
      final container = makeContainer();
      
      final future = container.read(authProvider.notifier).restoreSession();
      // Right after calling, state should be AuthLoading
      expect(container.read(authProvider), isA<AuthLoading>());
      
      await future;
      
      final state = container.read(authProvider);
      expect(state, isA<AuthAuthenticated>());
      expect((state as AuthAuthenticated).user, testUser);
    });

    test('login sets state to AuthError on failure', () async {
      when(() => mockRepository.login(any())).thenAnswer((_) async => Failure(InvalidCredentialsError()));
      
      final container = makeContainer();
      await container.read(authProvider.notifier).login('u', 'p');
      
      final state = container.read(authProvider);
      expect(state, isA<AuthError>());
      expect((state as AuthError).error, isA<InvalidCredentialsError>());
    });

    test('logout sets state to AuthUnauthenticated', () async {
      when(() => mockRepository.logout()).thenAnswer((_) async => const Success(null));
      
      final container = makeContainer();
      await container.read(authProvider.notifier).logout();
      
      expect(container.read(authProvider), isA<AuthUnauthenticated>());
    });
  });
}
