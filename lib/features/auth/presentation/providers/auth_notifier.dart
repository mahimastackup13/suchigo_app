import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:suchigo_app/features/auth/data/models/auth_requests.dart';
import 'package:suchigo_app/features/auth/data/repositories/auth_repository.dart';
import 'package:suchigo_app/features/auth/presentation/states/auth_state.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/features/auth/data/models/user_model.dart';
import 'package:suchigo_app/features/auth/presentation/providers/auth_providers.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    return const AuthInitial();
  }

  Future<void> restoreSession() async {
    state = const AuthLoading();
    final result = await ref.read(authRepositoryProvider).restoreSession();

    if (result is Success<UserModel>) {
      state = AuthAuthenticated(result.data);
    } else {
      state = const AuthUnauthenticated();
    }
  }

  Future<void> login(String username, String password) async {
    state = const AuthLoading();
    final request = LoginRequest(username: username, password: password);
    final result = await ref.read(authRepositoryProvider).login(request);

    if (result is Success<UserModel>) {
      state = AuthAuthenticated(result.data);
    } else {
      state = AuthError((result as Failure).error);
    }
  }

  Future<void> register(String username, String email, String password) async {
    state = const AuthLoading();
    final request = RegisterRequest(username: username, email: email, password: password);
    final result = await ref.read(authRepositoryProvider).register(request);

    if (result is Success<UserModel>) {
      state = AuthAuthenticated(result.data);
    } else {
      state = AuthError((result as Failure).error);
    }
  }

  Future<void> logout() async {
    state = const AuthLoading();
    await ref.read(authRepositoryProvider).logout();
    state = const AuthUnauthenticated();
  }

  /// Called by ApiInterceptor when a 401 response is received.
  void forceLogout() {
    state = const AuthUnauthenticated();
  }
}
