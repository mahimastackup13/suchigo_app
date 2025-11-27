// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:suchigo_app/provider/register_provider.dart';
// import 'package:suchigo_app/provider/waste_provider.dart';
// import 'package:suchigo_app/provider/location_provider.dart';

// class OrdersScreen extends StatelessWidget {
//   const OrdersScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Orders")),
//       body: Consumer<WasteProvider>(
//         builder: (context, provider, _) {
//           if (provider.loading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (provider.wasteList.isEmpty) {
//             return const Center(child: Text("No Orders Found"));
//           }

//           return ListView.builder(
//             itemCount: provider.wasteList.length,
//             itemBuilder: (context, i) {
//               final item = provider.wasteList[i];
//               return ListTile(
//                 title: Text(item.customer),
//                 subtitle: Text("${item.localbody}, ${item.location}"),
//                 trailing: Text("${item.kg} KG"),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
