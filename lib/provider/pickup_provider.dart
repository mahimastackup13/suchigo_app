import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:suchigo_app/Screens.dart/address_screen.dart';
import 'package:suchigo_app/Screens.dart/track_screen.dart'; // Ensure this path is correct

class PickupProvider extends ChangeNotifier {
  // --- State Variables ---
  final TextEditingController _addressController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // --- Getters to access state ---
  TextEditingController get addressController => _addressController;
  DateTime? get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;

  // Getter for display format
  String get dateDisplay => _selectedDate != null
      ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
      : "Select Date";

  String timeDisplay(BuildContext context) => _selectedTime != null
      ? _selectedTime!.format(context)
      : "Select Time";

  // --- Date Picker Logic ---
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF1E713D),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            colorScheme: ColorScheme.light(primary: const Color(0xFF1E713D)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      _selectedDate = picked;
      notifyListeners(); // Update UI
    }
  }

  // --- Time Picker Logic ---
  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF1E713D),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            colorScheme: ColorScheme.light(primary: const Color(0xFF1E713D)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      _selectedTime = picked;
      notifyListeners(); // Update UI
    }
  }

  // --- Action Logic ---
  bool get isFormValid => 
      _addressController.text.isNotEmpty &&
      _selectedDate != null &&
      _selectedTime != null;

  void confirmPickup(BuildContext context) {
    if (isFormValid) {
      // Logic to process the pickup request (e.g., API call, save to database)
      print('Pickup Confirmed!');
      print('Address: ${_addressController.text}');
      print('Date: ${_selectedDate}');
      print('Time: ${_selectedTime}');

      // Navigate to the next screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AddressScreen1()),
      );
    } else {
      // Show an error/snackbar if needed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all pickup details.')),
      );
    }
  }

  // Dispose controller when provider is no longer needed
  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }
}