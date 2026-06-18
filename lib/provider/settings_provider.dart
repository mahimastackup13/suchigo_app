import 'package:flutter/material.dart';
import 'package:suchigo_app/services/secure_storage_service.dart';

class SettingsProvider extends ChangeNotifier {
  Future<void> logout() async {
    debugPrint("Performing secure logout...");
    await SecureStorageService.clearAll();
    debugPrint("Logout successful.");
  }
}
