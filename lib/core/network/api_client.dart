import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:suchigo_app/core/constants/api_constants.dart';
import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/core/errors/error_mapper.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/core/network/api_interceptor.dart';
import 'package:suchigo_app/core/network/connectivity_service.dart';
import 'package:suchigo_app/core/network/network_config.dart';
import 'package:suchigo_app/core/network/retry_policy.dart';
import 'package:suchigo_app/core/utils/app_logger.dart';

/// Core HTTP client for all SuchiGo API communication.
///
/// Wraps `package:http` to provide:
/// - A `Result<T>` return type (no thrown exceptions beyond this boundary).
/// - Automatic JWT injection via [ApiInterceptor].
/// - Request and response logging via [AppLogger].
/// - Timeout enforcement via [ApiConstants.requestTimeout].
/// - Typed error mapping via [ErrorMapper].
///
/// All feature repositories must use this class — direct use of
/// `http.Client` or `http.get/post` is prohibited.
class ApiClient {
  final http.Client _httpClient;
  final ApiInterceptor _interceptor;
  final ConnectivityService _connectivity;

  ApiClient({
    http.Client? httpClient,
    // ignore: prefer_initializing_formals — field is private, cannot use initializing formal
    required ApiInterceptor interceptor,
    ConnectivityService? connectivity,
  })  : _httpClient = httpClient ?? http.Client(),
        _interceptor = interceptor,
        _connectivity = connectivity ?? ConnectivityService();

  // ---------------------------------------------------------------------------
  // Public HTTP Verbs
  // ---------------------------------------------------------------------------

  /// Sends a GET request to [uri].
  ///
  ///
  /// [requiresAuth]: when `true`, the [ApiInterceptor] attaches a JWT header.
  /// [retry]: when `true`, applies exponential backoff for transient failures.
  Future<Result<Map<String, dynamic>>> get(
    Uri uri, {
    bool requiresAuth = true,
    bool retry = true,
  }) async {
    return _execute(
      method: 'GET',
      uri: uri,
      requiresAuth: requiresAuth,
      retry: retry,
      builder: (headers) => http.Request('GET', uri)..headers.addAll(headers),
    );
  }

  /// Sends a POST request to [uri] with a JSON [body].
  Future<Result<Map<String, dynamic>>> post(
    Uri uri, {
    required Map<String, dynamic> body,
    bool requiresAuth = true,
    bool retry = false,
  }) async {
    return _execute(
      method: 'POST',
      uri: uri,
      requiresAuth: requiresAuth,
      retry: retry,
      builder: (headers) => http.Request('POST', uri)
        ..headers.addAll(headers)
        ..body = jsonEncode(body),
    );
  }

  /// Sends a PUT request to [uri] with a JSON [body].
  Future<Result<Map<String, dynamic>>> put(
    Uri uri, {
    required Map<String, dynamic> body,
    bool requiresAuth = true,
    bool retry = false,
  }) async {
    return _execute(
      method: 'PUT',
      uri: uri,
      requiresAuth: requiresAuth,
      retry: retry,
      builder: (headers) => http.Request('PUT', uri)
        ..headers.addAll(headers)
        ..body = jsonEncode(body),
    );
  }

  /// Sends a DELETE request to [uri].
  Future<Result<Map<String, dynamic>>> delete(
    Uri uri, {
    bool requiresAuth = true,
    bool retry = false,
  }) async {
    return _execute(
      method: 'DELETE',
      uri: uri,
      requiresAuth: requiresAuth,
      retry: retry,
      builder: (headers) =>
          http.Request('DELETE', uri)..headers.addAll(headers),
    );
  }

  // ---------------------------------------------------------------------------
  // Core Execution Engine
  // ---------------------------------------------------------------------------

  Future<Result<Map<String, dynamic>>> _execute({
    required String method,
    required Uri uri,
    required bool requiresAuth,
    required bool retry,
    required http.Request Function(Map<String, String> headers) builder,
  }) async {
    // 1. Connectivity fail-fast
    if (!await _connectivity.isConnected) {
      AppLogger.warning('No internet connection. Failing fast for $method ${uri.path}');
      return Failure(NoInternetError());
    }

    // 2. Build base headers
    final headers = Map<String, String>.from(ApiConstants.jsonHeaders);

    // 3. Inject auth token if required
    if (requiresAuth) {
      final authResult = await _interceptor.attachAuthHeader(headers);
      if (authResult is Failure<void>) {
        return Failure(authResult.error);
      }
    }

    AppLogger.debug('→ $method ${uri.path}');

    // 4. Execute request with/without retry
    try {
      final response = await _executeWithPolicy(
        builder: builder,
        headers: headers,
        retry: retry,
      );

      AppLogger.info('← ${response.statusCode} ${uri.path}');
      return await _handleResponse(response);
    } on TimeoutException {
      AppLogger.error('Timeout: $method ${uri.path}');
      return Failure(TimeoutError());
    } on SocketException catch (e, st) {
      AppLogger.error('No internet: $method ${uri.path}', error: e, stackTrace: st);
      return Failure(NoInternetError());
    } catch (e, st) {
      AppLogger.error('Unexpected: $method ${uri.path}', error: e, stackTrace: st);
      return Failure(ErrorMapper.map(e));
    }
  }

  Future<http.Response> _executeWithPolicy({
    required http.Request Function(Map<String, String> headers) builder,
    required Map<String, String> headers,
    required bool retry,
  }) async {
    Future<http.Response> task() async {
      // Rebuild the request on every attempt because http.Request can only be sent once
      final request = builder(headers);
      final streamedResponse = await _httpClient
          .send(request)
          .timeout(NetworkConfig.requestTimeout);
      return http.Response.fromStream(streamedResponse);
    }

    if (retry) {
      return RetryPolicy.execute(task);
    } else {
      return task();
    }
  }

  // ---------------------------------------------------------------------------
  // Response Handling
  // ---------------------------------------------------------------------------

  Future<Result<Map<String, dynamic>>> _handleResponse(http.Response response) async {
    final statusCode = response.statusCode;
    final body = response.body;

    // 2xx — success
    if (statusCode >= 200 && statusCode < 300) {
      if (body.isEmpty) {
        // 204 No Content or empty 200
        return const Success({});
      }
      try {
        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic>) {
          return Success(decoded);
        }
        // Some endpoints return a JSON array; wrap for consistency
        return Success({'data': decoded});
      } on FormatException catch (e, st) {
        AppLogger.error('Failed to parse response body', error: e, stackTrace: st);
        return Failure(ParseError(rawBody: body));
      }
    }

    // 401 — await interceptor session cleanup, then return typed error
    if (statusCode == 401) {
      await _interceptor.handle401();
      return Failure(ErrorMapper.mapHttpStatus(statusCode, body));
    }

    // All other non-2xx
    final error = ErrorMapper.mapHttpStatus(statusCode, body);
    AppLogger.error('HTTP $statusCode: ${error.debugMessage}');
    return Failure(error);
  }

  /// Releases underlying resources. Call on app disposal.
  void dispose() => _httpClient.close();
}
