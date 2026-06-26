import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:suchigo_app/services/secure_storage_service.dart';

// Global navigator key for navigation outside UI context
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://suchigoapis.pythonanywhere.com/api/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  static Dio get instance {
    _dio.interceptors.clear();
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add token to headers if available
          final token = await SecureStorageService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            debugPrint("401 Unauthorized detected. Flushing storage and redirecting...");
            
            // Flush storage
            await SecureStorageService.clearAll();

            // Force navigation to LoginScreen
            if (navigatorKey.currentState != null) {
              navigatorKey.currentState!.pushNamedAndRemoveUntil('/login', (route) => false);
            }
          }
          return handler.next(e);
        },
      ),
    );
    return _dio;
  }
}
