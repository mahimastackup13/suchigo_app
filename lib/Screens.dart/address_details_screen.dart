// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:suchigo_app/Screens.dart/booking_confirmation_screen.dart';
// import 'package:suchigo_app/provider/home_provider.dart';
// import 'package:suchigo_app/provider/address_details_provider.dart'; // Updated package target name mapping
// import 'package:suchigo_app/model/address_model.dart';

// class AddressDetailsScreen extends StatefulWidget {
//   const AddressDetailsScreen({super.key});

//   @override
//   State<AddressDetailsScreen> createState() => _AddressDetailsScreenState();
// }

// class _AddressDetailsScreenState extends State<AddressDetailsScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final _streetController = TextEditingController();
//   final _cityController = TextEditingController();
//   final _stateController = TextEditingController();
//   final _districtController = TextEditingController();
//   final _zipCodeController = TextEditingController();
//   final _wardController = TextEditingController();
//   final _localBodyController = TextEditingController();
//   final _bagsController = TextEditingController(text: "2");

//   static const Color _darkGreen = Color(0xFF1E713D);
//   static const Color _headerGreen = Color(0xFF4CAF50);

//   @override
//   void dispose() {
//     _streetController.dispose();
//     _cityController.dispose();
//     _stateController.dispose();
//     _districtController.dispose();
//     _zipCodeController.dispose();
//     _wardController.dispose();
//     _localBodyController.dispose();
//     _bagsController.dispose();
//     super.dispose();
//   }

//   Future<void> _submitForm() async {
//     if (!_formKey.currentState!.validate()) return;

//     final provider = context.read<AddressDetailsProvider>();

//     final addressPayload = AddressModel(
//       street: _streetController.text.trim(),
//       city: _cityController.text.trim(),
//       state: _stateController.text.trim(),
//       district: _districtController.text.trim(),
//       zipCode: _zipCodeController.text.trim(),
//       ward: _wardController.text.trim(),
//       localBody: _localBodyController.text.trim(),
//       numberOfBags: int.tryParse(_bagsController.text.trim()) ?? 2,
//       isDefault: true,
//       user: 1,
//     );

//     final success = await provider.submitAddress(addressPayload);

//     if (!mounted) return;

//     if (success) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Address details saved successfully!'),
//           backgroundColor: _darkGreen,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );

//       final created = provider.lastCreatedPickup ?? {};

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => BookingConfirmationScreen(
//             bookingDetails: BookingDetails(
//               bookingId: (created['id'] ?? '—').toString(),
//               wasteType: "Bags count: ${_bagsController.text.trim()}",
//               collectionDate: "Saved Dynamic Profile",
//               collectionTime: "",
//               address: "${_streetController.text.trim()}, ${_wardController.text.trim()}",
//               city: _cityController.text.trim(),
//               pincode: _zipCodeController.text.trim(),
//               contactName: "User #${created['user'] ?? '1'}",
//               contactPhone: "",
//               status: "Success",
//               estimatedWeight: 0.0,
//               specialInstructions: "Local Body: ${_localBodyController.text.trim()}",
//             ),
//           ),
//         ),
//       );
//     } else {
//       final message = provider.errorMessage ?? 'Could not synchronize address details.';
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: Colors.red.shade600,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     }
//   }

//   Widget _buildField({
//     required TextEditingController controller,
//     required String hint,
//     bool isRequired = true,
//     TextInputType keyboard = TextInputType.text,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboard,
//       style: const TextStyle(fontSize: 14, color: Colors.black87),
//       decoration: InputDecoration(
//         hintText: hint,
//         hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
//         suffixIcon: isRequired
//             ? const Padding(
//                 padding: EdgeInsets.only(right: 4, top: 12),
//                 child: Text(
//                   '*',
//                   style: TextStyle(color: Colors.red, fontSize: 16),
//                 ),
//               )
//             : null,
//         suffixIconConstraints: const BoxConstraints(minWidth: 20, minHeight: 20),
//         enabledBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
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
//       ),
//       validator: isRequired
//           ? (v) => (v == null || v.trim().isEmpty) ? 'Required field' : null
//           : null,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final addressDetailsProvider = context.watch<AddressDetailsProvider>();

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           _buildHeader(),
//           Expanded(
//             child: SingleChildScrollView(
//               keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       _buildField(controller: _streetController, hint: 'Street / House Name (e.g., 456 Main Road)'),
//                       const SizedBox(height: 14),
//                       _buildField(controller: _cityController, hint: 'City (e.g., Kochi)'),
//                       const SizedBox(height: 14),
//                       _buildField(controller: _stateController, hint: 'State (e.g., Kerala)'),
//                       const SizedBox(height: 14),
//                       _buildField(controller: _districtController, hint: 'District (e.g., Ernakulam)'),
//                       const SizedBox(height: 14),
//                       _buildField(controller: _zipCodeController, hint: 'Zip Code (Pincode)', keyboard: TextInputType.number),
//                       const SizedBox(height: 14),
//                       _buildField(controller: _wardController, hint: 'Ward Name / Number (e.g., FORTKOCHI)'),
//                       const SizedBox(height: 14),
//                       _buildField(controller: _localBodyController, hint: 'Local Body (e.g., Kochi Corporation)'),
//                       const SizedBox(height: 14),
//                       _buildField(controller: _bagsController, hint: 'Number of Bags', keyboard: TextInputType.number),
//                       const SizedBox(height: 32),
//                       SizedBox(
//                         width: double.infinity,
//                         height: 50,
//                         child: ElevatedButton(
//                           onPressed: addressDetailsProvider.isSubmitting ? null : _submitForm,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF4CAF50),
//                             disabledBackgroundColor: const Color(0xFF4CAF50).withOpacity(0.6),
//                             foregroundColor: Colors.white,
//                             elevation: 0,
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                           ),
//                           child: addressDetailsProvider.isSubmitting
//                               ? const SizedBox(
//                                   width: 22,
//                                   height: 22,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2.4,
//                                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                                   ),
//                                 )
//                               : const Text(
//                                   'SAVE ADDRESS DETAILS',
//                                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 1.8),
//                                 ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       decoration: const BoxDecoration(
//         color: _headerGreen,
//         borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
//       ),
//       child: SafeArea(
//         bottom: false,
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   _headerIconBtn(
//                     icon: Icons.arrow_back_ios_new_rounded,
//                     onTap: () => Navigator.pop(context),
//                   ),
//                   const Text(
//                     'Manage Address Details',
//                     style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.3),
//                   ),
//                   _headerIconBtn(
//                     icon: Icons.home_rounded,
//                     onTap: () {
//                       Navigator.popUntil(context, (route) => route.isFirst);
//                       Provider.of<HomeProvider>(context, listen: false).setSelectedIndex(0);
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 14),
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
//                 decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
//                 child: Column(
//                   children: [
//                     const Text(
//                       'Welcome back, T! 👋',
//                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black87),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Manage your waste collection and track your\nenvironmental impact',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.5),
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
//         decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), shape: BoxShape.circle),
//         child: Icon(icon, color: Colors.white, size: 16),
//       ),
//     );
//   }
// }