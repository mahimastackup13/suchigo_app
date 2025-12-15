import 'package:flutter/material.dart';

class AddressDetailsProvider extends ChangeNotifier {
  final TextEditingController localBodyController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController bagsController = TextEditingController();
  final TextEditingController commentsController = TextEditingController();

  String? _selectedState;
  String? _selectedDistrict;
  String? _selectedWard;

  String? get selectedState => _selectedState;
  String? get selectedDistrict => _selectedDistrict;
  String? get selectedWard => _selectedWard;

  void setSelectedState(String? value) {
    _selectedState = value;
    _selectedDistrict = null;
    _selectedWard = null;
    notifyListeners();
  }

  void setSelectedDistrict(String? value) {
    _selectedDistrict = value;
    _selectedWard = null;
    notifyListeners();
  }

  void setSelectedWard(String? value) {
    _selectedWard = value;
    notifyListeners();
  }

  Map<String, dynamic> collectData() {
    return {
      'state': _selectedState,
      'district': _selectedDistrict,
      'localBody': localBodyController.text,
      'ward': _selectedWard,
      'pincode': pincodeController.text,
      'bags': bagsController.text,
      'comments': commentsController.text,
    };
  }

  @override
  void dispose() {
    localBodyController.dispose();
    pincodeController.dispose();
    bagsController.dispose();
    commentsController.dispose();
    super.dispose();
  }
}