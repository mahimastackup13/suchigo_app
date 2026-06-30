// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:suchigo_app/Screens.dart/bill_screen.dart';
// import 'package:suchigo_app/Screens.dart/booking_confirmation_screen.dart';
// import 'home_screen.dart';
// import 'package:suchigo_app/Screens.dart/location_picker_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:suchigo_app/provider/home_provider.dart';

// class AddressScreen extends StatefulWidget {
//   const AddressScreen({super.key});

//   @override
//   State<AddressScreen> createState() => _AddressScreenState();
// }

// class _AddressScreenState extends State<AddressScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final _nameController = TextEditingController();
//   final _pickupDateController = TextEditingController();
//   final _contactController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _secondaryController = TextEditingController();
//   final _locationController = TextEditingController();
//   final _localBodyController = TextEditingController();

//   String? _selectedDistrict;
//   String? _selectedState;
//   String? _selectedLocalBody;
//   String? _selectedWard;

//   static const Color _darkGreen = Color(0xFF1E713D);
//   static const Color _headerGreen = Color(0xFF4CAF50);

//   final List<String> _districts = ['Ernakulam', 'Thrissur'];
//   final List<String> _state = ['Kerala', 'Tamilnadu'];

//   final List<String> _localBodies = [
//     'Kochi Corporation',
//     'Thrissur Corporation',
//   ];

//   final List<String> _wards = List.generate(20, (i) => 'Ward ${i + 1}');

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _contactController.dispose();
//     _emailController.dispose();
//     _addressController.dispose();
//     _secondaryController.dispose();
//     _locationController.dispose();
//     _localBodyController.dispose();
//     super.dispose();
//   }

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('Pickup scheduled successfully!'),
//           backgroundColor: _darkGreen,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//       );
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const HomeScreen()),
//       );
//     }
//   }

//   // ── Underline text field ────────────────────────────────────────────────────
//   Widget _buildField({
//     required TextEditingController controller,
//     required String hint,
//     bool required = true,
//     int maxLines = 1,
//     TextInputType keyboard = TextInputType.text,
//     List<TextInputFormatter>? formatters,
//     bool readOnly = false,
//     VoidCallback? onTap,
//   }) {
//     return TextFormField(
//       controller: controller,
//       maxLines: maxLines,
//       keyboardType: keyboard,
//       inputFormatters: formatters,
//       readOnly: readOnly,
//       onTap: onTap,
//       style: const TextStyle(fontSize: 14, color: Colors.black87),
//       decoration: InputDecoration(
//         hintText: hint,
//         hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
//         suffixIcon: required
//             ? const Padding(
//                 padding: EdgeInsets.only(right: 4, top: 12),
//                 child: Text(
//                   '*',
//                   style: TextStyle(color: Colors.red, fontSize: 16),
//                 ),
//               )
//             : null,
//         suffixIconConstraints: const BoxConstraints(
//           minWidth: 20,
//           minHeight: 20,
//         ),
//         enabledBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
//         ),
//         focusedBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(color: _darkGreen, width: 1.5),
//         ),
//         errorBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.red, width: 1),
//         ),
//         focusedErrorBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.red, width: 1.5),
//         ),
//         contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
//         errorStyle: const TextStyle(fontSize: 10, height: 0.8),
//       ),
//       validator: required
//           ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null
//           : null,
//     );
//   }

//   // ── Underline dropdown ──────────────────────────────────────────────────────
//   Widget _buildDropdown({
//     required String hint,
//     required List<String> items,
//     required String? value,
//     required ValueChanged<String?> onChanged,
//     bool required = true,
//   }) {
//     return DropdownButtonFormField<String>(
//       value: value,
//       isExpanded: true,
//       icon: const Icon(Icons.arrow_drop_down, color: Colors.grey, size: 22),
//       style: const TextStyle(fontSize: 14, color: Colors.black87),
//       dropdownColor: Colors.white,
//       decoration: InputDecoration(
//         hintText: hint,
//         hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
//         suffixIcon: required
//             ? const Padding(
//                 padding: EdgeInsets.only(right: 24, top: 12),
//                 child: Text(
//                   '*',
//                   style: TextStyle(color: Colors.red, fontSize: 16),
//                 ),
//               )
//             : null,
//         suffixIconConstraints: const BoxConstraints(
//           minWidth: 20,
//           minHeight: 20,
//         ),
//         enabledBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
//         ),
//         focusedBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(color: _darkGreen, width: 1.5),
//         ),
//         errorBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.red, width: 1),
//         ),
//         focusedErrorBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.red, width: 1.5),
//         ),
//         contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
//         errorStyle: const TextStyle(fontSize: 10, height: 0.8),
//       ),
//       items: items
//           .map(
//             (e) => DropdownMenuItem(
//               value: e,
//               child: Text(
//                 e,
//                 style: const TextStyle(fontSize: 14, color: Colors.black87),
//               ),
//             ),
//           )
//           .toList(),
//       onChanged: onChanged,
//       validator: required
//           ? (v) => (v == null || v.isEmpty) ? 'Required' : null
//           : null,
//     );
//   }

