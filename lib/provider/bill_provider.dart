import 'package:flutter/material.dart';
import 'package:suchigo_app/Screens.dart/pickup_screen.dart';

class BillProvider extends ChangeNotifier {
  // --- State for the selected waste option ---
  int? _selectedOption; 

  int? get selectedOption => _selectedOption;

  // Map option values to human-readable strings (optional, but helpful)
  final Map<int, String> wasteOptions = {
    1: "Plastic waste",
    2: "Organic waste",
    3: "E-waste",
    4: "Household items",
  };

  String? get selectedWasteType => 
      _selectedOption != null ? wasteOptions[_selectedOption] : null;

  // --- Action to update the selected option ---
  void setSelectedOption(int? value) {
    _selectedOption = value;
    notifyListeners(); // Important: Rebuilds widgets listening to this provider
  }

  // --- Action triggered by the "CONTINUE" button ---
  void continueToPickup(BuildContext context) {
    if (_selectedOption != null) {
      // In a real app, you might save the selected type here (e.g., to a database)
      print('Selected Waste Type: ${selectedWasteType}');
      
      // Navigate to the next screen (PickupScreen)
      // Note: Assumes PickupScreen is correctly imported/accessible.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PickupScreen()),
      );
    }
  }
}