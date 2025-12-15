// 
// File: provider/login_provider.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginProvider extends ChangeNotifier {
  // Your API endpoint for login.
  static const String _loginUrl = 'https://suchigoapi.pythonanywhere.com/api/login/';
  
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Method to perform the login
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(_loginUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          // CRITICAL: Ensure 'username' and 'password' are the exact keys expected by the API
          'username': username, 
          'password': password,
        }),
      );

      _isLoading = false;

      if (response.statusCode == 200) {
        // Successful login
        final responseBody = jsonDecode(response.body);
        
        // 1. You should save the returned token/user data here.
        // For example: String token = responseBody['token'];
        print('Login Successful: ${responseBody}');
        notifyListeners();
        return true;
      } else {
        // Handle login failure (e.g., 400 Bad Request, 401 Unauthorized)
        
        // Try to decode the body to get the specific error message
        try {
          final responseBody = jsonDecode(response.body);
          
          // 2. Adjust this logic based on your API's error response structure:
          if (responseBody.containsKey('detail')) {
            _errorMessage = responseBody['detail'];
          } else if (responseBody.containsKey('non_field_errors')) {
            _errorMessage = responseBody['non_field_errors'][0];
          } else if (responseBody.containsKey('message')) {
            _errorMessage = responseBody['message'];
          } else {
              // Fallback if the error format is unexpected
            _errorMessage = 'Login failed (Status: ${response.statusCode}). Check credentials.';
          }
          
        } catch (e) {
          _errorMessage = 'Login failed (Status: ${response.statusCode}). Server response unreadable.';
        }
        
        print('Login Failed: ${_errorMessage}');
        notifyListeners();
        return false;
      }
    } catch (e) {
      
      _isLoading = false;
      _errorMessage = 'Network error. Please check your internet connection.';
      print('Error during login: $e');
      notifyListeners();
      return false;
    }
  }

  
  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }
}