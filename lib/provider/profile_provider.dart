import 'package:flutter/material.dart';
import 'package:suchigo_app/Screens.dart/home_screen.dart';
import 'package:suchigo_app/services/api_client.dart';
import 'package:suchigo_app/services/secure_storage_service.dart';

class ProfileProvider extends ChangeNotifier {
  String _username = "John Doe";
  String _phoneNumber = "+917736905991";
  String _profileImagePath = 'assets/icons/pic.png';

  String get username => _username;
  String get phoneNumber => _phoneNumber;
  String get profileImagePath => _profileImagePath;

  int _selectedIndex = 3;
  int get selectedIndex => _selectedIndex;

  ProfileProvider() {
    _hydrateProfile();
  }

  Future<void> _hydrateProfile() async {
    // 1. Optimistic UI: Load from local cache first
    final localUsername = await SecureStorageService.getUsername();
    final localPhone = await SecureStorageService.getPhoneNumber();
    
    bool updatedLocal = false;
    if (localUsername != null && localUsername.isNotEmpty) {
      _username = localUsername;
      updatedLocal = true;
    }
    if (localPhone != null && localPhone.isNotEmpty) {
      _phoneNumber = localPhone;
      updatedLocal = true;
    }
    
    if (updatedLocal) {
      notifyListeners();
    }

    // 2. Background fetch to sync with source of truth
    try {
      final response = await ApiClient.instance.get('profile/');
      if (response.statusCode == 200) {
        _username = response.data['username'] ?? _username;
        _phoneNumber = response.data['phone_number'] ?? response.data['phone'] ?? _phoneNumber;
        
        // Update cache
        await SecureStorageService.saveUsername(_username);
        await SecureStorageService.savePhoneNumber(_phoneNumber);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Optimistic UI API sync failed (possibly no endpoint yet or offline): $e");
    }
  }

  void onTabTapped(BuildContext context, int index) {
    if (index == _selectedIndex) return;

    _selectedIndex = index;
    notifyListeners();

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
    }
  }

  void handleProfileItemTap(BuildContext context, String text) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("$text tapped!")));
  }
}
