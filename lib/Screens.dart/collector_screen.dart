
import 'package:flutter/material.dart';
import 'package:suchigo_app/Screens.dart/select_ward_screen.dart';
import 'package:suchigo_app/Screens.dart/login_screen.dart';

class CollectorScreen extends StatelessWidget {
  const CollectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Make scaffold background transparent
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.jpg", // Assuming you have this asset
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ---------------------------------------------------------
                  // APP BAR WITH LOGOUT BUTTON
                  // ---------------------------------------------------------
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    title: const Text(
                      "Collector Profile",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.red),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Profile Image
                  const Center(
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 50,
                        // Update with your actual profile image asset
                        backgroundImage: AssetImage("assets/images/profilepic.png"),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  buildInfoCard(title: "Name :", value: "Ashraf bio"),
                  buildInfoCard(
                    title: "Scrap District :",
                    value: "Ernakulam",
                    showChange: true,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const ChangeScreen()));
                    },
                  ),
                  buildInfoCard(
                    title: "DH District :",
                    value: "Ernakulam",
                    showChange: true,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const ChangeScreen()));
                    },
                  ),
                  buildInfoCard(
                    title: "DH Localbody :",
                    value: "Kalamassery",
                    showChange: true,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const ChangeScreen()));
                    },
                  ),

                  const SizedBox(height: 15),

                  sectionTitle("Sanitary Orders"),
                  orderButtonGrid(
                    context: context,
                    color: const Color(0xFFD1E39C),
                  ),

                  const SizedBox(height: 15),

                  sectionTitle("Scrap Orders"),
                  orderButtonGrid(
                    context: context,
                    color: const Color(0xFFFFCC80),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // INFO CARD
  // ---------------------------------------------------------
  Widget buildInfoCard({
    required String title,
    required String value,
    bool showChange = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              text: "$title  ",
              style: const TextStyle(fontSize: 15, color: Colors.black),
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          // CHANGE Button
          if (showChange)
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4E277),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Change",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // SECTION TITLE
  // ---------------------------------------------------------
  Widget sectionTitle(String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 18, bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // GRID OF ORDER BUTTONS
  // ---------------------------------------------------------
  Widget orderButtonGrid({
    required BuildContext context,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: orderButton(
                  title: "Orders",
                  bgColor: color,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SelectWardScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: orderButton(
                  title: "Add Order",
                  bgColor: color,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddOrderScreen()),
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: orderButton(
                  title: "History",
                  bgColor: color,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HistoryScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: orderButton(
                  title: "Report",
                  bgColor: color,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ReportScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // ORDER BUTTON
  // ---------------------------------------------------------
  Widget orderButton({
    required String title,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.arrow_right, size: 24),
              const SizedBox(width: 4),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------
// PLACEHOLDER SCREENS (Replace with your real screens)
// ---------------------------------------------------------------------

class ChangeScreen extends StatelessWidget {
  const ChangeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text("Change Screen")),
        body: const Center(child: Text("Change Details Here")),
      );
}

class AddOrderScreen extends StatelessWidget {
  const AddOrderScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text("Add Order")),
        body: const Center(child: Text("Add Order Screen")),
      );
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text("History")),
        body: const Center(child: Text("History Screen")),
      );
}

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text("Report")),
        body: const Center(child: Text("Report Screen")),
      );
}