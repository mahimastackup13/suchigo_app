import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:suchigo_app/core/network/network_config.dart';
import 'package:suchigo_app/core/utils/app_logger.dart';

/// Implements exponential backoff retry logic for network requests.
class RetryPolicy {
  /// Executes [task] with an exponential backoff strategy.
  ///
  /// Retries are triggered if:
  /// - A [SocketException] or [TimeoutException] is thrown.
  /// - The server returns a 5xx HTTP status code.
  ///
  /// Returns the successful [http.Response], the final failed response (e.g. 5xx),
  /// or rethrows the final exception if all retries are exhausted.
  static Future<http.Response> execute(
    Future<http.Response> Function() task, {
    int maxRetries = NetworkConfig.maxRetries,
  }) async {
    int attempt = 0;
    Duration delay = NetworkConfig.initialRetryDelay;

    while (true) {
      try {
        final response = await task();

        // If it's a 5xx server error, and we haven't exhausted retries, throw
        // an exception to trigger the catch block for retry.
        if (response.statusCode >= 500 && attempt < maxRetries) {
          throw HttpException('Server Error ${response.statusCode}');
        }

        return response;
      } catch (e) {
        if (!_shouldRetry(e) || attempt >= maxRetries) {
          rethrow;
        }

        attempt++;
        AppLogger.warning(
          'Network attempt $attempt/$maxRetries failed. Retrying in ${delay.inMilliseconds}ms...',
        );

        await Future.delayed(delay);

        // Calculate next delay using exponential backoff
        delay = Duration(
          milliseconds: (delay.inMilliseconds * NetworkConfig.backoffMultiplier)
              .toInt()
              .clamp(0, NetworkConfig.maxRetryDelay.inMilliseconds),
        );
      }
    }
  }

  /// Determines if an exception warrants a retry.
  static bool _shouldRetry(Object exception) {
    return exception is SocketException ||
        exception is TimeoutException ||
        exception is HttpException;
  }
}
