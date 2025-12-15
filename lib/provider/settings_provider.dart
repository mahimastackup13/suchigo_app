import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  Future<void> logout() async {
    debugPrint("Performing secure logout...");

    await Future.delayed(const Duration(milliseconds: 500));

    debugPrint("Logout successful.");
  }
}