//   // ── Section divider ─────────────────────────────────────────────────────────
//   Widget _divider() =>
//       Divider(color: Colors.grey.shade200, thickness: 1, height: 16);

//   Future<void> _selectPickupDate() async {
//     final DateTime now = DateTime.now();
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: now,
//       firstDate: now,
//       lastDate: now.add(const Duration(days: 365)),
//     );

//     if (pickedDate != null) {
//       setState(() {
//         _pickupDateController.text =
//             '${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       resizeToAvoidBottomInset: false,
//       body: Column(
//         children: [
//           // ── Green header ─────────────────────────────────────────────
//           _buildHeader(),

//           // ── Non-scrollable form ──────────────────────────────────────────
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Full Name

//                     // Contact Number
//                     _buildField(
//                       controller: _contactController,
//                       hint: 'Contact Number',
//                       keyboard: TextInputType.phone,
//                       formatters: [FilteringTextInputFormatter.digitsOnly],
//                     ),

//                     // Email
//                     _buildField(
//                       controller: _emailController,
//                       hint: 'Email Address',
//                       keyboard: TextInputType.emailAddress,
//                     ),

//                     // Pickup Address
//                     _buildField(
//                       controller: _addressController,
//                       hint: 'Pickup Address',
//                       maxLines: 1,
//                       required: false,
//                     ),
//                     _buildField(
//                       controller: _pickupDateController,
//                       hint: 'Pickup Date',
//                       readOnly: true,
//                       onTap: _selectPickupDate,
//                     ),

//                     _divider(),

//                     // District
//                     _buildDropdown(
//                       hint: 'State',
//                       items: _state,
//                       value: _selectedState,
//                       onChanged: (v) => setState(() {
//                         _selectedState = v;
//                         _selectedDistrict = null;
//                       }),
//                     ),
//                     _buildDropdown(
//                       hint: 'District',
//                       items: _districts,
//                       value: _selectedDistrict,
//                       onChanged: (v) => setState(() {
//                         _selectedDistrict = v;
//                         _selectedLocalBody = null;
//                       }),
//                     ),

//                     // Local Body
//                     _buildDropdown(
//                       hint: 'Local Body',
//                       items: _localBodies,
//                       value: _selectedLocalBody,
//                       onChanged: (v) => setState(() => _selectedLocalBody = v),
//                     ),

//                     // Ward Name & Number
//                     _buildDropdown(
//                       hint: 'Ward Name & Number',
//                       items: _wards,
//                       value: _selectedWard,
//                       onChanged: (v) => setState(() => _selectedWard = v),
//                       required: false,
//                     ),

//                     // Secondary Number
//                     _buildField(
//                       controller: _secondaryController,
//                       hint: 'Secondary Number',
//                       keyboard: TextInputType.phone,
//                       formatters: [FilteringTextInputFormatter.digitsOnly],
//                       required: false,
//                     ),

//                     // Location
//                     // _buildField(
//                     //   controller: _locationController,
//                     //   hint: 'Tap to pick location on map',
//                     //   required: false,
//                     //   readOnly: true,
//                     //   onTap: () async {
//                     //     final result = await Navigator.push(
//                     //       context,
//                     //       MaterialPageRoute(
//                     //         builder: (context) => const LocationPickerScreen(),
//                     //       ),
//                     //     );
//                     //     if (result != null && result is Map<String, dynamic>) {
//                     //       setState(() {
//                     //         _locationController.text = result['address'] ?? '';
//                     //       });
//                     //     }
//                     //   },
//                     // ),

