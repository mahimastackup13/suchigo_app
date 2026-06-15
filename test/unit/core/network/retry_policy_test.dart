import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:suchigo_app/core/network/retry_policy.dart';

void main() {
  group('RetryPolicy', () {
    test('executes task successfully on first try', () async {
      int attempts = 0;
      final response = await RetryPolicy.execute(() async {
        attempts++;
        return http.Response('OK', 200);
      });

      expect(attempts, 1);
      expect(response.statusCode, 200);
    });

    test('retries on SocketException and succeeds', () async {
      int attempts = 0;
      final response = await RetryPolicy.execute(() async {
        attempts++;
        if (attempts == 1) {
          throw const SocketException('No internet');
        }
        return http.Response('OK', 200);
      });

      expect(attempts, 2);
      expect(response.statusCode, 200);
    });

    test('retries on 500 status code and succeeds', () async {
      int attempts = 0;
      final response = await RetryPolicy.execute(() async {
        attempts++;
        if (attempts == 1) {
          return http.Response('Server Error', 500);
        }
        return http.Response('OK', 200);
      });

      expect(attempts, 2);
      expect(response.statusCode, 200);
    });

    test('does NOT retry on 400 Client Error', () async {
      int attempts = 0;
      final response = await RetryPolicy.execute(() async {
        attempts++;
        return http.Response('Bad Request', 400);
      });

      expect(attempts, 1);
      expect(response.statusCode, 400);
    });

    test('exhausts retries and throws exception', () async {
      int attempts = 0;
      
      await expectLater(
        () async => await RetryPolicy.execute(() async {
          attempts++;
          throw const SocketException('Dead connection');
        }, maxRetries: 2),
        throwsA(isA<SocketException>()),
      );

      // 1 initial attempt + 2 retries = 3 total attempts
      expect(attempts, 3);
    });
  });
}
