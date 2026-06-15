import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/core/errors/error_mapper.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/core/utils/app_logger.dart';

/// Manages secure persistence of sensitive data (JWTs, sensitive IDs).
///
/// Uses Keychain on iOS and EncryptedSharedPreferences on Android via
/// `flutter_secure_storage`. This class wraps the untyped plugin API in
/// the robust `Result<T>` pattern.
///
/// All secure storage interactions must go through this class.
class SecureStorage {
  final FlutterSecureStorage _storage;

  static const String _keyToken = 'auth_token';
  static const String _keyUserId = 'user_id';

  /// Creates a [SecureStorage] instance.
  ///
  /// In production, use the default constructor. In testing, pass a mock
  /// [FlutterSecureStorage].
  SecureStorage({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage();

  // ---------------------------------------------------------------------------
  // Token Operations
  // ---------------------------------------------------------------------------

  /// Saves the JWT auth token securely.
  Future<Result<void>> saveToken(String token) async {
    return _write(_keyToken, token);
  }

  /// Retrieves the JWT auth token.
  ///
  /// Returns [TokenNotFoundError] if no token exists.
  Future<Result<String>> getToken() async {
    final result = await _read(_keyToken);
    return result.flatMap((value) async {
      if (value == null || value.isEmpty) {
        return Failure(TokenNotFoundError());
      }
      return Success(value);
    });
  }

  /// Deletes the JWT auth token.
  Future<Result<void>> deleteToken() async {
    return _delete(_keyToken);
  }

  // ---------------------------------------------------------------------------
  // User ID Operations
  // ---------------------------------------------------------------------------

  /// Saves the primary user ID securely.
  Future<Result<void>> saveUserId(String userId) async {
    return _write(_keyUserId, userId);
  }

  /// Retrieves the primary user ID.
  ///
  /// Returns [TokenNotFoundError] if no ID exists (since ID implies session).
  Future<Result<String>> getUserId() async {
    final result = await _read(_keyUserId);
    return result.flatMap((value) async {
      if (value == null || value.isEmpty) {
        return Failure(TokenNotFoundError());
      }
      return Success(value);
    });
  }

  /// Deletes the primary user ID.
  Future<Result<void>> deleteUserId() async {
    return _delete(_keyUserId);
  }

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  /// Clears all secure storage. Call this on logout or session expiration.
  Future<Result<void>> clearAll() async {
    try {
      await _storage.deleteAll();
      return const Success(null);
    } catch (e, st) {
      AppLogger.error('Failed to clear secure storage', error: e, stackTrace: st);
      return Failure(SecureStorageError(cause: e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // Private Helpers
  // ---------------------------------------------------------------------------

  Future<Result<void>> _write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
      return const Success(null);
    } catch (e, st) {
      AppLogger.error('Failed to write $key to secure storage', error: e, stackTrace: st);
      return Failure(SecureStorageError(cause: e.toString()));
    }
  }

  Future<Result<String?>> _read(String key) async {
    try {
      final value = await _storage.read(key: key);
      return Success(value);
    } catch (e, st) {
      AppLogger.error('Failed to read $key from secure storage', error: e, stackTrace: st);
      // Ensure we map to the exact SecureStorageError rather than a generic one
      return Failure(SecureStorageError(cause: e.toString()));
    }
  }

  Future<Result<void>> _delete(String key) async {
    try {
      await _storage.delete(key: key);
      return const Success(null);
    } catch (e, st) {
      AppLogger.error('Failed to delete $key from secure storage', error: e, stackTrace: st);
      return Failure(SecureStorageError(cause: e.toString()));
    }
  }
}
