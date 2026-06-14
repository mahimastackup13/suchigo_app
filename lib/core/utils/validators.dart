import 'package:suchigo_app/core/constants/app_strings.dart';
import 'package:suchigo_app/core/errors/app_error.dart';

/// Pure validation functions used across the application.
///
/// Each validator returns `null` on valid input or a typed [AppError] on
/// failure. This integrates directly with the error hierarchy — notifiers
/// can include validation errors in state without translation.
///
/// All functions are static and stateless. No side effects.
abstract final class Validators {
  // ---------------------------------------------------------------------------
  // Email
  // ---------------------------------------------------------------------------

  /// Validates that [email] matches a standard email format.
  ///
  /// Returns `null` if valid, [InvalidEmailError] if invalid.
  /// Does not verify the email actually exists — that is the server's job.
  static AppError? validateEmail(String email) {
    if (email.trim().isEmpty) {
      return EmptyFieldError(fieldName: AppStrings.emailLabel);
    }

    // RFC 5322 simplified: local@domain.tld
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email.trim())) {
      return InvalidEmailError();
    }

    return null;
  }

  // ---------------------------------------------------------------------------
  // Phone
  // ---------------------------------------------------------------------------

  /// Validates that [phone] starts with '+' and contains 10–15 digits.
  ///
  /// Returns `null` if valid, [InvalidPhoneError] if invalid.
  /// The country code prefix is required per the approved architecture
  /// (matches the API's `phone_number` field format).
  static AppError? validatePhone(String phone) {
    if (phone.trim().isEmpty) {
      return EmptyFieldError(fieldName: AppStrings.phoneLabel);
    }

    // Must start with '+' followed by 10-15 digits
    final phoneRegex = RegExp(r'^\+\d{10,15}$');

    if (!phoneRegex.hasMatch(phone.trim())) {
      return InvalidPhoneError();
    }

    return null;
  }

  // ---------------------------------------------------------------------------
  // Required Field
  // ---------------------------------------------------------------------------

  /// Validates that [value] is non-empty after trimming whitespace.
  ///
  /// Returns `null` if valid, [EmptyFieldError] with [fieldName] if empty.
  static AppError? validateRequired(String value, {required String fieldName}) {
    if (value.trim().isEmpty) {
      return EmptyFieldError(fieldName: fieldName);
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // Date
  // ---------------------------------------------------------------------------

  /// Validates that [date] is in the future (after the current moment).
  ///
  /// Returns `null` if valid, [InvalidDateError] if the date is in the past.
  /// Used by the booking wizard to prevent scheduling pickups for yesterday.
  static AppError? validateFutureDate(DateTime date) {
    if (date.isBefore(DateTime.now())) {
      return InvalidDateError();
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // Password
  // ---------------------------------------------------------------------------

  /// Validates that [password] meets minimum security requirements.
  ///
  /// Rules:
  /// - At least 8 characters
  ///
  /// Returns `null` if valid, [EmptyFieldError] if empty.
  static AppError? validatePassword(String password) {
    if (password.isEmpty) {
      return EmptyFieldError(fieldName: AppStrings.passwordLabel);
    }

    if (password.length < 8) {
      return EmptyFieldError(fieldName: AppStrings.passwordMinLengthLabel);
    }

    return null;
  }

  // ---------------------------------------------------------------------------
  // Username
  // ---------------------------------------------------------------------------

  /// Validates that [username] is non-empty and contains only allowed
  /// characters (alphanumeric, underscores, dots).
  static AppError? validateUsername(String username) {
    if (username.trim().isEmpty) {
      return EmptyFieldError(fieldName: AppStrings.usernameLabel);
    }

    final usernameRegex = RegExp(r'^[a-zA-Z0-9._]+$');
    if (!usernameRegex.hasMatch(username.trim())) {
      return EmptyFieldError(
        fieldName: AppStrings.usernameFormatLabel,
      );
    }

    return null;
  }
}
