// 
import 'package:flutter/material.dart';
import 'package:suchigo_app/Screens.dart/home_screen.dart';
import 'package:suchigo_app/Screens.dart/pickup_screen.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _PickupFormScreenState();
}

class _PickupFormScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _localBodyController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _bagsController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();

  String? _selectedState;
  String? _selectedDistrict;
  String? _selectedWard;

  // Standard color for the green theme
  static const Color _primaryGreen = Color(0xFF4CAF50);
  static const Color _darkGreen = Color(0xFF1E713D);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _dateController.dispose();
    _addressController.dispose();
    _landmarkController.dispose();
    _localBodyController.dispose();
    _pincodeController.dispose();
    _bagsController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  // Helper widget to build the text field label
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
    );
  }

  // Helper widget to build the form text field
  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: _inputDecoration(hint),
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter $hint' : null,
    );
  }

  // Helper widget to build the dropdown
  Widget _buildDropdown(
    List<String> items,
    String? selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: _primaryGreen,
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        dropdownColor: _primaryGreen,
        decoration: const InputDecoration(border: InputBorder.none),
        style: const TextStyle(color: Colors.white),
        items: items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e, style: const TextStyle(color: Colors.white)),
              ),
            )
            .toList(),
        onChanged: onChanged,
        validator: (value) =>
            value == null || value.isEmpty ? 'Please select a value' : null,
      ),
    );
  }

  // Helper for InputDecoration styling
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: _primaryGreen,
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF9F1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🌿 Cleaned-up Header Section
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: const BoxDecoration(
                  color: _primaryGreen, // Primary green background
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Back Arrow
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(), // Use pop for back navigation
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 16,
                            color: Colors.white,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.3), // Soft white background for icon
                            shape: const CircleBorder(),
                          ),
                        ),
                        // Title
                        const Text(
                          "Schedule Pickup",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Home Icon
                        IconButton(
                          onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          ),
                          icon: const Icon(
                            Icons.home,
                            size: 16,
                            color: Colors.white,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.3),
                            shape: const CircleBorder(),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Welcome Card inside the header (Retained)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(2, 4),
                          ),
                        ],
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Welcome back, T! 👋",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Manage your waste collection and track your environmental impact",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // ------------------------------------

              const SizedBox(height: 20),

              // Form Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Full Name"),
                      _buildTextField(_nameController, "Full Name"),

                      _buildLabel("Email Address"),
                      _buildTextField(_emailController, "Email Address"),

                      _buildLabel("Contact Number"),
                      _buildTextField(_contactController, "Contact Number"),

                      _buildLabel("Select Pickup Date"),
                      TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            _dateController.text =
                                "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                          }
                        },
                        decoration: _inputDecoration("Select Date"),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Please select a date' : null,
                      ),
                      const SizedBox(height: 10),

                      _buildLabel("Pickup Address"),
                      _buildTextField(_addressController, "Pickup Address"),

                      _buildLabel("Land mark"),
                      _buildTextField(_landmarkController, "Land mark"),

                      _buildLabel("State"),
                      _buildDropdown(["Kerala", "Tamil Nadu"], _selectedState,
                          (value) {
                        setState(() => _selectedState = value);
                      }),

                      _buildLabel("District"),
                      _buildDropdown(
                        ["Ernakulam", "Thrissur"],
                        _selectedDistrict,
                        (value) {
                          setState(() => _selectedDistrict = value);
                        },
                      ),

                      _buildLabel("Local Body"),
                      _buildTextField(_localBodyController, "Local Body"),

                      _buildLabel("Ward"),
                      _buildDropdown(["1", "2", "3"], _selectedWard, (value) {
                        setState(() => _selectedWard = value);
                      }),

                      _buildLabel("Pincode"),
                      _buildTextField(_pincodeController, "Pincode"),

                      _buildLabel("Number of Bags"),
                      _buildTextField(_bagsController, "Number of Bags"),

                      _buildLabel("Comments"),
                      _buildTextField(
                        _commentsController,
                        "Add brief comments or special instructions (optional)",
                        maxLines: 3,
                      ),

                      const SizedBox(height: 20),
                      // Submit Button
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _darkGreen, // Darker green for button
                            minimumSize: const Size(double.infinity, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // If using named routes, ensure '/home' is correctly defined
                              Navigator.pushReplacement(
                                context, 
                                MaterialPageRoute(builder: (context) => const HomeScreen())
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
            ],
          ),
        ),
      ),
    );
  }
}