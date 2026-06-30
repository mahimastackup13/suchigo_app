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
            final isNoAuth = options.extra['noAuth'] == true;

            if (!isNoAuth) {
              final token = await SecureStorageService.getToken();
              if (token != null && token.isNotEmpty) {
                // *** THE FIX ***
                // was: options.headers['Authorization'] = 'Bearer $token';
                options.headers['Authorization'] = 'Token $token';
              }
            }

            return handler.next(options);
          },
          onError: (DioException e, handler) async {
            final statusCode = e.response?.statusCode;

            if (kDebugMode) {
              debugPrint(
                '[ApiClient] ERROR ${e.requestOptions.method} '
                '${e.requestOptions.path} -> status=$statusCode '
                'body=${e.response?.data}',
              );
            }

            final skipRedirect =
                e.requestOptions.extra['skipAuthRedirect'] == true;

            if (statusCode == 401 && !skipRedirect) {
              if (kDebugMode) {
                debugPrint(
                  '[ApiClient] 401 with no skip flag — clearing session and redirecting to /login',
                );
              }
              await SecureStorageService.clearAll();

              if (navigatorKey.currentState != null) {
                navigatorKey.currentState!.pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
              }
            } else if (statusCode == 401 && skipRedirect) {
              if (kDebugMode) {
                debugPrint(
                  '[ApiClient] 401 with skipAuthRedirect=true — NOT redirecting, letting caller handle it',
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
