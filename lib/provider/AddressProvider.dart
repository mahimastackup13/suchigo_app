import 'package:flutter/material.dart';

class AddressProvider with ChangeNotifier {
  

  String _name = '';
  String _email = '';
  String _contact = '';
  String _date = '';
  String _address = '';
  String _landmark = '';

  String get name => _name;
  String get email => _email;
  String get contact => _contact;
  String get date => _date;
  String get address => _address;
  String get landmark => _landmark;

  
  void setName(String value) {
    _name = value;
   
  }

  void setEmail(String value) {
    _email = value;
  }

  void setContact(String value) {
    _contact = value;
  }

  void setDate(String value) {
    _date = value;
    notifyListeners(); 
  }

  void setAddress(String value) {
    _address = value;
  }

  void setLandmark(String value) {
    _landmark = value;
  }

 
  Map<String, String> get formData {
    return {
      'name': _name,
      'email': _email,
      'contact': _contact,
      'date': _date,
      'address': _address,
      'landmark': _landmark,
    };
  }
}