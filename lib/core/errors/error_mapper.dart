import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:suchigo_app/core/errors/app_error.dart';

/// Maps raw platform and library exceptions to typed [AppError] subclasses.
///
/// This is the single gateway between the untyped exception world (Dart IO,
/// `http`, `sqflite`, `flutter_secure_storage`) and the strongly-typed error
/// hierarchy consumed by repositories and notifiers.
///
/// Usage in a DataSource:
/// ```dart
/// try {
///   final response = await apiClient.post('/login', body: credentials);
///   return response;
/// } catch (e, st) {
///   throw ErrorMapper.map(e);
/// }
/// ```
abstract final class ErrorMapper {
  /// Converts a raw exception into an [AppError].
  ///
  /// Mapping rules (evaluated in order):
  /// - [SocketException] → [NoInternetError]
  /// - [TimeoutException] → [TimeoutError]
  /// - [FormatException] / [JsonUnsupportedObjectError] → [ParseError]
  /// - [HttpException] → status-code driven auth/server error
  /// - Everything else → [UnknownError]
  static AppError map(Object exception) {
    return switch (exception) {
      SocketException() => NoInternetError(),
      TimeoutException() => TimeoutError(),
      FormatException() => ParseError(rawBody: exception.message),
      JsonUnsupportedObjectError() => ParseError(
          rawBody: exception.toString(),
        ),
      HttpException() => _mapHttpException(exception),
      AppError() => exception,
      _ => UnknownError(message: exception.toString()),
    };
  }

  /// Maps an HTTP status code + optional response body to the appropriate
  /// [AppError] subclass.
  ///
  /// Call this from the API client after receiving a non-2xx response to
  /// produce a typed error from the raw status code and body.
  static AppError mapHttpStatus(int statusCode, String? responseBody) {
    if (statusCode == 401) {
      return _parse401(responseBody);
    }

    if (statusCode == 400) {
      return _parse400(responseBody);
    }

    if (statusCode >= 500) {
      return ServerError(statusCode: statusCode, rawBody: responseBody);
    }

    return UnknownError(
      message: 'Unhandled HTTP $statusCode: ${responseBody ?? 'empty body'}',
    );
  }

  static AppError _mapHttpException(HttpException exception) {
    final message = exception.message.toLowerCase();
    if (message.contains('401') || message.contains('unauthorized')) {
      return InvalidCredentialsError(serverMessage: exception.message);
    }
    if (message.contains('500') || message.contains('internal server')) {
      return ServerError(statusCode: 500, rawBody: exception.message);
    }
    return UnknownError(message: exception.message);
  }

  /// Parses a 401 response. DRF typically returns:
  /// `{"non_field_errors": ["Unable to log in with provided credentials."]}`
  /// or `{"detail": "..."}`
  static AppError _parse401(String? body) {
    if (body == null || body.isEmpty) {
      return InvalidCredentialsError();
    }

    try {
      final decoded = jsonDecode(body) as Map<String, dynamic>;
      final message = _extractFirstMessage(decoded);
      return InvalidCredentialsError(serverMessage: message);
    } on FormatException {
      return InvalidCredentialsError(serverMessage: body);
    }
  }

  /// Parses a 400 response. DRF returns field-keyed errors:
  /// `{"username": ["This field is required."], "email": ["Enter a valid email."]}`
  static AppError _parse400(String? body) {
    if (body == null || body.isEmpty) {
      return UnknownError(message: 'HTTP 400 with empty body');
    }

    try {
      final decoded = jsonDecode(body) as Map<String, dynamic>;

      // Check for field-level validation errors (registration)
      final fieldErrors = <String, List<String>>{};
      for (final entry in decoded.entries) {
        final value = entry.value;
        if (value is List && value.isNotEmpty) {
          fieldErrors[entry.key] = value.cast<String>();
        }
      }

      if (fieldErrors.isNotEmpty) {
        // If it contains typical auth error keys, treat as credential error
        if (fieldErrors.containsKey('non_field_errors')) {
          return InvalidCredentialsError(
            serverMessage: fieldErrors['non_field_errors']!.first,
          );
        }
        return RegistrationError(fieldErrors: fieldErrors);
      }

      // Fallback to detail/message keys
      final message = _extractFirstMessage(decoded);
      return UnknownError(message: 'HTTP 400: $message');
    } on FormatException {
      return UnknownError(message: 'HTTP 400: $body');
    }
  }

  /// Extracts the first human-readable message from a DRF error response.
  static String _extractFirstMessage(Map<String, dynamic> json) {
    for (final key in [
      'detail',
      'message',
      'non_field_errors',
      'username',
      'email',
      'password',
      'phone_number',
    ]) {
      final value = json[key];
      if (value is String && value.isNotEmpty) return value;
      if (value is List && value.isNotEmpty) return value.first.toString();
    }
    return json.toString();
  }
}
