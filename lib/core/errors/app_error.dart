import 'package:suchigo_app/core/constants/app_strings.dart';

/// Sealed error hierarchy for the SuchiGo application.
///
/// Every layer in the app speaks this error language. Raw exceptions
/// (SocketException, FormatException, etc.) are mapped to an [AppError]
/// subclass at the DataSource boundary via [ErrorMapper].
///
/// UI widgets read [userMessage] to display human-friendly feedback.
/// [debugMessage] is logged internally and never shown to the user.
sealed class AppError implements Exception {
  /// Human-readable message safe to display in the UI.
  String get userMessage;

  /// Internal message for logging and diagnostics. May contain technical
  /// detail but never PII.
  String get debugMessage;
}

// ---------------------------------------------------------------------------
// Network Errors
// ---------------------------------------------------------------------------

/// Device has no network connectivity.
final class NoInternetError extends AppError {
  @override
  String get userMessage => AppStrings.errorNoInternet;

  @override
  String get debugMessage => 'NoInternetError: Device is offline.';
}

/// HTTP request exceeded the 15-second timeout threshold.
final class TimeoutError extends AppError {
  @override
  String get userMessage => AppStrings.errorTimeout;

  @override
  String get debugMessage => 'TimeoutError: Request exceeded timeout.';
}

/// Server returned a 5xx status code.
final class ServerError extends AppError {
  final int statusCode;
  final String? rawBody;

  ServerError({required this.statusCode, this.rawBody});

  @override
  String get userMessage => AppStrings.errorServer;

  @override
  String get debugMessage =>
      'ServerError: HTTP $statusCode. Body: ${rawBody ?? 'empty'}';
}

/// Response body could not be decoded as valid JSON.
final class ParseError extends AppError {
  final String? rawBody;

  ParseError({this.rawBody});

  @override
  String get userMessage => AppStrings.errorParse;

  @override
  String get debugMessage =>
      'ParseError: Failed to decode response. Body: ${rawBody ?? 'empty'}';
}

// ---------------------------------------------------------------------------
// Auth Errors
// ---------------------------------------------------------------------------

/// 401 — username or password incorrect.
final class InvalidCredentialsError extends AppError {
  final String? serverMessage;

  InvalidCredentialsError({this.serverMessage});

  @override
  String get userMessage => AppStrings.errorInvalidCredentials;

  @override
  String get debugMessage =>
      'InvalidCredentialsError: ${serverMessage ?? '401 from API'}';
}

/// JWT token has expired and the session is no longer valid.
final class TokenExpiredError extends AppError {
  @override
  String get userMessage => AppStrings.errorTokenExpired;

  @override
  String get debugMessage => 'TokenExpiredError: JWT expired.';
}

/// No token found in secure storage during session restore.
final class TokenNotFoundError extends AppError {
  @override
  String get userMessage => AppStrings.errorTokenNotFound;

  @override
  String get debugMessage =>
      'TokenNotFoundError: SecureStorage returned null for token key.';
}

/// OTP verification window has elapsed.
final class OtpExpiredError extends AppError {
  @override
  String get userMessage => AppStrings.errorOtpExpired;

  @override
  String get debugMessage => 'OtpExpiredError: OTP window elapsed.';
}

/// Server rejected the registration request with field-level errors.
final class RegistrationError extends AppError {
  final Map<String, List<String>> fieldErrors;

  RegistrationError({required this.fieldErrors});

  @override
  String get userMessage {
    if (fieldErrors.isEmpty) return AppStrings.errorRegistrationFailed;
    final firstKey = fieldErrors.keys.first;
    final firstMsg = fieldErrors[firstKey]!.first;
    return '$firstKey: $firstMsg';
  }

  @override
  String get debugMessage =>
      'RegistrationError: ${fieldErrors.entries.map((e) => '${e.key}=${e.value.join(", ")}').join('; ')}';
}

// ---------------------------------------------------------------------------
// Validation Errors
// ---------------------------------------------------------------------------

/// A required field was left empty.
final class EmptyFieldError extends AppError {
  final String fieldName;

  EmptyFieldError({required this.fieldName});

  @override
  String get userMessage => '$fieldName ${AppStrings.errorFieldRequired}';

  @override
  String get debugMessage =>
      'EmptyFieldError: "$fieldName" is empty.';
}

/// Email format is invalid.
final class InvalidEmailError extends AppError {
  @override
  String get userMessage => AppStrings.errorInvalidEmail;

  @override
  String get debugMessage => 'InvalidEmailError: Email failed format check.';
}

/// Phone number format is invalid or missing country code.
final class InvalidPhoneError extends AppError {
  @override
  String get userMessage => AppStrings.errorInvalidPhone;

  @override
  String get debugMessage =>
      'InvalidPhoneError: Phone failed format check.';
}

/// Pickup date is in the past.
final class InvalidDateError extends AppError {
  @override
  String get userMessage => AppStrings.errorInvalidDate;

  @override
  String get debugMessage => 'InvalidDateError: Selected date is in the past.';
}

// ---------------------------------------------------------------------------
// Storage Errors
// ---------------------------------------------------------------------------

/// SQLite query failed.
final class DbReadError extends AppError {
  final String? table;
  final String? cause;

  DbReadError({this.table, this.cause});

  @override
  String get userMessage => AppStrings.errorDbRead;

  @override
  String get debugMessage =>
      'DbReadError: table=${table ?? 'unknown'}, cause=${cause ?? 'unknown'}';
}

/// SQLite insert or update failed.
final class DbWriteError extends AppError {
  final String? table;
  final String? cause;

  DbWriteError({this.table, this.cause});

  @override
  String get userMessage => AppStrings.errorDbWrite;

  @override
  String get debugMessage =>
      'DbWriteError: table=${table ?? 'unknown'}, cause=${cause ?? 'unknown'}';
}

/// Keychain/Keystore access failed.
final class SecureStorageError extends AppError {
  final String? cause;

  SecureStorageError({this.cause});

  @override
  String get userMessage => AppStrings.errorSecureStorage;

  @override
  String get debugMessage =>
      'SecureStorageError: ${cause ?? 'unknown'}';
}

// ---------------------------------------------------------------------------
// Location Errors
// ---------------------------------------------------------------------------

/// User denied location permission (can request again).
final class PermissionDeniedError extends AppError {
  @override
  String get userMessage => AppStrings.errorPermissionDenied;

  @override
  String get debugMessage =>
      'PermissionDeniedError: User denied location permission.';
}

/// User permanently denied location (must open system settings).
final class PermissionPermanentlyDeniedError extends AppError {
  @override
  String get userMessage => AppStrings.errorPermissionPermanentlyDenied;

  @override
  String get debugMessage =>
      'PermissionPermanentlyDeniedError: Must open system settings.';
}

/// GPS hardware is unavailable or disabled.
final class LocationUnavailableError extends AppError {
  @override
  String get userMessage => AppStrings.errorLocationUnavailable;

  @override
  String get debugMessage =>
      'LocationUnavailableError: GPS hardware unavailable.';
}

// ---------------------------------------------------------------------------
// Catch-All
// ---------------------------------------------------------------------------

/// Unexpected error that doesn't fit any specific category.
final class UnknownError extends AppError {
  final String message;

  UnknownError({required this.message});

  @override
  String get userMessage => AppStrings.errorUnknown;

  @override
  String get debugMessage => 'UnknownError: $message';
}
