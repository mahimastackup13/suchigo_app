//
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suchigo_app/Screens.dart/AddOrder_Screen.dart';
import 'package:suchigo_app/Screens.dart/select_ward_screen.dart';
import 'package:suchigo_app/provider/CollectorProvider.dart';
import 'package:suchigo_app/Screens.dart/welcome_screen.dart';

class CollectorScreen extends StatefulWidget {
  const CollectorScreen({super.key});

  @override
  State<CollectorScreen> createState() => _CollectorScreenState();
}

class _CollectorScreenState extends State<CollectorScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CollectorProvider>().fetchCollectorData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CollectorProvider>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromARGB(239, 38, 82, 44),
        onPressed: () async {
          bool success = await provider.updateCollectorData();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  success ? "Profile Saved!" : "Failed to save profile",
                ),
                backgroundColor: success ? const Color(0xFF4CAF50) : Colors.red,
              ),
            );
          }
        },
        icon: const Icon(Icons.save, color: Colors.black),
        label: const Text(
          "Save Changes",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,

                  colors: [
                    Color.from(alpha: 1, red: 0.024, green: 0.035, blue: 0.106),
                    Color(0xFF4CAF50),
                  ],
                ),
              ),
            ),
          ),
          provider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          automaticallyImplyLeading: false,
                          title: const Text(
                            "Collector Profile",
                            style: TextStyle(
                              color: Color(0xFF4CAF50),
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
                                  MaterialPageRoute(
                                    builder: (_) => const WelcomeScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        buildInfoCard(
                          title: "Name :",
                          isTextField: true,
                          controller: provider.nameController,
                        ),
                        buildInfoCard(
                          title: "Scrap District :",
                          isDropdown: true,
                          dropdownValue: provider.selectedScrapDistrict,
                          items: provider.districts,
                          onChanged: provider.updateScrapDistrict,
                        ),
                        buildInfoCard(
                          title: "DH District :",
                          isDropdown: true,
                          dropdownValue: provider.selectedDhDistrict,
                          items: provider.districts,
                          onChanged: provider.updateDhDistrict,
                        ),
                        // FIXED: Replaced inline instantiation with Provider Controller
                        buildInfoCard(
                          title: "DH Localbody :",
                          isTextField: true,
                          controller: provider.dhLocalbodyController,
                        ),
                        buildInfoCard(
                          title: "Ward :",
                          isTextField: true,
                          controller: provider.wardController,
                        ),
                        const SizedBox(height: 15),
                        sectionTitle("Sanitary Orders"),
                        orderButtonGrid(
                          context: context,
                          color: const Color.fromRGBO(156, 198, 158, 1),
                        ),
                        const SizedBox(height: 15),
                        sectionTitle("Scrap Orders"),
                        orderButtonGrid(
                          context: context,
                          color: const Color.fromRGBO(172, 192, 179, 1),
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

  Widget buildInfoCard({
    required String title,
    String? value,
    bool showChange = false,
    VoidCallback? onTap,
    bool isTextField = false,
    bool isDropdown = false,
    TextEditingController? controller,
    String? dropdownValue,
    List<String>? items,
    Function(String?)? onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: isTextField
                ? TextField(
                    controller: controller,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  )
                : isDropdown
                ? DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      isExpanded: true,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      items: items?.map((String val) {
                        return DropdownMenuItem<String>(
                          value: val,
                          child: Text(val),
                        );
                      }).toList(),
                      onChanged: onChanged,
                    ),
                  )
                : Text(
                    value ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

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
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SelectWardScreen()),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: orderButton(
                  title: "Add Order",
                  bgColor: color,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddOrderScreen()),
                  ),
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
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Scaffold(
                        appBar: AppBar(title: const Text('History')),
                        body: const Center(child: Text('History screen')),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: orderButton(
                  title: "Report",
                  bgColor: color,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Scaffold(
                        appBar: AppBar(title: const Text('Report')),
                        body: const Center(child: Text('Report screen')),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
