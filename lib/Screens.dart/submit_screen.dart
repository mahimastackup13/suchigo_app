import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:suchigo_app/Screens.dart/pickup_screen.dart';
import 'package:suchigo_app/provider/address_details_provider.dart';
import 'package:suchigo_app/Screens.dart/home_screen.dart';
import 'package:suchigo_app/Screens.dart/bill_screen.dart';
import 'package:suchigo_app/Screens.dart/profile_screen.dart';
import 'package:suchigo_app/Screens.dart/settings_screen.dart';

class AddressScreen2 extends StatelessWidget {
  const AddressScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    final addressAction = context.read<AddressDetailsProvider>();
    final addressProvider = context.watch<AddressDetailsProvider>();

    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: const Color(0xFFEFF9F1),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Pickup Details",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        toolbarHeight: 80,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildLabel("State"),
                buildDropdown(
                  context,
                  ["Kerala", "Tamil Nadu"],
                  addressProvider.selectedState,
                  (value) => addressAction.setSelectedState(value),
                ),

                buildLabel("District"),
                buildDropdown(
                  context,
                  ["Ernakulam", "Thrissur"],
                  addressProvider.selectedDistrict,
                  (value) => addressAction.setSelectedDistrict(value),
                ),

                buildLabel("Local Body"),
                buildTextField(
                    addressAction.localBodyController, "Local Body"),

                buildLabel("Ward"),
                buildDropdown(
                  context,
                  ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
                  addressProvider.selectedWard,
                  (value) => addressAction.setSelectedWard(value),
                ),

                buildLabel("Pincode"),
                buildTextField(addressAction.pincodeController, "Pincode"),

                buildLabel("Number of Bags"),
                buildTextField(addressAction.bagsController, "Number of Bags"),

                buildLabel("Comments"),
                buildTextField(
                  addressAction.commentsController,
                  "Add brief comments or special instructions (optional)",
                  maxLines: 3,
                ),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E713D),
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final data = addressAction.collectData();
                        print("Submission Data: $data");

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AlertDialog(
                            title: const Text("Success"),
                            content: const Text(
                                "Your pickup request was submitted successfully."),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); 
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomeScreen(),
                                    ),
                                  );
                                },
                                child: const Text("OK"),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "SUBMIT",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(selectedIndex: 0),
    );
  }


  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: inputDecoration(hint),
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter $hint' : null,
    );
  }

  Widget buildDropdown(
    BuildContext context,
    List<String> items,
    String? selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        dropdownColor: const Color(0xFF4CAF50),
        decoration: const InputDecoration(border: InputBorder.none),
        style: const TextStyle(color: Colors.white),
        items: items
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, style: const TextStyle(color: Colors.white)),
                ))
            .toList(),
        onChanged: onChanged,
        validator: (value) => value == null || value.isEmpty ? 'Please select a value' : null,
      ),
    );
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFF4CAF50),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }
}

