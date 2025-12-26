
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CollectorProvider with ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController wardController = TextEditingController();

  String? selectedScrapDistrict;
  String? selectedDhDistrict;
  String? selectedDhLocalbody;

  final List<String> districts = ["Thrissur", "Ernakulam"];
  bool isLoading = false;

  Future<void> fetchCollectorData() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse("https://suchigo.pythonanywhere.com/api/locations/"),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        nameController.text = data['name'] ?? "";
        // Ensure the value exists in our list or default to Ernakulam
        selectedScrapDistrict = districts.contains(data['scrap_district'])
            ? data['scrap_district']
            : "Ernakulam";
        selectedDhDistrict = districts.contains(data['dh_district'])
            ? data['dh_district']
            : "Ernakulam";
        selectedDhLocalbody = data['dh_localbody'] ?? "Kalamassery";
        wardController.text = data['ward'] ?? "";
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateScrapDistrict(String? newValue) {
    selectedScrapDistrict = newValue;
    notifyListeners();
  }

  void updateDhDistrict(String? newValue) {
    selectedDhDistrict = newValue;
    notifyListeners();
  }
  // Add this method to your CollectorProvider class
  Future<bool> updateCollectorData() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse("https://suchigo.pythonanywhere.com/api/locations/"), // Replace with your update endpoint if different
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": nameController.text,
          "scrap_district": selectedScrapDistrict,
          "dh_district": selectedDhDistrict,
          "dh_localbody": selectedDhLocalbody,
          "ward": wardController.text,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Data updated successfully");
        return true;
      } else {
        debugPrint("Failed to update: ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Error updating data: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}