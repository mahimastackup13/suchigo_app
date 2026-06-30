import 'package:flutter/material.dart';
import 'package:suchigo_app/Screens.dart/address_screen.dart';

class BillProvider extends ChangeNotifier {
  // --- State for the selected waste options ---
  final Set<int> _selectedOptions = {}; 

  Set<int> get selectedOptions => _selectedOptions;

  // Map option values to human-readable strings
  final Map<int, String> wasteOptions = {
    1: "Sanitary waste",
    2: "Solid waste",
    3: "Organic waste",
    4: "E-waste",
    5: "Industrial waste",
    6: "Bulk waste",
    7: "Chemical waste",
    8: "Construction waste",
  };

  List<String> get selectedWasteTypes => 
      _selectedOptions.map((opt) => wasteOptions[opt] ?? '').toList();

  // --- Action to toggle a selected option ---
  void toggleOption(int value) {
    if (_selectedOptions.contains(value)) {
      _selectedOptions.remove(value);
    } else {
      _selectedOptions.add(value);
    }
    notifyListeners(); // Important: Rebuilds widgets listening to this provider
  }

  // --- Clear all selections (useful if changing tabs) ---
  void clearSelections() {
    _selectedOptions.clear();
    notifyListeners();
  }

  // --- Action triggered by the "CONTINUE" button ---
  void continueToPickup(BuildContext context) {
    if (_selectedOptions.isNotEmpty) {
      print('Selected Waste Types: $selectedWasteTypes');
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AddressScreen()),
      );
    }
  }
}