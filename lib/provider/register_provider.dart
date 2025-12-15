// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class RegisterProvider with ChangeNotifier {
//   // -----------------------------------------------------------
//   // 1. STATE MANAGEMENT
//   // -----------------------------------------------------------
//   static const String _registerUrl = 'https://suchigoapi.pythonanywhere.com/api/register/';

//   String _name = '';
//   String _email = '';
//   String _phone = '';
//   String _password = '';
//   bool _termsAccepted = false;

//   bool _isLoading = false;
//   String? _errorMessage;

//   // Getters
//   String get name => _name;
//   String get email => _email;
//   String get phone => _phone;
//   String get password => _password;
//   bool get termsAccepted => _termsAccepted;
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;

//   // Simple validation logic used by the 'CONTINUE' button
//   bool get isValid => 
//       _name.isNotEmpty &&
//       _email.isNotEmpty &&
//       _phone.isNotEmpty &&
//       _password.isNotEmpty &&
//       _termsAccepted;

//   // Setters
//   void setName(String value) { _name = value; notifyListeners(); }
//   void setEmail(String value) { _email = value; notifyListeners(); }
//   void setPhone(String value) { _phone = value; notifyListeners(); }
//   void setPassword(String value) { _password = value; notifyListeners(); }
//   void setTermsAccepted(bool value) { _termsAccepted = value; notifyListeners(); }
//   void clearError() { _errorMessage = null; notifyListeners(); }

//   // -----------------------------------------------------------
//   // 2. API REGISTRATION LOGIC
//   // -----------------------------------------------------------
//   Future<bool> registerUser() async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();

//     // Helper to get first and last name from a single name field
//     List<String> nameParts = _name.trim().split(' ');
//     String firstName = nameParts.isNotEmpty ? nameParts.first : _name;
//     String lastName = nameParts.length > 1 ? nameParts.last : '';
//     String userName = firstName.toLowerCase(); // Use first name as username for simplicity

//     try {
//       final response = await http.post(
//         Uri.parse(_registerUrl),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(<String, String>{
//           // CRITICAL FIX: MAPPING TO API REQUIRED KEYS
//           'username': userName,        // Added 'username' (derived from name)
//           'email': _email,
//           'password': _password,
//           'first_name': firstName,     // Added 'first_name' (derived from name)
//           'last_name': lastName,       // Added 'last_name' (derived from name)
//           'phone_number': _phone,      // Changed 'phone' to 'phone_number'
//         }),
//       );

//       _isLoading = false;

//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         // Successful registration (200 or 201)
//         final responseBody = jsonDecode(response.body);
//         print('Registration Successful: $responseBody');
//         notifyListeners();
//         return true;
//       } else {
//         // Registration Failed (e.g., 400 Bad Request)
        
//         try {
//           final errorBody = jsonDecode(response.body);
          
//           // CRITICAL: Now checking for all required fields including the new ones
//           if (errorBody.containsKey('email') && errorBody['email'] is List && errorBody['email'].isNotEmpty) {
//             _errorMessage = 'Email Error: ${errorBody['email'][0]}';
//           } else if (errorBody.containsKey('username') && errorBody['username'] is List && errorBody['username'].isNotEmpty) {
//             _errorMessage = 'Username Error: ${errorBody['username'][0]}';
//           } else if (errorBody.containsKey('phone_number') && errorBody['phone_number'] is List && errorBody['phone_number'].isNotEmpty) {
//             _errorMessage = 'Phone Error: ${errorBody['phone_number'][0]}'; // Check for new phone_number key
//           } else if (errorBody.containsKey('password') && errorBody['password'] is List && errorBody['password'].isNotEmpty) {
//             _errorMessage = 'Password Error: ${errorBody['password'][0]}';
//           } else if (errorBody.containsKey('non_field_errors') && errorBody['non_field_errors'] is List && errorBody['non_field_errors'].isNotEmpty) {
//             _errorMessage = errorBody['non_field_errors'][0];
//           } else if (errorBody.containsKey('detail')) {
//             _errorMessage = errorBody['detail'];
//           } else if (errorBody.containsKey('message')) {
//             _errorMessage = errorBody['message'];
//           } else {
//             // Fallback: Print the raw response to find any other missing keys
//             _errorMessage = 'Registration failed (Status: ${response.statusCode}). Please check all fields.';
//             print('--- RAW API ERROR RESPONSE START ---');
//             print('Status Code: ${response.statusCode}');
//             print('Response Body: ${response.body}');
//             print('--- RAW API ERROR RESPONSE END ---');
//           }
//         } catch (e) {
//           // If the server returned a non-JSON error
//           _errorMessage = 'Registration failed (Status: ${response.statusCode}). Server response unreadable.';
//           print('Error decoding registration response: $e');
//         }
        
