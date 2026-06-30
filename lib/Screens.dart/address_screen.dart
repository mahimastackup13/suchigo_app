import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:suchigo_app/provider/home_provider.dart';
import 'package:suchigo_app/provider/profile_provider.dart';
import 'package:suchigo_app/Screens.dart/bill_screen.dart';
import 'package:suchigo_app/Screens.dart/booking_confirmation_screen.dart';
import 'home_screen.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _secondaryController = TextEditingController();
  final _locationController = TextEditingController();
  final _localBodyController = TextEditingController();

  String? _selectedDistrict;
  String? _selectedLocalBody;
  String? _selectedWard;

  static const Color _headerGreen = Color(0xFF4CAF50);

  final List<String> _districts = [
    'Thiruvananthapuram',
    'Kollam',
    'Pathanamthitta',
    'Alappuzha',
    'Kottayam',
    'Idukki',
    'Ernakulam',
    'Thrissur',
    'Palakkad',
    'Malappuram',
    'Kozhikode',
    'Wayanad',
    'Kannur',
    'Kasaragod',
  ];

  final List<String> _localBodies = [
    'Thiruvananthapuram Corporation',
    'Kollam Corporation',
    'Kochi Corporation',
    'Thrissur Corporation',
    'Kannur Municipality',
    'Palakkad Municipality',
    'Attingal Municipality',
    'Varkala Municipality',
  ];

  final List<String> _wards = List.generate(50, (i) => 'Ward ${i + 1}');

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

  // ── Beautiful modern text field builder ──────────────────────────────────────
  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool required = true,
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
    List<TextInputFormatter>? formatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              if (required) ...[
                const SizedBox(width: 4),
                const Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboard,
            inputFormatters: formatters,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              filled: true,
              fillColor: const Color(0xFFF9FBF9),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _headerGreen, width: 1.8),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1.2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1.8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 16,
              ),
              errorStyle: const TextStyle(fontSize: 11, height: 1.0),
            ),
            validator: required
                ? (v) => (v == null || v.trim().isEmpty)
                      ? 'This field is required'
                      : null
                : null,
          ),
        ],
      ),
    );
  }

  // ── Beautiful modern dropdown builder ────────────────────────────────────────
  Widget _buildDropdown({
    required String label,
    required String hint,
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
    bool required = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              if (required) ...[
                const SizedBox(width: 4),
                const Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.grey.shade600,
              size: 22,
            ),
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            dropdownColor: Colors.white,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              filled: true,
              fillColor: const Color(0xFFF9FBF9),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _headerGreen, width: 1.8),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1.2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1.8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 16,
              ),
              errorStyle: const TextStyle(fontSize: 11, height: 1.0),
            ),
            items: items
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
            validator: required
                ? (v) => (v == null || v.isEmpty)
                      ? 'Please select an option'
                      : null
                : null,
          ),
        ],
      ),
    );
  }

  // ── Beautiful Card container for form sections ──────────────────────────────
  Widget _buildFormSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _headerGreen, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(color: Color(0xFFF1F5F2), thickness: 1),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Provider.of<HomeProvider>(context, listen: false).setSelectedIndex(1);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: Column(
          children: [
            // ── Header with gradient ─────────────────────────────────────────
            _buildHeader(),

            // ── Scrollable form ──────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Section 1: Contact Info Card
                      _buildFormSection(
                        title: "Contact Information",
                        icon: Icons.person_rounded,
                        children: [
                          _buildField(
                            controller: _nameController,
                            label: 'Full Name',
                            hint: 'Enter your full name',
                          ),
                          _buildField(
                            controller: _contactController,
                            label: 'Contact Number',
                            hint: 'Enter your contact number',
                            keyboard: TextInputType.phone,
                            formatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                          _buildField(
                            controller: _emailController,
                            label: 'Email Address',
                            hint: 'Enter your email address',
                            keyboard: TextInputType.emailAddress,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Section 2: Address Details Card
                      _buildFormSection(
                        title: "Pickup Location",
                        icon: Icons.location_on_rounded,
                        children: [
                          _buildField(
                            controller: _addressController,
                            label: 'Pickup Address',
                            hint: 'Enter your complete address',
                            maxLines: 3,
                            required: false,
                          ),
                          _buildDropdown(
                            label: 'District',
                            hint: 'Select your district',
                            items: _districts,
                            value: _selectedDistrict,
                            onChanged: (v) => setState(() {
                              _selectedDistrict = v;
                              _selectedLocalBody = null;
                            }),
                          ),
                          _buildDropdown(
                            label: 'Local Body',
                            hint: 'Select local body',
                            items: _localBodies,
                            value: _selectedLocalBody,
                            onChanged: (v) =>
                                setState(() => _selectedLocalBody = v),
                          ),
                          _buildDropdown(
                            label: 'Ward Name & Number',
                            hint: 'Select ward (optional)',
                            items: _wards,
                            value: _selectedWard,
                            onChanged: (v) => setState(() => _selectedWard = v),
                            required: false,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Section 3: Extra Info Card
                      _buildFormSection(
                        title: "Additional Details",
                        icon: Icons.info_rounded,
                        children: [
                          _buildField(
                            controller: _secondaryController,
                            label: 'Secondary Number',
                            hint: 'Enter alternative contact number',
                            keyboard: TextInputType.phone,
                            formatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            required: false,
                          ),
                          _buildField(
                            controller: _locationController,
                            label: 'Location / Landmark',
                            hint: 'Enter nearby landmark',
                            required: false,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Submit Button Container with Gradient
                      Container(
                        width: double.infinity,
                        height: 54,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4CAF50), Color(0xFF00BCD4)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4CAF50).withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
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
                                      address:
                                          _addressController.text.isNotEmpty
                                          ? _addressController.text
                                          : 'No address specified',
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
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'SUBMIT',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header widget with gradient ─────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4CAF50), Color(0xFF00BCD4), Color(0xFF2ECC71)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            children: [
              // Top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _headerIconBtn(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () {
                      Provider.of<HomeProvider>(
                        context,
                        listen: false,
                      ).setSelectedIndex(1);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    },
                  ),
                  const Text(
                    'Schedule Pickup',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                  _headerIconBtn(
                    icon: Icons.home_rounded,
                    onTap: () {
                      Provider.of<HomeProvider>(
                        context,
                        listen: false,
                      ).setSelectedIndex(0);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Welcome card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Welcome back, ${Provider.of<ProfileProvider>(context).username}! 👋',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
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
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}
