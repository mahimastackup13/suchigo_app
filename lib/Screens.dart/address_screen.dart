import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:suchigo_app/Screens.dart/bill_screen.dart';
import 'package:suchigo_app/Screens.dart/booking_confirmation_screen.dart';
import 'home_screen.dart';
import 'package:suchigo_app/Screens.dart/location_picker_screen.dart';
import 'package:provider/provider.dart';
import 'package:suchigo_app/provider/home_provider.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _pickupDateController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _secondaryController = TextEditingController();
  final _locationController = TextEditingController();
  final _localBodyController = TextEditingController();

  String? _selectedDistrict;
  String? _selectedState;
  String? _selectedLocalBody;
  String? _selectedWard;

  static const Color _darkGreen = Color(0xFF1E713D);
  static const Color _headerGreen = Color(0xFF4CAF50);

  final List<String> _districts = ['Ernakulam', 'Thrissur'];
  final List<String> _state = ['Kerala', 'Tamilnadu'];

  final List<String> _localBodies = [
    'Kochi Corporation',
    'Thrissur Corporation',
  ];

  final List<String> _wards = List.generate(20, (i) => 'Ward ${i + 1}');

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _secondaryController.dispose();
    _locationController.dispose();
    _localBodyController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Pickup scheduled successfully!'),
          backgroundColor: _darkGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  // ── Underline text field ────────────────────────────────────────────────────
  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    bool required = true,
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
    List<TextInputFormatter>? formatters,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboard,
      inputFormatters: formatters,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        suffixIcon: required
            ? const Padding(
                padding: EdgeInsets.only(right: 4, top: 12),
                child: Text(
                  '*',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              )
            : null,
        suffixIconConstraints: const BoxConstraints(
          minWidth: 20,
          minHeight: 20,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: _darkGreen, width: 1.5),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        errorStyle: const TextStyle(fontSize: 10, height: 0.8),
      ),
      validator: required
          ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null
          : null,
    );
  }

  // ── Underline dropdown ──────────────────────────────────────────────────────
  Widget _buildDropdown({
    required String hint,
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
    bool required = true,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.grey, size: 22),
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      dropdownColor: Colors.white,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        suffixIcon: required
            ? const Padding(
                padding: EdgeInsets.only(right: 24, top: 12),
                child: Text(
                  '*',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              )
            : null,
        suffixIconConstraints: const BoxConstraints(
          minWidth: 20,
          minHeight: 20,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: _darkGreen, width: 1.5),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        errorStyle: const TextStyle(fontSize: 10, height: 0.8),
      ),
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(
                e,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator: required
          ? (v) => (v == null || v.isEmpty) ? 'Required' : null
          : null,
    );
  }

  // ── Section divider ─────────────────────────────────────────────────────────
  Widget _divider() =>
      Divider(color: Colors.grey.shade200, thickness: 1, height: 16);

  Future<void> _selectPickupDate() async {
    final DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() {
        _pickupDateController.text =
            '${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          // ── Green header ─────────────────────────────────────────────
          _buildHeader(),

          // ── Non-scrollable form ──────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Full Name

                    // Contact Number
                    _buildField(
                      controller: _contactController,
                      hint: 'Contact Number',
                      keyboard: TextInputType.phone,
                      formatters: [FilteringTextInputFormatter.digitsOnly],
                    ),

                    // Email
                    _buildField(
                      controller: _emailController,
                      hint: 'Email Address',
                      keyboard: TextInputType.emailAddress,
                    ),

                    // Pickup Address
                    _buildField(
                      controller: _addressController,
                      hint: 'Pickup Address',
                      maxLines: 1,
                      required: false,
                    ),
                    _buildField(
                      controller: _pickupDateController,
                      hint: 'Pickup Date',
                      readOnly: true,
                      onTap: _selectPickupDate,
                    ),

                    _divider(),

                    // District
                    _buildDropdown(
                      hint: 'State',
                      items: _state,
                      value: _selectedState,
                      onChanged: (v) => setState(() {
                        _selectedState = v;
                        _selectedDistrict = null;
                      }),
                    ),
                    _buildDropdown(
                      hint: 'District',
                      items: _districts,
                      value: _selectedDistrict,
                      onChanged: (v) => setState(() {
                        _selectedDistrict = v;
                        _selectedLocalBody = null;
                      }),
                    ),

                    // Local Body
                    _buildDropdown(
                      hint: 'Local Body',
                      items: _localBodies,
                      value: _selectedLocalBody,
                      onChanged: (v) => setState(() => _selectedLocalBody = v),
                    ),

                    // Ward Name & Number
                    _buildDropdown(
                      hint: 'Ward Name & Number',
                      items: _wards,
                      value: _selectedWard,
                      onChanged: (v) => setState(() => _selectedWard = v),
                      required: false,
                    ),

                    // Secondary Number
                    _buildField(
                      controller: _secondaryController,
                      hint: 'Secondary Number',
                      keyboard: TextInputType.phone,
                      formatters: [FilteringTextInputFormatter.digitsOnly],
                      required: false,
                    ),

                    // Location
                    // _buildField(
                    //   controller: _locationController,
                    //   hint: 'Tap to pick location on map',
                    //   required: false,
                    //   readOnly: true,
                    //   onTap: () async {
                    //     final result = await Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => const LocationPickerScreen(),
                    //       ),
                    //     );
                    //     if (result != null && result is Map<String, dynamic>) {
                    //       setState(() {
                    //         _locationController.text = result['address'] ?? '';
                    //       });
                    //     }
                    //   },
                    // ),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookingConfirmationScreen(
                                  bookingDetails: BookingDetails(
                                    bookingId: 'WC-2026-08741',
                                    wasteType: 'Mixed Household Waste',
                                    collectionDate: 'Monday, 28 Apr 2026',
                                    collectionTime: '09:00 AM – 12:00 PM',
                                    address: _addressController.text,
                                    city: _selectedDistrict ?? '',
                                    pincode: '682025',
                                    contactName: _nameController.text,
                                    contactPhone: _contactController.text,
                                    status: 'Confirmed',
                                    estimatedWeight: 12.5,
                                    specialInstructions:
                                        'Please ring the bell twice. Gate is on the left side.',
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'SUBMIT',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header widget ───────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: _headerGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            children: [
              // Top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _headerIconBtn(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Schedule Pickup',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                  _headerIconBtn(
                    icon: Icons.home_rounded,
                    onTap: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Provider.of<HomeProvider>(
                        context,
                        listen: false,
                      ).setSelectedIndex(0);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Welcome card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Welcome back, T! 👋',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage your waste collection and track your\nenvironmental impact',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerIconBtn({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.25),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}
