// // File: widgets/pickup_dashboard_list.dart
// //
// // Drop this into your dashboard/home screen wherever you want to show
// // the user's pickup history. It pulls from AddressProvider, which in
// // turn calls GET https://suchigoapis.pythonanywhere.com/api/pickups/
// //
// // Usage:
// //   ChangeNotifierProvider(
// //     create: (_) => AddressProvider(),
// //     child: ...,
// //   )
// // (or read from your existing top-level provider if AddressProvider is
// // already registered higher up in main.dart)
// //
// // Then anywhere inside that provider's scope:
// //   const PickupDashboardList()

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:suchigo_app/provider/AddressProvider.dart';

// class PickupDashboardList extends StatefulWidget {
//   const PickupDashboardList({super.key});

//   @override
//   State<PickupDashboardList> createState() => _PickupDashboardListState();
// }

// class _PickupDashboardListState extends State<PickupDashboardList> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch as soon as this widget mounts.
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<AddressProvider>().fetchPickups();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<AddressProvider>();

//     if (provider.isLoadingPickups && provider.pickups.isEmpty) {
//       return const Padding(
//         padding: EdgeInsets.symmetric(vertical: 32),
//         child: Center(child: CircularProgressIndicator()),
//       );
//     }

//     if (provider.pickupsError != null && provider.pickups.isEmpty) {
//       return Padding(
//         padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
//         child: Column(
//           children: [
//             Text(
//               provider.pickupsError!,
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.red.shade600, fontSize: 13),
//             ),
//             const SizedBox(height: 8),
//             TextButton(
//               onPressed: () => context.read<AddressProvider>().fetchPickups(),
//               child: const Text('Retry'),
//             ),
//           ],
//         ),
//       );
//     }

//     if (provider.pickups.isEmpty) {
//       return const Padding(
//         padding: EdgeInsets.symmetric(vertical: 32),
//         child: Center(
//           child: Text(
//             'No pickups scheduled yet.',
//             style: TextStyle(color: Colors.grey),
//           ),
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: () => context.read<AddressProvider>().fetchPickups(),
//       child: ListView.separated(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: provider.pickups.length,
//         separatorBuilder: (_, __) => const SizedBox(height: 10),
//         itemBuilder: (context, index) {
//           final pickup = provider.pickups[index];
//           return _PickupCard(pickup: pickup);
//         },
//       ),
//     );
//   }
// }

// class _PickupCard extends StatelessWidget {
//   final Map<String, dynamic> pickup;
//   const _PickupCard({required this.pickup});

//   @override
//   Widget build(BuildContext context) {
//     // Defensive reads: backend response shape isn't confirmed yet, so
//     // every field has a fallback rather than throwing on a null.
//     final address = (pickup['address'] ?? '—').toString();
//     final date = (pickup['date'] ?? '—').toString();
//     final status = (pickup['status'] ?? 'Pending').toString();

//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   address,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14,
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   date,
//                   style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//             decoration: BoxDecoration(
//               color: const Color(0xFF4CAF50).withOpacity(0.12),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Text(
//               status,
//               style: const TextStyle(
//                 color: Color(0xFF1E713D),
//                 fontSize: 11,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
