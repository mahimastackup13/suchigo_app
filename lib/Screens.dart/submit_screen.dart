import 'package:flutter/material.dart';
import 'package:suchigo_app/Screens.dart/home_screen.dart';
import 'package:suchigo_app/Screens.dart/bill_screen.dart';
import 'package:suchigo_app/Screens.dart/profile_screen.dart';
import 'package:suchigo_app/Screens.dart/settings_screen.dart';

class AddressScreen2 extends StatefulWidget {
  const AddressScreen2({super.key});

  @override
  State<AddressScreen2> createState() => _AddressScreen2State();
}

class _AddressScreen2State extends State<AddressScreen2> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _localBodyController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _bagsController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();

  String? _selectedState;
  String? _selectedDistrict;
  String? _selectedWard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF9F1),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Pickup Details", style: TextStyle(fontSize: 25,
          fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(15),
          ),
        ),
        toolbarHeight: 80, // Adjusting the height of the AppBar
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
                buildDropdown(["Kerala", "Tamil Nadu"], _selectedState, (value) {
                  setState(() => _selectedState = value);
                }),

                buildLabel("District"),
                buildDropdown(["Ernakulam", "Thrissur"], _selectedDistrict,
                  (value) {
                  setState(() => _selectedDistrict = value);
                }),

                buildLabel("Local Body"),
                buildTextField(_localBodyController, "Local Body"),

                buildLabel("Ward"),
                buildDropdown(["1", "2", "3"], _selectedWard, (value) {
                  setState(() => _selectedWard = value);
                }),

                buildLabel("Pincode"),
                buildTextField(_pincodeController, "Pincode"),

                buildLabel("Number of Bags"),
                buildTextField(_bagsController, "Number of Bags"),

                buildLabel("Comments"),
                buildTextField(
                  _commentsController,
                  "Add brief comments or special instructions (optional)",
                  maxLines: 3,
                ),

                const SizedBox(height: 20),
                Center(
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
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => AlertDialog(
                      title: const Text("Success"),
                      content:
                        const Text("Your pickup request was submitted successfully."),
                      actions: [
                        TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // close dialog
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

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  const CustomBottomNav({super.key, required this.selectedIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == selectedIndex) return;

    Widget destination;
    switch (index) {
      case 0:
        destination = const HomeScreen();
        break;
      case 1:
        destination = const BillScreen();
        break;
      case 2:
        destination = const SettingsScreen();
        break;
      case 3:
        destination = const ProfileScreen();
        break;
      default:
        destination = const HomeScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) => _onItemTapped(context, index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF1E713D),
      unselectedItemColor: Colors.grey.shade500,
      showUnselectedLabels: true,
      items: [
        BottomNavigationBarItem(
          icon: Image.asset('assets/icons/HOME (2).png', width: 26, height: 26),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Image.asset('assets/icons/bill.png', width: 26, height: 26),
          label: 'Bill',
        ),
        BottomNavigationBarItem(
          icon: Image.asset('assets/icons/settings.png', width: 26, height: 26),
          label: 'Settings',
        ),
        BottomNavigationBarItem(
          icon: Image.asset('assets/icons/person.png', width: 26, height: 26),
          label: 'Profile',
        ),
      ],
    );
  }
}
