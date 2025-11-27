// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../Screens.dart/waste_model.dart';

// class WasteProvider extends ChangeNotifier {
//   List<WasteModel> wasteList = [];
//   bool _loading = false;

//   bool get loading => _loading;

//   void _setLoading(bool v) {
//     _loading = v;
//     notifyListeners();
//   }


//   // final String baseUrl = "http://127.0.0.1:8000/api/waste-entries/"; 

//   final String baseUrl = "https://lumoskart.pythonanywhere.com/api/waste-entries/";

//   // ⚠ IMPORTANT: Do NOT use 127.0.0.1 on Android.
//   // Replace 192.168.1.5 with your PC LAN IP.

//   Future<void> fetchWasteEntries() async {
//     _setLoading(true);

//     final response = await http.get(Uri.parse(baseUrl));

//     if (response.statusCode == 200) {
//       final List data = jsonDecode(response.body);
//       wasteList = data.map((e) => WasteModel.fromJson(e)).toList();
//     }

//     _setLoading(false);
//   }

//   Future<bool> addWasteEntry(Map<String, dynamic> payload) async {
//     _setLoading(true);
//     try {
//       final response = await http.post(
//         Uri.parse(baseUrl),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(payload),
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return true;
//       } else {
//         throw Exception("Server Error: ${response.body}");
//       }
//     } finally {
//       _setLoading(false);
//     }
//   }
// }
