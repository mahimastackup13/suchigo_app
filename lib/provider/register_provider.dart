import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterProvider extends ChangeNotifier {
  String _name = '';
  String _email = '';
  String _phone = '';
  bool _termsAccepted = false;

  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  bool get termsAccepted => _termsAccepted;

  bool get isValid =>
      _name.trim().isNotEmpty &&
      _email.trim().isNotEmpty &&
      _phone.trim().isNotEmpty &&
      _termsAccepted;

  void setName(String value) {
    _name = value;
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPhone(String value) {
    _phone = value;
    notifyListeners();
  }

  void setTermsAccepted(bool value) {
    _termsAccepted = value;
    notifyListeners();
  }

  // API call
  Future<Map<String, dynamic>> registerUser() async {
    // final url = Uri.parse('http://127.0.0.1:8000/api/register/');
    final String baseUrl = "https://lumoskart.pythonanywhere.com/api/register/";
    final url = Uri.parse('$baseUrl/register/');
    final body = {
      'name': _name,
      'email': _email,
      'phone': _phone,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return {'success': true, 'data': jsonDecode(response.body)};
    } else {
      return {
        'success': false,
        'message': jsonDecode(response.body)['message'] ??
            'Registration failed'
      };
    }
  }
}
