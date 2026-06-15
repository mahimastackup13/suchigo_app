import 'package:shared_preferences/shared_preferences.dart';
import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/core/utils/app_logger.dart';

/// Strongly typed accessor for app preferences.
///
/// Wraps `shared_preferences` to prevent arbitrary string key usage across
/// the codebase and ensures failures map to `Result<T>` with `DbReadError`
/// or `DbWriteError`.
class Preferences {
  final SharedPreferences prefs;

  static const String _keyOnboardingComplete = 'onboarding_complete';
  static const String _keySelectedWard = 'selected_ward';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyLanguage = 'language';
  static const String _keyNotificationsEnabled = 'notifications_enabled';

  Preferences({required this.prefs});

  // ---------------------------------------------------------------------------
  // Onboarding
  // ---------------------------------------------------------------------------

  bool get isOnboardingComplete {
    return prefs.getBool(_keyOnboardingComplete) ?? false;
  }

  Future<Result<void>> setOnboardingComplete() async {
    return _writeBool(_keyOnboardingComplete, true);
  }

  // ---------------------------------------------------------------------------
  // Selected Ward
  // ---------------------------------------------------------------------------

  int? get selectedWardId {
    return prefs.getInt(_keySelectedWard);
  }

  Future<Result<void>> setSelectedWardId(int wardId) async {
    return _writeInt(_keySelectedWard, wardId);
  }

  // ---------------------------------------------------------------------------
  // Theme Mode
  // ---------------------------------------------------------------------------

  /// Returns 'system', 'light', or 'dark'. Defaults to 'system'.
  String get themeMode {
    return prefs.getString(_keyThemeMode) ?? 'system';
  }

  Future<Result<void>> setThemeMode(String mode) async {
    if (!['system', 'light', 'dark'].contains(mode)) {
      return Failure(DbWriteError(cause: 'Invalid theme mode: $mode'));
    }
    return _writeString(_keyThemeMode, mode);
  }

  // ---------------------------------------------------------------------------
  // Language
  // ---------------------------------------------------------------------------

  /// Returns language code (e.g., 'en', 'ml'). Defaults to 'en'.
  String get language {
    return prefs.getString(_keyLanguage) ?? 'en';
  }

  Future<Result<void>> setLanguage(String langCode) async {
    return _writeString(_keyLanguage, langCode);
  }

  // ---------------------------------------------------------------------------
  // Notifications
  // ---------------------------------------------------------------------------

  bool get notificationsEnabled {
    return prefs.getBool(_keyNotificationsEnabled) ?? true;
  }

  Future<Result<void>> setNotificationsEnabled(bool enabled) async {
    return _writeBool(_keyNotificationsEnabled, enabled);
  }

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  /// Clears all preferences (except onboarding status, usually).
  /// For this app, we may want to clear ward but keep language.
  Future<Result<void>> clearUserPreferences() async {
    try {
      await prefs.remove(_keySelectedWard);
      // We keep theme, language, and onboarding.
      return const Success(null);
    } catch (e, st) {
      AppLogger.error('Failed to clear preferences', error: e, stackTrace: st);
      return Failure(DbWriteError(cause: e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // Private Helpers
  // ---------------------------------------------------------------------------

  Future<Result<void>> _writeBool(String key, bool value) async {
    try {
      final success = await prefs.setBool(key, value);
      if (success) return const Success(null);
      return Failure(DbWriteError(cause: 'Failed to write bool to $key'));
    } catch (e, st) {
      AppLogger.error('Prefs write error', error: e, stackTrace: st);
      return Failure(DbWriteError(cause: e.toString()));
    }
  }

  Future<Result<void>> _writeInt(String key, int value) async {
    try {
      final success = await prefs.setInt(key, value);
      if (success) return const Success(null);
      return Failure(DbWriteError(cause: 'Failed to write int to $key'));
    } catch (e, st) {
      AppLogger.error('Prefs write error', error: e, stackTrace: st);
      return Failure(DbWriteError(cause: e.toString()));
    }
  }

  Future<Result<void>> _writeString(String key, String value) async {
    try {
      final success = await prefs.setString(key, value);
      if (success) return const Success(null);
      return Failure(DbWriteError(cause: 'Failed to write string to $key'));
    } catch (e, st) {
      AppLogger.error('Prefs write error', error: e, stackTrace: st);
      return Failure(DbWriteError(cause: e.toString()));
    }
  }
}
