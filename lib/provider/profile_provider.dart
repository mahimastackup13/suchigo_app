import 'package:flutter/material.dart';
import 'package:suchigo_app/Screens.dart/home_screen.dart';

class ProfileProvider extends ChangeNotifier {
  String _username = "John Doe";
  String _phoneNumber = "+917736905991";
  String _profileImagePath = 'assets/icons/pic.png';

  String get username => _username;
  String get phoneNumber => _phoneNumber;
  String get profileImagePath => _profileImagePath;

  int _selectedIndex = 3;
  int get selectedIndex => _selectedIndex;

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
