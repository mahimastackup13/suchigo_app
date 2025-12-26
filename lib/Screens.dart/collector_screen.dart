import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:suchigo_app/Screens.dart/select_ward_screen.dart';
import 'package:suchigo_app/Screens.dart/login_screen.dart';
import 'package:suchigo_app/provider/CollectorProvider.dart';

// ---------------------------------------------------------------------
// PROVIDER CLASS
// ---------------------------------------------------------------------
// class CollectorProvider with ChangeNotifier {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController wardController = TextEditingController();

//   String? selectedScrapDistrict;
//   String? selectedDhDistrict;
//   String? selectedDhLocalbody;

//   final List<String> districts = ["Thrissur", "Ernakulam"];
//   bool isLoading = false;

//   Future<void> fetchCollectorData() async {
//     isLoading = true;
//     notifyListeners();

//     try {
//       final response = await http.get(
//         Uri.parse("https://suchigo.pythonanywhere.com/api/locations/"),
//       );
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         nameController.text = data['name'] ?? "";
//         // Ensure the value exists in our list or default to Ernakulam
//         selectedScrapDistrict = districts.contains(data['scrap_district'])
//             ? data['scrap_district']
//             : "Ernakulam";
//         selectedDhDistrict = districts.contains(data['dh_district'])
//             ? data['dh_district']
//             : "Ernakulam";
//         selectedDhLocalbody = data['dh_localbody'] ?? "Kalamassery";
//         wardController.text = data['ward'] ?? "";
//       }
//     } catch (e) {
//       debugPrint("Error fetching data: $e");
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }

//   void updateScrapDistrict(String? newValue) {
//     selectedScrapDistrict = newValue;
//     notifyListeners();
//   }

//   void updateDhDistrict(String? newValue) {
//     selectedDhDistrict = newValue;
//     notifyListeners();
//   }
// }

// ---------------------------------------------------------------------
// COLLECTOR SCREEN
// ---------------------------------------------------------------------
class CollectorScreen extends StatefulWidget {
  const CollectorScreen({super.key});

  @override
  State<CollectorScreen> createState() => _CollectorScreenState();
}

class _CollectorScreenState extends State<CollectorScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data from API when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CollectorProvider>().fetchCollectorData();
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   final provider = context.watch<CollectorProvider>();

  //   return Scaffold(
  //     backgroundColor: Colors.transparent,
  //     body: Stack(
  //       children: [
  //         // Background Image
  //         Positioned.fill(
  //           child: Image.asset(
  //             "assets/images/background.jpg",
  //             fit: BoxFit.cover,
  //           ),
  //         ),

  //         provider.isLoading
  //             ? const Center(
  //                 child: CircularProgressIndicator(color: Colors.white),
  //               )
  //             : SafeArea(
  //                 child: SingleChildScrollView(
  //                   child: Column(
  //                     children: [
  //                       // APP BAR
  //                       AppBar(
  //                         backgroundColor: Colors.transparent,
  //                         elevation: 0,
  //                         automaticallyImplyLeading: false,
  //                         title: const Text(
  //                           "Collector Profile",
  //                           style: TextStyle(
  //                             color: Colors.black,
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 24,
  //                           ),
  //                         ),
  //                         actions: [
  //                           IconButton(
  //                             icon: const Icon(Icons.logout, color: Colors.red),
  //                             onPressed: () {
  //                               Navigator.pushReplacement(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                   builder: (_) => const LoginScreen(),
  //                                 ),
  //                               );
  //                             },
  //                           ),
  //                         ],
  //                       ),
  //                       const SizedBox(height: 20),

  //                       // Profile Image
  //                       const Center(
  //                         child: CircleAvatar(
  //                           radius: 55,
  //                           backgroundColor: Colors.white,
  //                           child: CircleAvatar(
  //                             radius: 50,
  //                             backgroundImage: AssetImage(
  //                               "assets/images/profilepic.png",
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(height: 10),

  //                       // INPUT FIELDS (Using updated buildInfoCard)
  //                       buildInfoCard(
  //                         title: "Name :",
  //                         isTextField: true,
  //                         controller: provider.nameController,
  //                       ),
  //                       buildInfoCard(
  //                         title: "Scrap District :",
  //                         isDropdown: true,
  //                         dropdownValue: provider.selectedScrapDistrict,
  //                         items: provider.districts,
  //                         onChanged: provider.updateScrapDistrict,
  //                       ),
  //                       buildInfoCard(
  //                         title: "DH District :",
  //                         isDropdown: true,
  //                         dropdownValue: provider.selectedDhDistrict,
  //                         items: provider.districts,
  //                         onChanged: provider.updateDhDistrict,
  //                       ),
  //                       buildInfoCard(
  //                         title: "DH Localbody :",
  //                         isTextField: true,
  //                         controller: TextEditingController(
  //                           text: provider.selectedDhLocalbody,
  //                         ),
  //                       ),
  //                       buildInfoCard(
  //                         title: "Ward :",
  //                         isTextField: true,
  //                         controller: provider.wardController,
  //                       ),
  @override
Widget build(BuildContext context) {
  final provider = context.watch<CollectorProvider>();

  return Scaffold(
    backgroundColor: Colors.transparent,
    // --- ADDED SAVE BUTTON ---
    floatingActionButton: FloatingActionButton.extended(
      backgroundColor: const Color(0xFFD4E277),
      onPressed: () async {
        bool success = await provider.updateCollectorData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(success ? "Profile Saved!" : "Failed to save profile"),
              backgroundColor: success ? Colors.green : Colors.red,
            ),
          );
        }
      },
      icon: const Icon(Icons.save, color: Colors.black),
      label: const Text("Save Changes", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
    ),
    body: Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/images/background.jpg",
            fit: BoxFit.cover,
          ),
        ),
        provider.isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
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
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
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
                      // Added a controller to Localbody so it's editable via HTTP request
                      buildInfoCard(
                        title: "DH Localbody :",
                        isTextField: true,
                        controller: TextEditingController(text: provider.selectedDhLocalbody)..selection = TextSelection.collapsed(offset: provider.selectedDhLocalbody?.length ?? 0),
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
  // UPDATED INFO CARD WITH TEXTFIELD & DROPDOWN SUPPORT
  // ---------------------------------------------------------
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
          if (showChange)
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
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
                    MaterialPageRoute(builder: (_) => const HistoryScreen()),
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
                    MaterialPageRoute(builder: (_) => const ReportScreen()),
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

// ---------------------------------------------------------------------
// PLACEHOLDER SCREENS
// ---------------------------------------------------------------------
class ChangeScreen extends StatelessWidget {
  const ChangeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Change")),
    body: const Center(child: Text("Change Details")),
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
