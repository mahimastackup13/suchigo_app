import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/core/storage/secure_storage.dart';
import 'package:suchigo_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:suchigo_app/features/auth/data/models/auth_requests.dart';
import 'package:suchigo_app/features/auth/data/models/user_model.dart';

class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorage _secureStorage;

  AuthRepository({
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorage secureStorage,
  })  : _remoteDataSource = remoteDataSource,
        _secureStorage = secureStorage;

  /// Logs in the user and securely saves the JWT token.
  Future<Result<UserModel>> login(LoginRequest request) async {
    final result = await _remoteDataSource.login(request);

    if (result is Failure<Map<String, dynamic>>) {
      return Failure(result.error);
    }

    final data = (result as Success<Map<String, dynamic>>).data;
    final token = data['token'] as String?;

    if (token == null) {
      return Failure(ParseError(rawBody: 'No token in response'));
    }

    // Save token
    final saveResult = await _secureStorage.saveToken(token);
    if (saveResult is Failure<void>) {
      return Failure(saveResult.error);
    }

    // Try to parse user. If backend returns user object in login:
    if (data['user'] != null) {
      try {
        final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
        return Success(user);
      } catch (_) {
        // Fallback to fetch profile if user object parsing fails or doesn't exist
      }
    }

    // Fallback: Fetch profile explicitly using the new token
    return _remoteDataSource.fetchProfile();
  }

  /// Registers a new user. Backend typically returns token upon register.
  Future<Result<UserModel>> register(RegisterRequest request) async {
    final result = await _remoteDataSource.register(request);

    if (result is Failure<Map<String, dynamic>>) {
      return Failure(result.error);
    }

    final data = (result as Success<Map<String, dynamic>>).data;
    final token = data['token'] as String?;

    if (token == null) {
      return Failure(ParseError(rawBody: 'No token in response'));
    }

    final saveResult = await _secureStorage.saveToken(token);
    if (saveResult is Failure<void>) {
      return Failure(saveResult.error);
    }

    if (data['user'] != null) {
      try {
        final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
        return Success(user);
      } catch (_) {
        // Fallback
      }
    }

    return _remoteDataSource.fetchProfile();
  }

  /// Restores session by checking if a token exists and validating it via profile endpoint.
  Future<Result<UserModel>> restoreSession() async {
    final tokenResult = await _secureStorage.getToken();
    
    if (tokenResult is Failure<String>) {
      return Failure(tokenResult.error);
    }

    // We have a token. Validate it by fetching the profile.
    return _remoteDataSource.fetchProfile();
  }

  /// Logs out the user by clearing secure storage.
  Future<Result<void>> logout() async {
    return _secureStorage.clearAll();
  }
}
