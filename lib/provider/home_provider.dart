import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  void navigateToBillScreen() {
    setSelectedIndex(1);
  }

  int getBottomNavBarCurrentIndex() {
    if (_selectedIndex == 0) return 0;
    if (_selectedIndex == 2) return 1;
    if (_selectedIndex == 3) return 2;

    if (_selectedIndex == 1) return 0;

    return 0;
  }

  void handleBottomNavTap(int navBarIndex) {
    int screenIndex = 0;

    if (navBarIndex == 0) {
      screenIndex = 0;
    } else if (navBarIndex == 1) {
      screenIndex = 2;
    } else if (navBarIndex == 2) {
      screenIndex = 3;
    }
    setSelectedIndex(screenIndex);
  }
}