//                     // Submit button
//                     SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           if (_formKey.currentState!.validate()) {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => BookingConfirmationScreen(
//                                   bookingDetails: BookingDetails(
//                                     bookingId: 'WC-2026-08741',
//                                     wasteType: 'Mixed Household Waste',
//                                     collectionDate: 'Monday, 28 Apr 2026',
//                                     collectionTime: '09:00 AM – 12:00 PM',
//                                     address: _addressController.text,
//                                     city: _selectedDistrict ?? '',
//                                     pincode: '682025',
//                                     contactName: _nameController.text,
//                                     contactPhone: _contactController.text,
//                                     status: 'Confirmed',
//                                     estimatedWeight: 12.5,
//                                     specialInstructions:
//                                         'Please ring the bell twice. Gate is on the left side.',
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xFF4CAF50),
//                           foregroundColor: Colors.white,
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         child: const Text(
//                           'SUBMIT',
//                           style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold,
//                             letterSpacing: 1.8,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ── Header widget ───────────────────────────────────────────────────────────
//   Widget _buildHeader() {
//     return Container(
//       decoration: const BoxDecoration(
//         color: _headerGreen,
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(24),
//           bottomRight: Radius.circular(24),
//         ),
//       ),
//       child: SafeArea(
//         bottom: false,
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
//           child: Column(
//             children: [
//               // Top bar
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   _headerIconBtn(
//                     icon: Icons.arrow_back_ios_new_rounded,
//                     onTap: () => Navigator.pop(context),
//                   ),
//                   const Text(
//                     'Schedule Pickup',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 0.3,
//                     ),
//                   ),
//                   _headerIconBtn(
//                     icon: Icons.home_rounded,
//                     onTap: () {
//                       Navigator.popUntil(context, (route) => route.isFirst);
//                       Provider.of<HomeProvider>(
//                         context,
//                         listen: false,
//                       ).setSelectedIndex(0);
//                     },
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 14),

//               // Welcome card
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 18,
//                   vertical: 14,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(14),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.08),
//                       blurRadius: 10,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     const Text(
//                       'Welcome back, T! 👋',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 17,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Manage your waste collection and track your\nenvironmental impact',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey.shade600,
//                         height: 1.5,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _headerIconBtn({required IconData icon, required VoidCallback onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 36,
//         height: 36,
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.25),
//           shape: BoxShape.circle,
//         ),
//         child: Icon(icon, color: Colors.white, size: 16),
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:suchigo_app/Screens.dart/booking_confirmation_screen.dart';
import 'home_screen.dart';
import 'package:provider/provider.dart';
import 'package:suchigo_app/provider/home_provider.dart';
import 'package:suchigo_app/services/address_api_service.dart';
import 'package:suchigo_app/services/pickup_api_service.dart';

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
  final _addressController = TextEditingController(); // street / house info
  final _secondaryController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  final _bagsController = TextEditingController(text: '1');

  String? _selectedDistrict;
  String? _selectedState;
  String? _selectedLocalBody;
  String? _selectedWard;
  String? _selectedTimeSlot;
  DateTime? _selectedDate;

  bool _isSubmitting = false;
  String? _submitError;
  final ScrollController _scrollController = ScrollController();

  static const Color _darkGreen = Color(0xFF1E713D);
  static const Color _headerGreen = Color(0xFF4CAF50);

  final List<String> _districts = ['Ernakulam', 'Thrissur'];
  final List<String> _state = ['Kerala', 'Tamilnadu'];

  final List<String> _localBodies = [
    'Kochi Corporation',
    'Thrissur Corporation',
  ];

  final List<String> _wards = List.generate(20, (i) => 'Ward ${i + 1}');

  // Time slots map to a representative start hour (24h) used to build the
  // ISO 8601 scheduled_date sent to the backend.
  final List<Map<String, dynamic>> _timeSlots = const [
    {'label': '9:00 AM – 12:00 PM', 'hour': 9},
    {'label': '12:00 PM – 3:00 PM', 'hour': 12},
    {'label': '3:00 PM – 6:00 PM', 'hour': 15},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _pickupDateController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _secondaryController.dispose();
    _landmarkController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _bagsController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ── Builds the UTC ISO-8601 string DRF's DateTimeField expects ──────────
  // e.g. "2026-10-25T10:00:00Z" — must be built as UTC explicitly, since
  // DateTime(...).toIso8601String() on a *local* DateTime produces no "Z"
  // and an unexpected offset.
  String _buildScheduledDateIso() {
    final date = _selectedDate!;
    final hour = _timeSlots.firstWhere(
      (slot) => slot['label'] == _selectedTimeSlot,
    )['hour'] as int;

    final utcDateTime = DateTime.utc(date.year, date.month, date.day, hour, 0, 0);
    return utcDateTime.toIso8601String().replaceFirst('.000Z', 'Z');
  }

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
        _selectedDate = pickedDate;
        _pickupDateController.text =
            '${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}';
      });
    }
  }

  // Returns a human-readable list of which required fields are currently
  // empty/unselected. Used to build a precise, visible error message
  // instead of letting the form fail validation silently (which is what
  // was happening before: validate() returning false on a dropdown that
  // was scrolled off-screen produced NO visible feedback at all).
  List<String> _missingFieldLabels() {
    final missing = <String>[];
    if (_nameController.text.trim().isEmpty) missing.add('Full Name');
    if (_contactController.text.trim().isEmpty) missing.add('Contact Number');
    if (_emailController.text.trim().isEmpty) missing.add('Email Address');
    if (_addressController.text.trim().isEmpty) missing.add('Pickup Address');
    if (_cityController.text.trim().isEmpty) missing.add('City');
    if (_zipController.text.trim().isEmpty) missing.add('Zip / Postal Code');
    if (_pickupDateController.text.trim().isEmpty || _selectedDate == null) {
      missing.add('Pickup Date');
    }
    if (_selectedTimeSlot == null) missing.add('Pickup Time Slot');
    if (_selectedState == null) missing.add('State');
    if (_selectedDistrict == null) missing.add('District');
    if (_selectedLocalBody == null) missing.add('Local Body');
    if (_selectedWard == null) missing.add('Ward Name & Number');
    if (_bagsController.text.trim().isEmpty) missing.add('Number of Bags');
    return missing;
  }

  Future<void> _submitForm() async {
    // Run the form's own field-level validators first (this populates the
    // red error text under each TextFormField/DropdownButtonFormField).
    final formIsValid = _formKey.currentState?.validate() ?? false;

    // Independently check which fields are empty, since dropdown values
    // live in plain Dart fields (_selectedState, etc.) rather than
    // TextEditingControllers, and a dropdown's red error text is easy to
    // miss if it's scrolled off-screen. This gives a precise, visible
    // summary no matter which fields are the problem.
    final missing = _missingFieldLabels();

    if (!formIsValid || missing.isNotEmpty) {
      setState(() {
        _submitError = missing.isNotEmpty
            ? 'Please fill in: ${missing.join(', ')}'
            : 'Please fix the highlighted fields above.';
      });
      // Scroll to top so the error banner (placed near the top of the
      // scrollable form) is immediately visible, even if the user was
      // scrolled down near the Submit button when they tapped it.
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    try {
      // ── STEP 1: Save the address ────────────────────────────────────
      final addressResponse = await AddressApiService.createAddress(
        street: _addressController.text.trim(),
        city: _cityController.text.trim(),
        // Backend sample payload uses lowercase free-text values
        // ("kerala", "ernakulam") — normalize dropdown selections to match.
        state: (_selectedState ?? '').toLowerCase(),
        district: (_selectedDistrict ?? '').toLowerCase(),
        zipCode: _zipController.text.trim(),
        ward: (_selectedWard ?? '').toUpperCase().replaceAll(' ', ''),
        localBody: _selectedLocalBody ?? '',
        numberOfBags: int.tryParse(_bagsController.text.trim()) ?? 1,
        isDefault: true,
      );

      // ── STEP 2: Create the pickup, using the landmark field directly ──
      final pickupResponse = await PickupApiService.createPickup(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        contactNumber: _contactController.text.trim(),
        pickupAddress: _addressController.text.trim(),
        scheduledDate: _buildScheduledDateIso(),
        itemsDescription: _secondaryController.text.trim().isNotEmpty
            ? _secondaryController.text.trim()
            : 'General household waste',
        landmark: _landmarkController.text.trim().isNotEmpty
            ? _landmarkController.text.trim()
            : null,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pickup scheduled successfully!'),
          backgroundColor: _darkGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
      );

      // ── Build confirmation screen straight from real backend data ────
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BookingConfirmationScreen(
            bookingDetails: BookingDetails.fromApiResponses(
              pickupJson: pickupResponse,
              addressJson: addressResponse,
              selectedTimeSlotLabel: _selectedTimeSlot!,
              fallbackContactName: _nameController.text.trim(),
              fallbackContactPhone: _contactController.text.trim(),
            ),
          ),
        ),
      );
    } on AddressSubmissionException catch (e) {
      setState(() => _submitError = 'Address error — ${e.message}');
    } on PickupSubmissionException catch (e) {
      setState(() => _submitError = 'Pickup error — ${e.message}');
    } catch (e) {
      setState(() => _submitError = 'Unexpected error: $e');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // ── DEBUG-ONLY: Preview the confirmation screen ─────────────────────────
  // Lets you verify BookingConfirmationScreen's layout and data binding
  // without depending on the live backend (currently returning 401 until
  // the Django permission_classes fix is deployed).
  //
  // This calls the EXACT SAME BookingDetails.fromApiResponses() factory
  // that the real submit flow uses, fed with mock JSON shaped exactly like
  // a real POST /api/addresses/ and POST /api/pickups/ response. That
  // means: once the backend is fixed and the real submit works, the
  // confirmation screen will look identical to what this preview shows —
  // there's no separate "fake" rendering path to fall out of sync.
  //
  // SAFE TO DELETE: this entire method, plus the button that calls it
  // below, are wrapped in `if (kDebugMode)` and compile out of release
  // builds automatically. You can also just delete both blocks once the
  // backend is confirmed working, if you'd rather not leave them in at all.
  void _previewConfirmationScreenWithMockData() {
    final mockAddressResponse = <String, dynamic>{
      'id': 1,
      'street': _addressController.text.trim().isNotEmpty
          ? _addressController.text.trim()
          : '456 Main Road',
      'city': _cityController.text.trim().isNotEmpty
          ? _cityController.text.trim()
          : 'Kochi',
      'state': (_selectedState ?? 'kerala').toLowerCase(),
      'district': (_selectedDistrict ?? 'ernakulam').toLowerCase(),
      'zip_code': _zipController.text.trim().isNotEmpty
          ? _zipController.text.trim()
          : '682020',
      'ward': (_selectedWard ?? 'WARD1').toUpperCase().replaceAll(' ', ''),
      'local_body': _selectedLocalBody ?? 'Kochi Corporation',
      'number_of_bags': int.tryParse(_bagsController.text.trim()) ?? 2,
      'is_default': true,
      'user': 1,
    };

    final mockPickupResponse = <String, dynamic>{
      'id': 8741,
      'name': _nameController.text.trim().isNotEmpty
          ? _nameController.text.trim()
          : 'Preview Customer',
      'email': _emailController.text.trim().isNotEmpty
          ? _emailController.text.trim()
          : 'preview@example.com',
      'contact_number': _contactController.text.trim().isNotEmpty
          ? _contactController.text.trim()
          : '+919876543210',
      'landmark': _landmarkController.text.trim().isNotEmpty
          ? _landmarkController.text.trim()
          : 'Near the school',
      'scheduled_date': _selectedDate != null
          ? _buildScheduledDateIso()
          : '2026-10-25T10:00:00Z',
      'items_description': _secondaryController.text.trim().isNotEmpty
          ? _secondaryController.text.trim()
          : 'Electronics and documents',
      'pickup_address': _addressController.text.trim().isNotEmpty
          ? _addressController.text.trim()
          : '456 Main Road',
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingConfirmationScreen(
          bookingDetails: BookingDetails.fromApiResponses(
            pickupJson: mockPickupResponse,
            addressJson: mockAddressResponse,
            selectedTimeSlotLabel: _selectedTimeSlot ?? '9:00 AM – 12:00 PM',
            fallbackContactName: _nameController.text.trim().isNotEmpty
                ? _nameController.text.trim()
                : 'Preview Customer',
            fallbackContactPhone: _contactController.text.trim().isNotEmpty
                ? _contactController.text.trim()
                : '+919876543210',
          ),
        ),
      ),
    );
  }

  // ── Underline text field ──────────────────────────────────────────────
  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    bool required = true,
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
    List<TextInputFormatter>? formatters,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? customValidator,
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
                child: Text('*', style: TextStyle(color: Colors.red, fontSize: 16)),
              )
            : null,
        suffixIconConstraints: const BoxConstraints(minWidth: 20, minHeight: 20),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400, width: 1)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _darkGreen, width: 1.5)),
        errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1)),
        focusedErrorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        errorStyle: const TextStyle(fontSize: 10, height: 0.8),
      ),
      validator: customValidator ??
          (required
              ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null
              : null),
    );
  }

  // ── Underline dropdown ─────────────────────────────────────────────────
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
                child: Text('*', style: TextStyle(color: Colors.red, fontSize: 16)),
              )
            : null,
        suffixIconConstraints: const BoxConstraints(minWidth: 20, minHeight: 20),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400, width: 1)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _darkGreen, width: 1.5)),
        errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1)),
        focusedErrorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        errorStyle: const TextStyle(fontSize: 10, height: 0.8),
      ),
      items: items
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e, style: const TextStyle(fontSize: 14, color: Colors.black87)),
              ))
          .toList(),
      onChanged: onChanged,
      validator: required ? (v) => (v == null || v.isEmpty) ? 'Required' : null : null,
    );
  }

  Widget _divider() => Divider(color: Colors.grey.shade200, thickness: 1, height: 16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_submitError != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.error_outline, color: Colors.red.shade700, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _submitError!,
                                style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Full Name
                    _buildField(controller: _nameController, hint: 'Full Name'),

                    // Contact Number
                    _buildField(
                      controller: _contactController,
                      hint: 'Contact Number',
                      keyboard: TextInputType.phone,
                      formatters: [FilteringTextInputFormatter.digitsOnly],
                      customValidator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        if (v.trim().length < 7) return 'Enter a valid phone number';
                        return null;
                      },
                    ),

                    // Email
                    _buildField(
                      controller: _emailController,
                      hint: 'Email Address',
                      keyboard: TextInputType.emailAddress,
                      customValidator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                        if (!emailRegex.hasMatch(v.trim())) return 'Enter a valid email';
                        return null;
                      },
                    ),

                    // Pickup Address (street)
                    _buildField(
                      controller: _addressController,
                      hint: 'Pickup Address (House / Street)',
                    ),

                    // City
                    _buildField(controller: _cityController, hint: 'City'),

                    // Zip code
                    _buildField(
                      controller: _zipController,
                      hint: 'Zip / Postal Code',
                      keyboard: TextInputType.number,
                      formatters: [FilteringTextInputFormatter.digitsOnly],
                    ),

                    // Landmark
                    _buildField(
                      controller: _landmarkController,
                      hint: 'Landmark (e.g. Near the school)',
                      required: false,
                    ),

                    // Pickup Date
                    _buildField(
                      controller: _pickupDateController,
                      hint: 'Pickup Date',
                      readOnly: true,
                      onTap: _selectPickupDate,
                    ),

                    const SizedBox(height: 6),

                    // Time slot dropdown
                    _buildDropdown(
                      hint: 'Pickup Time Slot',
                      items: _timeSlots.map((s) => s['label'] as String).toList(),
                      value: _selectedTimeSlot,
                      onChanged: (v) => setState(() => _selectedTimeSlot = v),
                    ),

                    _divider(),

                    // State
                    _buildDropdown(
                      hint: 'State',
                      items: _state,
                      value: _selectedState,
                      onChanged: (v) => setState(() {
                        _selectedState = v;
                        _selectedDistrict = null;
                      }),
                    ),

                    // District
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
                    ),

                    // Number of bags
                    _buildField(
                      controller: _bagsController,
                      hint: 'Number of Bags',
                      keyboard: TextInputType.number,
                      formatters: [FilteringTextInputFormatter.digitsOnly],
                      customValidator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        final n = int.tryParse(v.trim());
                        if (n == null || n < 1) return 'Enter at least 1 bag';
                        return null;
                      },
                    ),

                    // Items description / secondary notes
                    _buildField(
                      controller: _secondaryController,
                      hint: 'Items Description (e.g. Mixed household waste)',
                      required: false,
                      maxLines: 2,
                    ),

                    if (_submitError != null) const SizedBox(height: 4),

                    const SizedBox(height: 16),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFF4CAF50).withOpacity(0.6),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'SUBMIT',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.8,
                                ),
                              ),
                      ),
                    ),

                    // ── DEBUG-ONLY preview button ───────────────────────
                    // Lets you see BookingConfirmationScreen's real layout
                    // right now, without waiting on the backend 401 fix.
                    // Compiles out of release builds automatically since
                    // it's wrapped in `if (kDebugMode)`.
                    if (kDebugMode) ...[
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: OutlinedButton.icon(
                          onPressed: _previewConfirmationScreenWithMockData,
                          icon: const Icon(Icons.visibility_outlined, size: 18),
                          label: const Text(
                            'Booking Confirmation ',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.deepPurple,
                            side: const BorderSide(color: Colors.deepPurple, width: 1.2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        // 'Debug only — uses mock data, does not call the API. '
                        // 'Hidden automatically in release builds.'
                        ''
                        ,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10.5, color: Colors.grey),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header widget ─────────────────────────────────────────────────────
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
                      Provider.of<HomeProvider>(context, listen: false).setSelectedIndex(0);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
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
                      'Welcome back! 👋',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage your waste collection and track your\nenvironmental impact',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.5),
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
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}
