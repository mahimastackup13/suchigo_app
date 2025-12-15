import 'package:flutter/material.dart';
import 'home_screen.dart';

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

  String? _selectedState = "Kerala";
  String? _selectedDistrict = "Ernakulam";
  String? _selectedWard = "1";

  final List<String> _states = ["Kerala", "Tamil Nadu"];
  final List<String> _districts = [
    "Ernakulam",
    "Thrissur",
    "Kollam",
    "Chennai",
    "Coimbatore",
  ];
  final List<String> _wards = ["1", "2", "3", "4", "5", "6"];

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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Submitting...')));

      // TODO: Handle form submission locally

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pickup scheduled successfully!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: _inputDecoration(hint),
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter $hint' : null,
    );
  }

  Widget _buildDropdown(
    List<String> items,
    String? selectedValue,
    ValueChanged<String?> onChanged,
    String label,
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
            value == null || value.isEmpty ? 'Please select a $label' : null,
      ),
    );
  }

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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: const BoxDecoration(
                  color: _primaryGreen,
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
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 16,
                            color: Colors.white,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.3,
                            ),
                            shape: const CircleBorder(),
                          ),
                        ),
                        const Text(
                          "Schedule Pickup",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.3,
                            ),
                            shape: const CircleBorder(),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

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
                            color: Colors.grey.withValues(alpha: 0.3),
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

              const SizedBox(height: 20),

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
                      _buildTextField(
                        _emailController,
                        "Email Address",
                        keyboardType: TextInputType.emailAddress,
                      ),

                      _buildLabel("Contact Number"),
                      _buildTextField(
                        _contactController,
                        "Contact Number",
                        keyboardType: TextInputType.phone,
                      ),

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
                                "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
                          }
                        },
                        decoration: _inputDecoration("Select Date"),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please select a date'
                            : null,
                      ),
                      const SizedBox(height: 10),

                      _buildLabel("Pickup Address"),
                      _buildTextField(
                        _addressController,
                        "Pickup Address",
                        maxLines: 3,
                      ),

                      _buildLabel("Land mark"),
                      _buildTextField(_landmarkController, "Land mark"),

                      _buildLabel("State"),
                      _buildDropdown(_states, _selectedState, (value) {
                        setState(() => _selectedState = value);
                      }, "State"),

                      _buildLabel("District"),
                      _buildDropdown(
                        _districts
                            .where(
                              (d) =>
                                  (_selectedState == "Kerala" &&
                                      [
                                        "Ernakulam",
                                        "Thrissur",
                                        "Kollam",
                                      ].contains(d)) ||
                                  (_selectedState == "Tamil Nadu" &&
                                      ["Chennai", "Coimbatore"].contains(d)),
                            )
                            .toList(),
                        _selectedDistrict,
                        (value) {
                          setState(() => _selectedDistrict = value);
                        },
                        "District",
                      ),

                      _buildLabel("Local Body"),
                      _buildTextField(_localBodyController, "Local Body"),

                      _buildLabel("Ward"),
                      _buildDropdown(_wards, _selectedWard, (value) {
                        setState(() => _selectedWard = value);
                      }, "Ward"),

                      _buildLabel("Pincode"),
                      _buildTextField(
                        _pincodeController,
                        "Pincode",
                        keyboardType: TextInputType.number,
                      ),

                      _buildLabel("Number of Bags"),
                      _buildTextField(
                        _bagsController,
                        "Number of Bags",
                        keyboardType: TextInputType.number,
                      ),

                      _buildLabel("Comments"),
                      _buildTextField(
                        _commentsController,
                        "Add brief comments or special instructions (optional)",
                        maxLines: 3,
                      ),

                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _darkGreen,
                            minimumSize: const Size(double.infinity, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _submitForm,
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
