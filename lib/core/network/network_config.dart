import 'package:suchigo_app/core/constants/api_constants.dart';

/// Centralised configuration for network resilience.
///
/// Dictates timeout thresholds, retry strategies, and backoff multipliers.
abstract final class NetworkConfig {
  /// Base timeout for a single HTTP request attempt.
  static const Duration requestTimeout = ApiConstants.requestTimeout;

  /// Maximum number of retry attempts for idempotent requests.
  static const int maxRetries = 3;

  /// Initial backoff delay before the first retry.
  static const Duration initialRetryDelay = Duration(milliseconds: 500);

  /// Multiplier applied to the backoff delay after each retry.
  static const double backoffMultiplier = 2.0;

  /// Maximum backoff delay between retries.
  static const Duration maxRetryDelay = Duration(seconds: 5);
}
