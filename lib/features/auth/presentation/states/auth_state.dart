import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/features/auth/data/models/user_model.dart';

sealed class AuthState {
  const AuthState();
}

/// Initial state before session restoration completes.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state during login/register/restoration.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Successfully authenticated with a user profile.
class AuthAuthenticated extends AuthState {
  final UserModel user;
  const AuthAuthenticated(this.user);
}

/// Unauthenticated state (logged out or failed restore).
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Error state for failures during login/register.
class AuthError extends AuthState {
  final AppError error;
  const AuthError(this.error);
}
