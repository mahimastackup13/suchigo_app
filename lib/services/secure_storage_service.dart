import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  static const _tokenKey = 'auth_token';
  static const _usernameKey = 'auth_username';
  static const _displayNameKey = 'auth_display_name';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> saveUsername(String username) async {
    await _storage.write(key: _usernameKey, value: username);
  }

  static Future<String?> getUsername() async {
    return await _storage.read(key: _usernameKey);
  }

  static Future<void> saveDisplayName(String displayName) async {
    await _storage.write(key: _displayNameKey, value: displayName);
  }

  static Future<String?> getDisplayName() async {
    return await _storage.read(key: _displayNameKey);
  }

  static Future<void> savePhoneNumber(String phoneNumber) async {
    await _storage.write(key: 'auth_phone', value: phoneNumber);
  }

  static Future<String?> getPhoneNumber() async {
    return await _storage.read(key: 'auth_phone');
  }

  static Future<void> saveEmail(String email) async {
    await _storage.write(key: 'auth_email', value: email);
  }

  static Future<String?> getEmail() async {
    return await _storage.read(key: 'auth_email');
  }

  static Future<void> saveRefills(String refillsJson) async {
    await _storage.write(key: 'wallet_refills', value: refillsJson);
  }

  static Future<String?> getRefills() async {
    return await _storage.read(key: 'wallet_refills');
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
