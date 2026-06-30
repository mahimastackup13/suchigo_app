// File: provider/login_provider.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:suchigo_app/services/api_client.dart';
import 'package:suchigo_app/services/secure_storage_service.dart';

class LoginProvider extends ChangeNotifier {
  static const String _loginPath = 'login/';

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // ApiClient.instance is a Dio instance (not a wrapper), so we call
      // Dio's own .post() directly. noAuth: true matters here -- there is
      // no token yet, and skipAuthRedirect: true means if the backend ever
      // sends back a 401 for bad credentials, the global interceptor won't
      // force-navigate to /login (which would be a no-op/confusing loop
      // since we're already on the login screen) -- it lets this catch
      // block show the real error message instead.
      final response = await ApiClient.instance.post(
        _loginPath,
        data: {'username': username, 'password': password},
        options: Options(
          extra: {'noAuth': true, 'skipAuthRedirect': true},
        ),
      );

      final body = response.data is Map
          ? response.data as Map<String, dynamic>
          : <String, dynamic>{};

      final String? token = body['token'] ?? body['access'];
      if (token == null || token.isEmpty) {
        _isLoading = false;
        _errorMessage = 'Login succeeded but no token was returned.';
        notifyListeners();
        return false;
      }

      await SecureStorageService.saveToken(token);

      // Many DRF token-login endpoints (e.g. drf-authtoken's
      // ObtainAuthToken) return ONLY {"token": "..."} and nothing else.
      // Don't assume display_name/phone are present here -- the real
      // source of truth for those is GET /api/profile/, fetched right
      // after login by ProfileProvider.refresh(). We save whatever the
      // login response happens to include as a fast first paint, no more.
      final String fallbackUsername = body['username'] ?? username;
      await SecureStorageService.saveUsername(fallbackUsername);

      final String? displayName = body['display_name'];
      if (displayName != null && displayName.isNotEmpty) {
        await SecureStorageService.saveDisplayName(displayName);
      }

      final String? phone = body['phone_number'] ?? body['phone'];
      if (phone != null && phone.isNotEmpty) {
        await SecureStorageService.savePhoneNumber(phone);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } on DioException catch (e) {
      _isLoading = false;
      _errorMessage = _extractErrorMessage(e);
      debugPrint('Login failed: $_errorMessage');
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Network error. Please check your internet connection.';
      debugPrint('Error during login: $e');
      notifyListeners();
      return false;
    }
  }

  String _extractErrorMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      if (data['detail'] != null) return data['detail'].toString();
      if (data['non_field_errors'] is List &&
          (data['non_field_errors'] as List).isNotEmpty) {
        return data['non_field_errors'][0].toString();
      }
      if (data['message'] != null) return data['message'].toString();
    }
    final status = e.response?.statusCode;
    if (status == 400) return 'Invalid username or password.';
    if (status == 401) return 'Invalid credentials.';
    return 'Login failed (Status: ${status ?? "network error"}).';
  }

  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    await SecureStorageService.clearAll();
    if (!context.mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }
}
