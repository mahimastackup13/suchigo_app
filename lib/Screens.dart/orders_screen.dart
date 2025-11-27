import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:suchigo_app/Screens.dart/order_detail_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  TextEditingController searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // --------------------------------------------------------
            // 🔙 BACK BUTTON + TITLE (Updated)
            // --------------------------------------------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
              color: Colors.black,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Orders",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    /// Search Box
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
                                hintText: "Search orders...",
                                border: InputBorder.none,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Orders List
                    Expanded(
                      child: ListView(
                        children: [
                          orderCard(
                            name: "Bobin Abraham",
                            status: "Pending (5 days)",
                            id: "250916BIOEKM015",
                            phone: "+91 9496322103",
                            ward: "RAJAGIRI (3)",
                            homeType: "Home",
                            km: "3.59 KM",
                            assigned: "Not Assigned",
                            date: "30-Sep-2025",
                            onTapCard: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const OrderDetailScreen(),
                                ),
                              );
                            },
                          ),
                        ],
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

  /// ---------------- ORDER CARD ----------------
  Widget orderCard({
    required String name,
    required String status,
    required String id,
    required String phone,
    required String ward,
    required String homeType,
    required String km,
    required String assigned,
    required String date,
    required VoidCallback onTapCard,
  }) {
    return GestureDetector(
      onTap: onTapCard,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 3),
              color: Colors.black12,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top Row: Name + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                /// Pending Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE0E0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// Info Rows
            infoRow(id),
            infoRow(phone),
            infoRow(ward),
            infoRow(homeType),
            infoRow(km),
            infoRow(assigned),

            const SizedBox(height: 14),

            /// Action Buttons Row
            Row(
              children: [
                dateButton(date),

                const SizedBox(width: 12),

                blackIconButton(
                  Icons.message_rounded,
                  () => launchUrl(
                    Uri.parse("https://wa.me/$phone"),
                  ),
                ),

                const SizedBox(width: 12),

                blackIconButton(
                  Icons.location_pin,
                  () => launchUrl(
                    Uri.parse("https://maps.google.com?q=$km"),
                  ),
                ),

                const SizedBox(width: 12),

                blackIconButton(
                  Icons.call,
                  () => launchUrl(
                    Uri.parse("tel:$phone"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  /// ---------------- SMALL INFO ROW ----------------
  Widget infoRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          /// Green dot
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: Color(0xFFB1C85A),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- BLACK ICON BUTTON ----------------
  Widget blackIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 26),
      ),
    );
  }

  /// ---------------- DATE BUTTON ----------------
  Widget dateButton(String date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        date,
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
    );
  }
}

/// ---------------- NEW SCREEN WHEN CARD CLICKED ----------------
// class OrderDetailScreen extends StatelessWidget {
//   const OrderDetailScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Order Details"),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: const Center(
//         child: Text(
//           "Order Detail Screen",
//           style: TextStyle(fontSize: 22),
//         ),
//       ),
//     );
//   }
// }
