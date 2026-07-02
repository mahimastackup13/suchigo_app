import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Screens.dart/waste_model.dart';

class WasteProvider extends ChangeNotifier {
  List<WasteModel> wasteList = [];
  bool _loading = false;

  bool get loading => _loading;

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }


 

  final String baseUrl = "https://clone2026.pythonanywhere.com/api/waste-entries/";

 
  Future<void> fetchWasteEntries() async {
    _setLoading(true);

    print('[http] REQUEST: GET $baseUrl');
    try {
      final response = await http.get(Uri.parse(baseUrl));
      print('[http] RESPONSE: ${response.statusCode} GET $baseUrl');
      print('[http] RESPONSE Data: ${response.body}');

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        wasteList = data.map((e) => WasteModel.fromJson(e)).toList();
      }
    } catch (e) {
      print('[http] ERROR: GET $baseUrl -> $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addWasteEntry(Map<String, dynamic> payload) async {
    _setLoading(true);
    print('[http] REQUEST: POST $baseUrl');
    print('[http] REQUEST Headers: {Content-Type: application/json}');
    print('[http] REQUEST Data: ${jsonEncode(payload)}');
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );
      print('[http] RESPONSE: ${response.statusCode} POST $baseUrl');
      print('[http] RESPONSE Data: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception("Server Error: ${response.body}");
      }
    } catch (e) {
      print('[http] ERROR: POST $baseUrl -> $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
}
