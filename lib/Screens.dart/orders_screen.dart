// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:suchigo_app/Screens.dart/order_detail_screen.dart';

// class OrdersScreen extends StatefulWidget {
//   const OrdersScreen({super.key});

//   @override
//   State<OrdersScreen> createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen> {
//   TextEditingController searchCtrl = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // --------------------------------------------------------
//             // 🔙 BACK BUTTON + TITLE (Updated)
//             // --------------------------------------------------------
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
//               color: Colors.black,
//               child: Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: const Icon(
//                       Icons.arrow_back,
//                       size: 28,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   const Text(
//                     "Orders",
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//                 ),
//                 child: Column(
//                   children: [
//                     /// Search Box
//                     Container(
//                       height: 52,
//                       padding: const EdgeInsets.symmetric(horizontal: 14),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFF3F3F3),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.search, color: Colors.black54),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: TextField(
//                               controller: searchCtrl,
//                               decoration: const InputDecoration(
//                                 hintText: "Search orders...",
//                                 border: InputBorder.none,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     /// Orders List
//                     Expanded(
//                       child: ListView(
//                         children: [
//                           orderCard(
//                             name: "Mohammed",
//                             status: "Pending (5 days)",
//                             id: "WC-2026-0847",
//                             phone: "+91 9567973038",
//                             ward: "RAJAGIRI (3)",
//                             homeType: "Home",
//                             km: "3.59 KM",
//                             assigned: "Not Assigned",
//                             date: "28-April-2026",
//                             onTapCard: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => const OrderDetailScreen(),
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// ---------------- ORDER CARD ----------------
//   Widget orderCard({
//     required String name,
//     required String status,
//     required String id,
//     required String phone,
//     required String ward,
//     required String homeType,
//     required String km,
//     required String assigned,
//     required String date,
//     required VoidCallback onTapCard,
//   }) {
//     return GestureDetector(
//       onTap: onTapCard,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 20),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: const [
//             BoxShadow(
//               blurRadius: 10,
//               spreadRadius: 2,
//               offset: Offset(0, 3),
//               color: Colors.black12,
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// Top Row: Name + Status
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   name,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),

//                 /// Pending Badge
//                 // Container(
//                 //   padding: const EdgeInsets.symmetric(
//                 //     horizontal: 12,
//                 //     vertical: 6,
//                 //   ),
//                 //   decoration: BoxDecoration(
//                 //     color: const Color(0xFFFFE0E0),
//                 //     borderRadius: BorderRadius.circular(20),
//                 //   ),
//                 //   child: Text(
//                 //     'status',
//                 //     style: const TextStyle(
//                 //       color: Colors.red,
//                 //       fontWeight: FontWeight.w600,
//                 //     ),
//                 //   ),
//                 // ),
//               ],
//             ),

//             const SizedBox(height: 12),

//             /// Info Rows
//             infoRow(id),
//             infoRow(phone),
//             infoRow(ward),
//             infoRow(homeType),
//             infoRow(km),
//             infoRow(assigned),

//             const SizedBox(height: 14),

//             /// Action Buttons Row
//             Row(
//               children: [
//                 dateButton(date),

//                 const SizedBox(width: 12),

//                 blackIconButton(
//                   Icons.message_rounded,
//                   () => launchUrl(Uri.parse("https://wa.me/$phone")),
//                 ),

//                 const SizedBox(width: 12),

//                 blackIconButton(
//                   Icons.location_pin,
//                   () => launchUrl(Uri.parse("https://maps.google.com?q=$km")),
//                 ),

//                 const SizedBox(width: 12),

//                 blackIconButton(
//                   Icons.call,
//                   () => launchUrl(Uri.parse("tel:$phone")),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// ---------------- SMALL INFO ROW ----------------
//   Widget infoRow(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Row(
//         children: [
//           /// Green dot
//           Container(
//             width: 10,
//             height: 10,
//             decoration: const BoxDecoration(
//               color: Color(0xFF4CAF50),
//               shape: BoxShape.circle,
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               text,
//               style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// ---------------- BLACK ICON BUTTON ----------------
//   Widget blackIconButton(IconData icon, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 42,
//         height: 42,
//         decoration: BoxDecoration(
//           color: Colors.black,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Icon(icon, color: Colors.white, size: 26),
//       ),
//     );
//   }

//   /// ---------------- DATE BUTTON ----------------
//   Widget dateButton(String date) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
//       decoration: BoxDecoration(
//         color: Colors.black,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Text(
//         date,
//         style: const TextStyle(color: Colors.white, fontSize: 15),
//       ),
//     );
//   }
// }

// /// ---------------- NEW SCREEN WHEN CARD CLICKED ----------------
// // class OrderDetailScreen extends StatelessWidget {
// //   const OrderDetailScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Order Details"),
// //         leading: IconButton(
// //           icon: const Icon(Icons.arrow_back),
// //           onPressed: () => Navigator.pop(context),
// //         ),
// //       ),
// //       body: const Center(
// //         child: Text(
// //           "Order Detail Screen",
// //           style: TextStyle(fontSize: 22),
// //         ),
// //       ),
// //     );
// //   }
// // }




