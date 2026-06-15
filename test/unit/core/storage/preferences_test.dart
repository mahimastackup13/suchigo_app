import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/core/storage/preferences.dart';

void main() {
  late Preferences prefs;

  setUp(() async {
    // Set up mock SharedPreferences for unit testing
    SharedPreferences.setMockInitialValues({});
    final sharedPrefs = await SharedPreferences.getInstance();
    prefs = Preferences(prefs: sharedPrefs);
  });

  group('Preferences - Defaults', () {
    test('isOnboardingComplete defaults to false', () {
      expect(prefs.isOnboardingComplete, isFalse);
    });

    test('selectedWardId defaults to null', () {
      expect(prefs.selectedWardId, isNull);
    });

    test('themeMode defaults to system', () {
      expect(prefs.themeMode, 'system');
    });

    test('language defaults to en', () {
      expect(prefs.language, 'en');
    });

    test('notificationsEnabled defaults to true', () {
      expect(prefs.notificationsEnabled, isTrue);
    });
  });

  group('Preferences - Updates', () {
    test('setOnboardingComplete updates value', () async {
      final result = await prefs.setOnboardingComplete();
      expect(result.isSuccess, isTrue);
      expect(prefs.isOnboardingComplete, isTrue);
    });

    test('setSelectedWardId updates value', () async {
      final result = await prefs.setSelectedWardId(42);
      expect(result.isSuccess, isTrue);
      expect(prefs.selectedWardId, 42);
    });

    test('setThemeMode updates value for valid mode', () async {
      final result = await prefs.setThemeMode('dark');
      expect(result.isSuccess, isTrue);
      expect(prefs.themeMode, 'dark');
    });

    test('setThemeMode returns Failure for invalid mode', () async {
      final result = await prefs.setThemeMode('hologram');
      expect(result.isFailure, isTrue);
      expect((result as Failure).error, isA<DbWriteError>());
      // Default should remain
      expect(prefs.themeMode, 'system');
    });

    test('setLanguage updates value', () async {
      final result = await prefs.setLanguage('ml');
      expect(result.isSuccess, isTrue);
      expect(prefs.language, 'ml');
    });

    test('setNotificationsEnabled updates value', () async {
      final result = await prefs.setNotificationsEnabled(false);
      expect(result.isSuccess, isTrue);
      expect(prefs.notificationsEnabled, isFalse);
    });
  });

  group('Preferences - Lifecycle', () {
    test('clearUserPreferences removes ward but keeps onboarding/theme', () async {
      await prefs.setOnboardingComplete();
      await prefs.setSelectedWardId(42);
      await prefs.setThemeMode('dark');

      final result = await prefs.clearUserPreferences();
      expect(result.isSuccess, isTrue);

      expect(prefs.selectedWardId, isNull); // Cleared
      expect(prefs.isOnboardingComplete, isTrue); // Kept
      expect(prefs.themeMode, 'dark'); // Kept
    });
  });
}
