import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Centralised, level-gated logger that replaces all `print()` usage.
///
/// Design decisions:
/// - Uses `dart:developer` `log()` in debug for DevTools integration.
/// - Completely silent in release builds (no PII leaks via logcat/console).
/// - PII patterns (emails, phones) are stripped before output.
/// - No external dependency — avoids adding packages for a simple concern.
///
/// Usage:
/// ```dart
/// AppLogger.info('User loaded successfully');
/// AppLogger.error('Login failed', error: appError, stackTrace: st);
/// ```
abstract final class AppLogger {
  static const String _tag = 'SuchiGo';

  /// Log levels in ascending severity.
  static const int _levelDebug = 0;
  static const int _levelInfo = 1;
  static const int _levelWarning = 2;
  static const int _levelError = 3;

  /// Minimum level that produces output.
  /// Debug: all levels. Release: warning and above.
  static final int _minLevel = kDebugMode ? _levelDebug : _levelWarning;

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Verbose diagnostic information. Silent in release.
  static void debug(String message) {
    _log(_levelDebug, 'DEBUG', message);
  }

  /// General operational information. Silent in release.
  static void info(String message) {
    _log(_levelInfo, 'INFO', message);
  }

  /// Potential issues that don't prevent operation.
  static void warning(String message) {
    _log(_levelWarning, 'WARNING', message);
  }

  /// Errors that affect functionality. Always logged.
  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    final errorDetail = error != null ? ' | Error: $error' : '';
    _log(_levelError, 'ERROR', '$message$errorDetail');
    if (kDebugMode && stackTrace != null) {
      _log(_levelError, 'STACK', stackTrace.toString());
    }
  }

  // ---------------------------------------------------------------------------
  // Internal
  // ---------------------------------------------------------------------------

  static void _log(int level, String label, String message) {
    if (level < _minLevel) return;

    final sanitised = _sanitise(message);
    final formatted = '[$_tag][$label] $sanitised';

    if (kDebugMode) {
      developer.log(
        formatted,
        name: _tag,
        level: level * 500,
      );
    }
  }

  /// Strips known PII patterns from log messages.
  ///
  /// Patterns removed:
  /// - Email addresses → `[EMAIL]`
  /// - Phone numbers (with country code) → `[PHONE]`
  /// - JWT-like tokens (long base64 strings) → `[TOKEN]`
  static String _sanitise(String input) {
    var result = input;

    // Email: user@domain.tld
    result = result.replaceAll(
      RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'),
      '[EMAIL]',
    );

    // Phone: +91XXXXXXXXXX or similar international formats
    result = result.replaceAll(
      RegExp(r'\+\d{10,15}'),
      '[PHONE]',
    );

    // JWT-like tokens: 3 dot-separated base64 segments, each 20+ chars
    result = result.replaceAll(
      RegExp(r'eyJ[A-Za-z0-9_-]{20,}\.eyJ[A-Za-z0-9_-]{20,}\.[A-Za-z0-9_-]{20,}'),
      '[TOKEN]',
    );

    return result;
  }
}
