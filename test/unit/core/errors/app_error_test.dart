import 'package:flutter_test/flutter_test.dart';
import 'package:suchigo_app/core/errors/app_error.dart';

void main() {
  group('AppError sealed hierarchy', () {
    // -----------------------------------------------------------------------
    // Network Errors
    // -----------------------------------------------------------------------
    group('NetworkErrors', () {
      test('NoInternetError has correct user message', () {
        final error = NoInternetError();
        expect(
          error.userMessage,
          'No internet connection. Please check your network.',
        );
        expect(error.debugMessage, contains('NoInternetError'));
        expect(error, isA<AppError>());
      });

      test('TimeoutError has correct user message', () {
        final error = TimeoutError();
        expect(error.userMessage, contains('too long'));
        expect(error.debugMessage, contains('TimeoutError'));
      });

      test('ServerError carries status code', () {
        final error = ServerError(statusCode: 503, rawBody: 'Service Unavailable');
        expect(error.statusCode, 503);
        expect(error.rawBody, 'Service Unavailable');
        expect(error.debugMessage, contains('503'));
        expect(error.userMessage, contains('our end'));
      });

      test('ServerError handles null rawBody', () {
        final error = ServerError(statusCode: 500);
        expect(error.rawBody, isNull);
        expect(error.debugMessage, contains('empty'));
      });

      test('ParseError carries raw body context', () {
        final error = ParseError(rawBody: '<html>not json</html>');
        expect(error.debugMessage, contains('not json'));
        expect(error.userMessage, contains('unexpected response'));
      });
    });

    // -----------------------------------------------------------------------
    // Auth Errors
    // -----------------------------------------------------------------------
    group('AuthErrors', () {
      test('InvalidCredentialsError with server message', () {
        final error = InvalidCredentialsError(
          serverMessage: 'Unable to log in with provided credentials.',
        );
        expect(error.userMessage, 'Incorrect username or password.');
        expect(error.debugMessage, contains('Unable to log in'));
      });

      test('InvalidCredentialsError without server message', () {
        final error = InvalidCredentialsError();
        expect(error.debugMessage, contains('401'));
      });

      test('TokenExpiredError redirects to login', () {
        final error = TokenExpiredError();
        expect(error.userMessage, contains('session has expired'));
      });

      test('TokenNotFoundError prompts login', () {
        final error = TokenNotFoundError();
        expect(error.userMessage, contains('log in'));
      });

      test('OtpExpiredError prompts new code', () {
        final error = OtpExpiredError();
        expect(error.userMessage, contains('request a new one'));
      });

      test('RegistrationError shows first field error', () {
        final error = RegistrationError(fieldErrors: {
          'email': ['Enter a valid email address.'],
          'username': ['This field is required.'],
        });
        expect(error.userMessage, contains('email'));
        expect(error.userMessage, contains('Enter a valid email'));
      });

      test('RegistrationError with empty map', () {
        final error = RegistrationError(fieldErrors: {});
        expect(error.userMessage, contains('Registration failed'));
      });
    });

    // -----------------------------------------------------------------------
    // Validation Errors
    // -----------------------------------------------------------------------
    group('ValidationErrors', () {
      test('EmptyFieldError includes field name', () {
        final error = EmptyFieldError(fieldName: 'Username');
        expect(error.userMessage, 'Username is required.');
        expect(error.debugMessage, contains('Username'));
      });

      test('InvalidEmailError message', () {
        expect(InvalidEmailError().userMessage, contains('valid email'));
      });

      test('InvalidPhoneError message', () {
        expect(InvalidPhoneError().userMessage, contains('country code'));
      });

      test('InvalidDateError message', () {
        expect(InvalidDateError().userMessage, contains('future date'));
      });
    });

    // -----------------------------------------------------------------------
    // Storage Errors
    // -----------------------------------------------------------------------
    group('StorageErrors', () {
      test('DbReadError with table context', () {
        final error = DbReadError(table: 'bookings', cause: 'no such table');
        expect(error.debugMessage, contains('bookings'));
        expect(error.debugMessage, contains('no such table'));
        expect(error.userMessage, contains('load data'));
      });

      test('DbWriteError without context', () {
        final error = DbWriteError();
        expect(error.debugMessage, contains('unknown'));
      });

      test('SecureStorageError with cause', () {
        final error = SecureStorageError(cause: 'Keystore locked');
        expect(error.debugMessage, contains('Keystore locked'));
      });
    });

    // -----------------------------------------------------------------------
    // Location Errors
    // -----------------------------------------------------------------------
    group('LocationErrors', () {
      test('PermissionDeniedError message', () {
        expect(
          PermissionDeniedError().userMessage,
          contains('Location access'),
        );
      });

      test('PermissionPermanentlyDeniedError directs to settings', () {
        expect(
          PermissionPermanentlyDeniedError().userMessage,
          contains('Settings'),
        );
      });

      test('LocationUnavailableError directs to enable GPS', () {
        expect(
          LocationUnavailableError().userMessage,
          contains('GPS'),
        );
      });
    });

    // -----------------------------------------------------------------------
    // Catch-All
    // -----------------------------------------------------------------------
    group('UnknownError', () {
      test('carries original message in debug', () {
        final error = UnknownError(message: 'NullPointerException');
        expect(error.debugMessage, contains('NullPointerException'));
        expect(error.userMessage, contains('unexpected error'));
      });
    });

    // -----------------------------------------------------------------------
    // Exhaustive Pattern Matching
    // -----------------------------------------------------------------------
    test('sealed class supports exhaustive switch', () {
      AppError error = NoInternetError();

      // This compiles because AppError is sealed — the compiler checks all cases.
      final message = switch (error) {
        NoInternetError() => 'no_internet',
        TimeoutError() => 'timeout',
        ServerError() => 'server',
        ParseError() => 'parse',
        InvalidCredentialsError() => 'invalid_creds',
        TokenExpiredError() => 'token_expired',
        TokenNotFoundError() => 'token_not_found',
        OtpExpiredError() => 'otp_expired',
        RegistrationError() => 'registration',
        EmptyFieldError() => 'empty_field',
        InvalidEmailError() => 'invalid_email',
        InvalidPhoneError() => 'invalid_phone',
        InvalidDateError() => 'invalid_date',
        DbReadError() => 'db_read',
        DbWriteError() => 'db_write',
        SecureStorageError() => 'secure_storage',
        PermissionDeniedError() => 'permission_denied',
        PermissionPermanentlyDeniedError() => 'permission_permanent',
        LocationUnavailableError() => 'location_unavailable',
        UnknownError() => 'unknown',
      };

      expect(message, 'no_internet');
    });
  });
}
