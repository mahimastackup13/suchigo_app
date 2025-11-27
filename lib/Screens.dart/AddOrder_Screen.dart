// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:suchigo_app/provider/waste_provider.dart';
// // import 'package:suchigo_app/provider/waste_provider.dart';
// import 'orders_screen.dart';

// class AddOrderScreen extends StatefulWidget {
//   const AddOrderScreen({super.key});

//   @override
//   State<AddOrderScreen> createState() => _AddOrderScreenState();
// }

// class _AddOrderScreenState extends State<AddOrderScreen> {
//   final customer = TextEditingController();
//   final localbody = TextEditingController();
//   final ward = TextEditingController();
//   final location = TextEditingController();
//   final buildingNo = TextEditingController();
//   final streetName = TextEditingController();
//   final kg = TextEditingController();

//   final _formKey = GlobalKey<FormState>();

//   @override
//   void dispose() {
//     customer.dispose();
//     localbody.dispose();
//     ward.dispose();
//     location.dispose();
//     buildingNo.dispose();
//     streetName.dispose();
//     kg.dispose();
//     super.dispose();
//   }

//   Widget buildField(
//       {required TextEditingController controller,
//       required String label,
//       TextInputType keyboardType = TextInputType.text,
//       String? Function(String?)? validator}) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//         ),
//         validator: validator,
//       ),
//     );
//   }

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) return;

//     final provider = Provider.of<WasteProvider>(context, listen: false);

//     try {
//       final success = await provider.addWasteEntry({
//         "customer": customer.text.trim(),
//         "localbody": localbody.text.trim(),
//         "ward": ward.text.trim(),
//         "location": location.text.trim(),
//         "building_no": buildingNo.text.trim(),
//         "street_name": streetName.text.trim(),
//         "kg": int.tryParse(kg.text.trim()) ?? 0,
//       });

//       if (success) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Order submitted successfully!"),
//             backgroundColor: Colors.green,
//             duration: Duration(seconds: 2),
//           ),
//         );

//         await Future.delayed(const Duration(milliseconds: 500));

//         if (mounted) {
//           Navigator.pushReplacement(
//               context, MaterialPageRoute(builder: (_) => const OrdersScreen()));
//         }
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Error: $e"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isLoading = context.watch<WasteProvider>().loading;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Add Order")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               buildField(
//                 controller: customer,
//                 label: "Customer",
//                 validator: (v) => v!.isEmpty ? 'Required' : null,
//               ),
//               buildField(
//                 controller: localbody,
//                 label: "Localbody",
//                 validator: (v) => v!.isEmpty ? 'Required' : null,
//               ),
//               buildField(controller: ward, label: "Ward"),
//               buildField(controller: location, label: "Location"),
//               buildField(
//                   controller: buildingNo,
//                   label: "Building No",
//                   keyboardType: TextInputType.number),
//               buildField(controller: streetName, label: "Street Name"),
//               buildField(
//                 controller: kg,
//                 label: "KG",
//                 keyboardType: TextInputType.number,
//                 validator: (v) {
//                   if (v!.isEmpty) return "KG required";
//                   if (int.tryParse(v) == null) return "Enter valid number";
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: isLoading ? null : _submit,
//                   child: isLoading
//                       ? const CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: Colors.white,
//                         )
//                       : const Text("Submit"),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