import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:suchigo_app/Screens.dart/order_detail_screen.dart';
import 'package:suchigo_app/model/order_model.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  static const String _apiBaseUrl =
      'https://suchigo.pythonanywhere.com/api/locations/';

  final TextEditingController searchCtrl = TextEditingController();

  List<OrderModel> _allOrders = [];
  List<OrderModel> _filteredOrders = [];

  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchOrders();
    searchCtrl.addListener(_applySearchFilter);
  }

  @override
  void dispose() {
    searchCtrl.removeListener(_applySearchFilter);
    searchCtrl.dispose();
    super.dispose();
  }

  // --- API INTEGRATION ---
  Future<void> fetchOrders() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http
          .get(Uri.parse(_apiBaseUrl))
          .timeout(const Duration(seconds: 15));

      if (!mounted) return;

      if (response.statusCode == 200) {
        final dynamic decoded = json.decode(response.body);

        // Defensive: the API should return a List, but guard against a
        // single-object response (e.g. if the backend ever changes shape).
        final List<dynamic> jsonList = decoded is List
            ? decoded
            : (decoded is Map && decoded['results'] is List)
                ? decoded['results'] as List<dynamic>
                : <dynamic>[];

        final parsedOrders = jsonList
            .whereType<Map<String, dynamic>>()
            .map((data) => OrderModel.fromJson(data))
            .toList();

        setState(() {
          _allOrders = parsedOrders;
          _filteredOrders = parsedOrders;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Server error: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage =
            'Failed to connect to the server. Please check your internet.';
        isLoading = false;
      });
      debugPrint('API Error: $e');
    }
  }

  void _applySearchFilter() {
    final query = searchCtrl.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredOrders = _allOrders;
      } else {
        _filteredOrders = _allOrders.where((order) {
          return order.name.toLowerCase().contains(query) ||
              order.ward.toLowerCase().contains(query) ||
              order.id.toString().contains(query) ||
              order.contactNumber.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  // --- SAFE URL LAUNCHER ---
  Future<void> safelyLaunchUrl(String urlString, BuildContext context) async {
    final Uri url = Uri.parse(urlString);
    try {
      final launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot open link or invalid data provided.')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot open link or invalid data provided.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BACK BUTTON + TITLE
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
              color: Colors.black,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, size: 28, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Orders",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    // Search Box
                    Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.black54),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: searchCtrl,
                              decoration: const InputDecoration(
                                hintText: "Search by name, ward, ID or phone...",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // UI State Management: Loading, Error, Empty, or List
                    Expanded(
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator(color: Colors.black))
                          : errorMessage.isNotEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(errorMessage, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
                                      const SizedBox(height: 8),
                                      ElevatedButton(onPressed: fetchOrders, child: const Text("Retry")),
                                    ],
                                  ),
                                )
                              : _filteredOrders.isEmpty
                                  ? RefreshIndicator(
                                      onRefresh: fetchOrders,
                                      child: ListView(
                                        children: const [
                                          SizedBox(height: 100),
                                          Center(child: Text("No orders found")),
                                        ],
                                      ),
                                    )
                                  : RefreshIndicator(
                                      onRefresh: fetchOrders,
                                      child: ListView.builder(
                                        itemCount: _filteredOrders.length,
                                        itemBuilder: (context, index) {
                                          final order = _filteredOrders[index];
                                          return orderCard(
                                            order: order,
                                            onTapCard: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => OrderDetailScreen(orderData: order),
                                                ),
                                              );
                                            },
                                            context: context,
                                          );
                                        },
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
    );
  }

  // ORDER CARD — now driven entirely by the real OrderModel, no fake/placeholder fields
  Widget orderCard({
    required OrderModel order,
    required VoidCallback onTapCard,
    required BuildContext context,
  }) {
    final addressPreview = order.fullAddress.isNotEmpty
        ? order.fullAddress
        : 'No address provided';

    return GestureDetector(
      onTap: onTapCard,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(blurRadius: 10, spreadRadius: 2, offset: Offset(0, 3), color: Colors.black12),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(order.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            infoRow("ORD-${order.id}"),
            infoRow(order.contactNumber),
            infoRow("Ward: ${order.ward}"),
            infoRow(addressPreview),
            infoRow("Items: ${order.itemsDescription} • Bags: ${order.numberOfBags}"),
            const SizedBox(height: 14),
            Row(
              children: [
                dateButton("Today"),
                const SizedBox(width: 12),
                blackIconButton(
                  Icons.message_rounded,
                  () {
                    if (!order.hasValidPhone) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No phone number provided')),
                      );
                      return;
                    }
                    safelyLaunchUrl(
                      "https://wa.me/${_sanitizePhone(order.contactNumber)}",
                      context,
                    );
                  },
                ),
                const SizedBox(width: 12),
                blackIconButton(
                  Icons.location_pin,
                  () {
                    if (order.fullAddress.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No address provided')),
                      );
                      return;
                    }
                    safelyLaunchUrl(
                      "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(order.fullAddress)}",
                      context,
                    );
                  },
                ),
                const SizedBox(width: 12),
                blackIconButton(
                  Icons.call,
                  () {
                    if (!order.hasValidPhone) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No phone number provided')),
                      );
                      return;
                    }
                    safelyLaunchUrl("tel:${order.contactNumber}", context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// WhatsApp's wa.me links need digits only (no +, spaces, or dashes).
  String _sanitizePhone(String phone) => phone.replaceAll(RegExp(r'[^\d]'), '');

  Widget infoRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            width: 10,
            height: 10,
            decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget blackIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42, height: 42,
        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: Colors.white, size: 26),
      ),
    );
  }

  Widget dateButton(String date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)),
      child: Text(date, style: const TextStyle(color: Colors.white, fontSize: 15)),
    );
  }
}

