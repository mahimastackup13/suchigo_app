import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/core/errors/error_mapper.dart';

void main() {
  group('ErrorMapper.map', () {
    test('SocketException → NoInternetError', () {
      final result = ErrorMapper.map(
        const SocketException('Connection refused'),
      );
      expect(result, isA<NoInternetError>());
    });

    test('TimeoutException → TimeoutError', () {
      final result = ErrorMapper.map(
        TimeoutException('Request timed out'),
      );
      expect(result, isA<TimeoutError>());
    });

    test('FormatException → ParseError', () {
      final result = ErrorMapper.map(
        const FormatException('Unexpected character'),
      );
      expect(result, isA<ParseError>());
      expect((result as ParseError).rawBody, contains('Unexpected'));
    });

    test('HttpException with 401 → InvalidCredentialsError', () {
      final result = ErrorMapper.map(
        const HttpException('401 Unauthorized'),
      );
      expect(result, isA<InvalidCredentialsError>());
    });

    test('HttpException with 500 → ServerError', () {
      final result = ErrorMapper.map(
        const HttpException('500 Internal Server Error'),
      );
      expect(result, isA<ServerError>());
    });

    test('AppError passes through unchanged', () {
      final original = TokenExpiredError();
      final result = ErrorMapper.map(original);
      expect(identical(result, original), isTrue);
    });

    test('Unknown exception → UnknownError', () {
      final result = ErrorMapper.map(StateError('bad state'));
      expect(result, isA<UnknownError>());
      expect(
        (result as UnknownError).debugMessage,
        contains('bad state'),
      );
    });
  });

  group('ErrorMapper.mapHttpStatus', () {
    // -----------------------------------------------------------------------
    // 401 Handling
    // -----------------------------------------------------------------------
    group('401 responses', () {
      test('401 with DRF non_field_errors', () {
        final result = ErrorMapper.mapHttpStatus(
          401,
          '{"non_field_errors": ["Unable to log in with provided credentials."]}',
        );
        expect(result, isA<InvalidCredentialsError>());
        expect(
          (result as InvalidCredentialsError).serverMessage,
          contains('Unable to log in'),
        );
      });

      test('401 with detail key', () {
        final result = ErrorMapper.mapHttpStatus(
          401,
          '{"detail": "Authentication credentials were not provided."}',
        );
        expect(result, isA<InvalidCredentialsError>());
        expect(
          (result as InvalidCredentialsError).serverMessage,
          contains('Authentication'),
        );
      });

      test('401 with empty body', () {
        final result = ErrorMapper.mapHttpStatus(401, null);
        expect(result, isA<InvalidCredentialsError>());
      });

      test('401 with non-JSON body', () {
        final result = ErrorMapper.mapHttpStatus(401, '<html>Denied</html>');
        expect(result, isA<InvalidCredentialsError>());
        expect(
          (result as InvalidCredentialsError).serverMessage,
          contains('html'),
        );
      });
    });

    // -----------------------------------------------------------------------
    // 400 Handling
    // -----------------------------------------------------------------------
    group('400 responses', () {
      test('400 with field-level errors → RegistrationError', () {
        final result = ErrorMapper.mapHttpStatus(
          400,
          '{"username": ["A user with that username already exists."], '
              '"email": ["Enter a valid email address."]}',
        );
        expect(result, isA<RegistrationError>());
        final regError = result as RegistrationError;
        expect(regError.fieldErrors, hasLength(2));
        expect(regError.fieldErrors['username']!.first, contains('already exists'));
      });

      test('400 with non_field_errors → InvalidCredentialsError', () {
        final result = ErrorMapper.mapHttpStatus(
          400,
          '{"non_field_errors": ["Unable to log in with provided credentials."]}',
        );
        expect(result, isA<InvalidCredentialsError>());
      });

      test('400 with empty body → UnknownError', () {
        final result = ErrorMapper.mapHttpStatus(400, null);
        expect(result, isA<UnknownError>());
      });

      test('400 with non-JSON body → UnknownError', () {
        final result = ErrorMapper.mapHttpStatus(400, 'Bad Request');
        expect(result, isA<UnknownError>());
      });
    });

    // -----------------------------------------------------------------------
    // 5xx Handling
    // -----------------------------------------------------------------------
    group('5xx responses', () {
      test('500 → ServerError with status code', () {
        final result = ErrorMapper.mapHttpStatus(500, 'Internal Server Error');
        expect(result, isA<ServerError>());
        expect((result as ServerError).statusCode, 500);
        expect(result.rawBody, 'Internal Server Error');
      });

      test('502 → ServerError', () {
        final result = ErrorMapper.mapHttpStatus(502, null);
        expect(result, isA<ServerError>());
        expect((result as ServerError).statusCode, 502);
      });

      test('503 → ServerError', () {
        final result = ErrorMapper.mapHttpStatus(503, 'Service Unavailable');
        expect(result, isA<ServerError>());
      });
    });

    // -----------------------------------------------------------------------
    // Unhandled Status Codes
    // -----------------------------------------------------------------------
    test('403 → UnknownError (unhandled status)', () {
      final result = ErrorMapper.mapHttpStatus(403, '{"detail": "Forbidden"}');
      expect(result, isA<UnknownError>());
      expect(
        (result as UnknownError).debugMessage,
        contains('403'),
      );
    });

    test('404 → UnknownError', () {
      final result = ErrorMapper.mapHttpStatus(404, 'Not Found');
      expect(result, isA<UnknownError>());
    });
  });
}
