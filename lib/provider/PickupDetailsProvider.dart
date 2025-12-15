import 'package:flutter/material.dart';


class PickupDetailsProvider with ChangeNotifier {
  
  
  String? _selectedState;
  String? _selectedDistrict;
  String _localBody = '';
  String? _selectedWard;
  String _pincode = '';
  String _bags = '';
  String _comments = '';
  
  
  bool _isLoading = false;
  String? _errorMessage;

  String? get selectedState => _selectedState;
  String? get selectedDistrict => _selectedDistrict;
  String get localBody => _localBody;
  String? get selectedWard => _selectedWard;
  String get pincode => _pincode;
  String get bags => _bags;
  String get comments => _comments;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  get selectedTime => null;

  get selectedDate => null;

  String? get pickupAddress => null;

  // Setters
  void setSelectedState(String? value) {
    _selectedState = value;
    notifyListeners();
  }

  void setSelectedDistrict(String? value) {
    _selectedDistrict = value;
    notifyListeners();
  }

  void setLocalBody(String value) { 
    _localBody = value;
   
  }

  void setSelectedWard(String? value) {
    _selectedWard = value;
    notifyListeners();
  }

  void setPincode(String value) { 
    _pincode = value;
  }

  void setBags(String value) { 
    _bags = value;
  }

  void setComments(String value) { 
    _comments = value;
  }

  void setErrorMessage(String? message) { 
    _errorMessage = message; 
    notifyListeners(); 
  }

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  
  Future<bool> submitLocalData() async {
    if (_selectedState == null || _selectedDistrict == null || _selectedWard == null) {
      setErrorMessage("Please select State, District, and Ward.");
      return false;
    }
    
    setIsLoading(true);
    setErrorMessage(null);

    await Future.delayed(const Duration(milliseconds: 1000)); 

    setIsLoading(false);

   
    print('Local Data Collected:');
    print('  State: $_selectedState, District: $_selectedDistrict, Ward: $_selectedWard');
    print('  Local Body: $_localBody, Pincode: $_pincode, Bags: $_bags');
    print('  Comments: $_comments');
    
    return true; 
  }

  @override
  void dispose() {
    super.dispose();
  }

  void confirmPickup() {}

  void setPickupAddress(String value) {}

  void setSelectedDate(DateTime picked) {}

  void setSelectedTime(TimeOfDay picked) {}
}