//         print('Registration Failed: ${_errorMessage}');
//         notifyListeners();
//         return false;
//       }
//     } catch (e) {
//       // Handle network errors
//       _isLoading = false;
//       _errorMessage = 'Network error. Could not connect to the server.';
//       print('Network Error during registration: $e');
//       notifyListeners();
//       return false;
//     }
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterProvider with ChangeNotifier {
  // -----------------------------------------------------------
  // 1. STATE MANAGEMENT
  // -----------------------------------------------------------
  static const String _registerUrl = 'https://suchigoapi.pythonanywhere.com/api/register/';

  String _username = ''; 
  String _firstName = ''; 
  String _lastName = ''; 
  String _email = '';
  String _phone = '';
  String _password = '';

  bool _termsAccepted = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters (omitted for brevity, assume they are correct)
  String get username => _username;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get email => _email;
  String get phone => _phone;
  String get password => _password;
  bool get termsAccepted => _termsAccepted;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Validation logic remains the same (checks for non-empty)
  bool get isValid => 
      _username.isNotEmpty &&
      _firstName.isNotEmpty &&
      _lastName.isNotEmpty &&
      _email.isNotEmpty &&
      _phone.isNotEmpty &&
      _password.isNotEmpty &&
      _termsAccepted;

  // Setters (trims whitespace defensively)
  void setUsername(String value) { _username = value.trim(); notifyListeners(); }
  void setFirstName(String value) { _firstName = value.trim(); notifyListeners(); }
  void setLastName(String value) { _lastName = value.trim(); notifyListeners(); }
  void setEmail(String value) { _email = value.trim(); notifyListeners(); }
  void setPhone(String value) { _phone = value.trim(); notifyListeners(); }
  void setPassword(String value) { _password = value; notifyListeners(); }
  void setTermsAccepted(bool value) { _termsAccepted = value; notifyListeners(); }
  void clearError() { _errorMessage = null; notifyListeners(); }

  // -----------------------------------------------------------
  // 2. API REGISTRATION LOGIC
  // -----------------------------------------------------------
  Future<bool> registerUser() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Defensive validation check for phone format (optional but helpful)
    if (_phone.isNotEmpty && !_phone.startsWith('+')) {
      _isLoading = false;
      _errorMessage = 'Phone number should include the country code, starting with "+".';
      notifyListeners();
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse(_registerUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': _username,
          'email': _email,
          'password': _password,
          'first_name': _firstName,
          'last_name': _lastName,
          'phone_number': _phone,
        }),
      );

      _isLoading = false;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Successful registration
        final responseBody = jsonDecode(response.body);
        print('Registration Successful: $responseBody');
        notifyListeners();
        return true;
      } else {
        // Registration Failed (4xx or 5xx status)
        String rawBody = response.body;
        
        // --- IMPROVED ERROR HANDLING LOGIC ---
        try {
          final errorBody = jsonDecode(rawBody);
          String keyMessage = '';
          
          // List of common API keys to check for errors
          for (var key in ['username', 'email', 'phone_number', 'password', 'first_name', 'last_name', 'non_field_errors', 'detail', 'message']) {
              if (errorBody.containsKey(key)) {
                 final value = errorBody[key];
                 if (value is List && value.isNotEmpty) {
                     keyMessage = '$key: ${value[0]}';
                     break;
                 } else if (value is String) {
                     keyMessage = '$key: $value';
                     break;
                 }
              }
          }

          if (keyMessage.isNotEmpty) {
              _errorMessage = keyMessage;
          } else {
              // Server sent JSON but no recognized error key (still unexpected format)
              _errorMessage = 'Registration failed (Status: ${response.statusCode}). Unrecognized JSON error format.';
          }
        } catch (e) {
          // Server did NOT send valid JSON (this is where the 500 error lands)
          String truncatedBody = rawBody.length > 50 ? rawBody.substring(0, 50) + '...' : rawBody;
          
          // CRITICAL: Display the raw server response body if we can't parse it
          _errorMessage = 'API Error (Status: ${response.statusCode}). Raw response: "$truncatedBody"';
          
          print('--- RAW API ERROR RESPONSE START ---');
          print('Status Code: ${response.statusCode}');
          print('Response Body: $rawBody');
          print('--- RAW API ERROR RESPONSE END ---');
        }
        
        notifyListeners();
        return false;
      }
    } catch (e) {
      // Handle network errors
      _isLoading = false;
      _errorMessage = 'Network error. Could not connect to the server.';
      notifyListeners();
      return false;
    }
  }
}