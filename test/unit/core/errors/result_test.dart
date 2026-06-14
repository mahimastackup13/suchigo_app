import 'package:flutter_test/flutter_test.dart';
import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/core/errors/result.dart';

void main() {
  group('Result<T>', () {
    // -----------------------------------------------------------------------
    // Success
    // -----------------------------------------------------------------------
    group('Success', () {
      test('isSuccess returns true', () {
        const result = Success(42);
        expect(result.isSuccess, isTrue);
        expect(result.isFailure, isFalse);
      });

      test('data is accessible', () {
        const result = Success('hello');
        expect(result.data, 'hello');
      });

      test('equality works by value', () {
        expect(const Success(42), equals(const Success(42)));
        expect(const Success(42), isNot(equals(const Success(99))));
      });

      test('hashCode is consistent with equality', () {
        expect(const Success(42).hashCode, equals(const Success(42).hashCode));
      });

      test('toString contains data', () {
        expect(const Success('test').toString(), 'Success(test)');
      });
    });

    // -----------------------------------------------------------------------
    // Failure
    // -----------------------------------------------------------------------
    group('Failure', () {
      test('isFailure returns true', () {
        final result = Failure<int>(NoInternetError());
        expect(result.isFailure, isTrue);
        expect(result.isSuccess, isFalse);
      });

      test('error is accessible', () {
        final error = TokenExpiredError();
        final result = Failure<String>(error);
        expect(result.error, isA<TokenExpiredError>());
      });

      test('toString contains debug message', () {
        final result = Failure<int>(NoInternetError());
        expect(result.toString(), contains('NoInternetError'));
      });
    });

    // -----------------------------------------------------------------------
    // Pattern Matching
    // -----------------------------------------------------------------------
    group('Pattern matching', () {
      test('switch on Success extracts data', () {
        final Result<int> result = const Success(42);
        final value = switch (result) {
          Success(:final data) => data,
          Failure(:final error) => throw error,
        };
        expect(value, 42);
      });

      test('switch on Failure extracts error', () {
        final Result<int> result = Failure(TimeoutError());
        final message = switch (result) {
          Success() => 'ok',
          Failure(:final error) => error.userMessage,
        };
        expect(message, contains('too long'));
      });
    });

    // -----------------------------------------------------------------------
    // map
    // -----------------------------------------------------------------------
    group('map', () {
      test('transforms Success value', () {
        const result = Success(10);
        final mapped = result.map((data) => data * 2);
        expect(mapped, isA<Success<int>>());
        expect((mapped as Success<int>).data, 20);
      });

      test('passes Failure through unchanged', () {
        final error = NoInternetError();
        final Result<int> result = Failure(error);
        final mapped = result.map((data) => data.toString());
        expect(mapped, isA<Failure<String>>());
        expect((mapped as Failure<String>).error, isA<NoInternetError>());
      });

      test('map can change type', () {
        const Result<int> result = Success(42);
        final Result<String> mapped = result.map((data) => 'value: $data');
        expect((mapped as Success<String>).data, 'value: 42');
      });
    });

    // -----------------------------------------------------------------------
    // flatMap
    // -----------------------------------------------------------------------
    group('flatMap', () {
      test('chains Success into another Success', () async {
        const result = Success(5);
        final chained = await result.flatMap(
          (data) async => Success(data * 3),
        );
        expect(chained, isA<Success<int>>());
        expect((chained as Success<int>).data, 15);
      });

      test('chains Success into Failure', () async {
        const result = Success(5);
        final chained = await result.flatMap<String>(
          (data) async => Failure(ServerError(statusCode: 500)),
        );
        expect(chained, isA<Failure<String>>());
      });

      test('skips chain on Failure', () async {
        final Result<int> result = Failure(TimeoutError());
        var called = false;
        final chained = await result.flatMap<String>((data) async {
          called = true;
          return const Success('should not reach');
        });
        expect(called, isFalse);
        expect(chained, isA<Failure<String>>());
      });
    });

    // -----------------------------------------------------------------------
    // getOrElse
    // -----------------------------------------------------------------------
    group('getOrElse', () {
      test('returns data on Success', () {
        const result = Success(42);
        final value = result.getOrElse((_) => -1);
        expect(value, 42);
      });

      test('calls orElse on Failure', () {
        final Result<int> result = Failure(NoInternetError());
        final value = result.getOrElse((_) => -1);
        expect(value, -1);
      });

      test('orElse receives the error', () {
        final Result<String> result = Failure(
          ServerError(statusCode: 503),
        );
        final value = result.getOrElse((error) => error.userMessage);
        expect(value, contains('our end'));
      });
    });
  });
}
