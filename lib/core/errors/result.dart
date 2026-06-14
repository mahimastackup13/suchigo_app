import 'package:suchigo_app/core/errors/app_error.dart';

/// A discriminated union representing either a successful value or a failure.
///
/// Every repository method returns `Result<T>` instead of throwing exceptions.
/// Notifiers pattern-match on this to transition state:
///
/// ```dart
/// final result = await authRepository.login(credentials);
/// switch (result) {
///   case Success(:final data):
///     state = AuthState.authenticated(data);
///   case Failure(:final error):
///     state = AuthState.error(error);
/// }
/// ```
///
/// This eliminates try/catch in notifiers and makes the success/failure
/// contract explicit at the type level.
sealed class Result<T> {
  const Result();

  /// Returns `true` if this result is a [Success].
  bool get isSuccess => this is Success<T>;

  /// Returns `true` if this result is a [Failure].
  bool get isFailure => this is Failure<T>;

  /// Transforms the success value using [transform], leaving failures untouched.
  Result<R> map<R>(R Function(T data) transform) {
    return switch (this) {
      Success(:final data) => Success(transform(data)),
      Failure(:final error) => Failure(error),
    };
  }

  /// Chains an async operation that returns a new [Result], only if this is a
  /// [Success]. Failures pass through unchanged.
  Future<Result<R>> flatMap<R>(
    Future<Result<R>> Function(T data) transform,
  ) async {
    return switch (this) {
      Success(:final data) => transform(data),
      Failure(:final error) => Failure(error),
    };
  }

  /// Returns the success value or calls [orElse] with the error.
  T getOrElse(T Function(AppError error) orElse) {
    return switch (this) {
      Success(:final data) => data,
      Failure(:final error) => orElse(error),
    };
  }
}

/// Represents a successful result containing [data].
final class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Success<T> && other.data == data);

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Success($data)';
}

/// Represents a failed result containing an [AppError].
final class Failure<T> extends Result<T> {
  final AppError error;

  const Failure(this.error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Failure<T> && other.error == error);

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'Failure(${error.debugMessage})';
}
