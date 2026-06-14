import 'package:flutter_test/flutter_test.dart';
import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/core/utils/validators.dart';

void main() {
  group('Validators', () {
    // -----------------------------------------------------------------------
    // Email
    // -----------------------------------------------------------------------
    group('validateEmail', () {
      test('valid email returns null', () {
        expect(Validators.validateEmail('user@example.com'), isNull);
      });

      test('valid email with subdomain returns null', () {
        expect(Validators.validateEmail('user@mail.example.co.in'), isNull);
      });

      test('valid email with dots and plus returns null', () {
        expect(Validators.validateEmail('first.last+tag@example.com'), isNull);
      });

      test('empty email returns EmptyFieldError', () {
        final result = Validators.validateEmail('');
        expect(result, isA<EmptyFieldError>());
        expect((result as EmptyFieldError).fieldName, 'Email');
      });

      test('whitespace-only email returns EmptyFieldError', () {
        expect(Validators.validateEmail('   '), isA<EmptyFieldError>());
      });

      test('email without @ returns InvalidEmailError', () {
        expect(Validators.validateEmail('userexample.com'), isA<InvalidEmailError>());
      });

      test('email without domain returns InvalidEmailError', () {
        expect(Validators.validateEmail('user@'), isA<InvalidEmailError>());
      });

      test('email without TLD returns InvalidEmailError', () {
        expect(Validators.validateEmail('user@example'), isA<InvalidEmailError>());
      });

      test('email with spaces returns InvalidEmailError', () {
        expect(Validators.validateEmail('user @example.com'), isA<InvalidEmailError>());
      });
    });

    // -----------------------------------------------------------------------
    // Phone
    // -----------------------------------------------------------------------
    group('validatePhone', () {
      test('valid Indian number returns null', () {
        expect(Validators.validatePhone('+917736905991'), isNull);
      });

      test('valid US number returns null', () {
        expect(Validators.validatePhone('+12125551234'), isNull);
      });

      test('valid 15-digit number returns null', () {
        expect(Validators.validatePhone('+123456789012345'), isNull);
      });

      test('empty phone returns EmptyFieldError', () {
        final result = Validators.validatePhone('');
        expect(result, isA<EmptyFieldError>());
      });

      test('phone without + returns InvalidPhoneError', () {
        expect(Validators.validatePhone('917736905991'), isA<InvalidPhoneError>());
      });

      test('phone with letters returns InvalidPhoneError', () {
        expect(Validators.validatePhone('+91abc7736905'), isA<InvalidPhoneError>());
      });

      test('phone too short returns InvalidPhoneError', () {
        expect(Validators.validatePhone('+12345'), isA<InvalidPhoneError>());
      });

      test('phone too long returns InvalidPhoneError', () {
        expect(Validators.validatePhone('+1234567890123456'), isA<InvalidPhoneError>());
      });
    });

    // -----------------------------------------------------------------------
    // Required Field
    // -----------------------------------------------------------------------
    group('validateRequired', () {
      test('non-empty value returns null', () {
        expect(
          Validators.validateRequired('hello', fieldName: 'Name'),
          isNull,
        );
      });

      test('empty value returns EmptyFieldError with field name', () {
        final result = Validators.validateRequired('', fieldName: 'Ward');
        expect(result, isA<EmptyFieldError>());
        expect((result as EmptyFieldError).fieldName, 'Ward');
        expect(result.userMessage, 'Ward is required.');
      });

      test('whitespace-only value returns EmptyFieldError', () {
        expect(
          Validators.validateRequired('   ', fieldName: 'Address'),
          isA<EmptyFieldError>(),
        );
      });
    });

    // -----------------------------------------------------------------------
    // Future Date
    // -----------------------------------------------------------------------
    group('validateFutureDate', () {
      test('tomorrow returns null', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        expect(Validators.validateFutureDate(tomorrow), isNull);
      });

      test('one hour from now returns null', () {
        final future = DateTime.now().add(const Duration(hours: 1));
        expect(Validators.validateFutureDate(future), isNull);
      });

      test('yesterday returns InvalidDateError', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        expect(
          Validators.validateFutureDate(yesterday),
          isA<InvalidDateError>(),
        );
      });

      test('far past returns InvalidDateError', () {
        final pastDate = DateTime(2020, 1, 1);
        expect(
          Validators.validateFutureDate(pastDate),
          isA<InvalidDateError>(),
        );
      });
    });

    // -----------------------------------------------------------------------
    // Password
    // -----------------------------------------------------------------------
    group('validatePassword', () {
      test('8-character password returns null', () {
        expect(Validators.validatePassword('12345678'), isNull);
      });

      test('long password returns null', () {
        expect(Validators.validatePassword('securepassword123'), isNull);
      });

      test('empty password returns EmptyFieldError', () {
        final result = Validators.validatePassword('');
        expect(result, isA<EmptyFieldError>());
      });

      test('7-character password returns EmptyFieldError', () {
        final result = Validators.validatePassword('1234567');
        expect(result, isA<EmptyFieldError>());
        expect(
          (result as EmptyFieldError).fieldName,
          contains('minimum 8'),
        );
      });
    });

    // -----------------------------------------------------------------------
    // Username
    // -----------------------------------------------------------------------
    group('validateUsername', () {
      test('valid alphanumeric returns null', () {
        expect(Validators.validateUsername('john_doe'), isNull);
      });

      test('valid with dots returns null', () {
        expect(Validators.validateUsername('john.doe123'), isNull);
      });

      test('empty username returns EmptyFieldError', () {
        expect(Validators.validateUsername(''), isA<EmptyFieldError>());
      });

      test('username with spaces returns error', () {
        final result = Validators.validateUsername('john doe');
        expect(result, isA<EmptyFieldError>());
      });

      test('username with special chars returns error', () {
        final result = Validators.validateUsername('john@doe!');
        expect(result, isA<EmptyFieldError>());
      });
    });
  });
}
