
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CollectorProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Controllers for TextFields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dhLocalbodyController = TextEditingController();
  final TextEditingController wardController = TextEditingController();

  // Dropdown states
  String? selectedScrapDistrict;
  String? selectedDhDistrict;

  // Mock list for districts (Replace with actual data or API values if needed)
  final List<String> districts = [
    "Scrap District 1", 
    "Scrap District 2", 
    "DH District 1", 
    "DH District 2"
  ];

  // Update Dropdown states
  void updateScrapDistrict(String? value) {
    selectedScrapDistrict = value;
    notifyListeners();
  }

  void updateDhDistrict(String? value) {
    selectedDhDistrict = value;
    notifyListeners();
  }

  /// FETCH Initial Data (Optional template based on your code)
  Future<void> fetchCollectorData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // If you want to load initial data, place your GET request here
      // For now, initializing with some sample empty text or defaults
      nameController.text = "";
      dhLocalbodyController.text = "";
      wardController.text = "";
    } catch (e) {
      debugPrint("Error fetching data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// POST / SAVE Data to your REST API
  Future<bool> updateCollectorData() async {
    final url = Uri.parse('https://suchigo.pythonanywhere.com/api/locations/');
    
    _isLoading = true;
    notifyListeners();

    // Prepare JSON Body matching your exact schema structure
    final Map<String, dynamic> bodyData = {
      "name": nameController.text.trim(),
      "scrap_district": selectedScrapDistrict ?? "",
      "dh_district": selectedDhDistrict ?? "",
      "dh_localbody": dhLocalbodyController.text.trim(),
      "ward": wardController.text.trim()
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Data Saved Successfully: ${response.body}");
        return true;
      } else {
        debugPrint("Server Error (${response.statusCode}): ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Network Exception context: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    dhLocalbodyController.dispose();
    wardController.dispose();
    super.dispose();
  }
}