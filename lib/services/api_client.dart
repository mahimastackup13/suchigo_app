// 
// services/api_client.dart
//
// THIS IS YOUR REAL FILE. The only functional change from what you currently
// have is the single line in onRequest marked "*** THE FIX ***" below:
// 'Bearer $token' -> 'Token $token'.
//
// Why this matters: DRF's TokenAuthentication parses the Authorization
// header by splitting on whitespace and checking that the first word
// matches its configured keyword, which defaults to the literal string
// "Token". "Bearer" is a different scheme entirely (associated with
// OAuth2/JWT). Sending "Bearer <key>" makes DRF treat the header as
// unrecognized, so the request falls through as unauthenticated -- a 401 --
// even though the key itself is perfectly valid. This is one bug hitting
// every authenticated endpoint in the app (profile/, addresses/, pickups/),
// not several separate ones.

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:suchigo_app/services/secure_storage_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://suchigoapis.pythonanywhere.com/api/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  static bool _interceptorsAttached = false;

  static Dio get instance {
    if (!_interceptorsAttached) {
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            print('[ApiClient] REQUEST: ${options.method} ${options.baseUrl}${options.path}');
            if (options.queryParameters.isNotEmpty) {
              print('[ApiClient] REQUEST QueryParams: ${options.queryParameters}');
            }
            print('[ApiClient] REQUEST Headers: ${options.headers}');
            print('[ApiClient] REQUEST Data: ${options.data}');
            final isNoAuth = options.extra['noAuth'] == true;

            if (!isNoAuth) {
              final token = await SecureStorageService.getToken();
              if (token != null && token.isNotEmpty) {
                options.headers['Authorization'] = 'Token $token';
              }
            }

            return handler.next(options);
          },
          onResponse: (response, handler) {
            print('[ApiClient] RESPONSE: ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.baseUrl}${response.requestOptions.path}');
            print('[ApiClient] RESPONSE Data: ${response.data}');
            return handler.next(response);
          },
          onError: (DioException e, handler) async {
            final statusCode = e.response?.statusCode;
            print('[ApiClient] ERROR: ${e.requestOptions.method} ${e.requestOptions.path} -> status=$statusCode');
            print('[ApiClient] ERROR Response Body: ${e.response?.data}');

            final skipRedirect =
                e.requestOptions.extra['skipAuthRedirect'] == true;

            if (statusCode == 401 && !skipRedirect) {
              await SecureStorageService.clearAll();

              if (navigatorKey.currentState != null) {
                navigatorKey.currentState!.pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
              }
            }

            return handler.next(e);
          },
        ),
      );
      _interceptorsAttached = true;
    }
    return _dio;
  }
}
