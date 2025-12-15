import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suchigo_app/Screens.dart/submit_screen.dart';
import 'package:suchigo_app/Screens.dart/pickup_screen.dart';
import 'package:suchigo_app/Screens.dart/home_screen.dart';
import 'package:suchigo_app/Screens.dart/bill_screen.dart';
import 'package:suchigo_app/Screens.dart/profile_screen.dart';
import 'package:suchigo_app/Screens.dart/settings_screen.dart';
import 'package:suchigo_app/provider/AddressProvider.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  const CustomBottomNav({super.key, required this.selectedIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == selectedIndex) return; 

    Widget destination;
    switch (index) {
      case 0:
        destination = const HomeScreen();
        break;
      case 1:
        destination = const BillScreen();
        break;
      case 2:
        destination = const SettingsScreen();
        break;
      case 3:
        destination = const ProfileScreen();
        break;
      default:
        destination = const HomeScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) => _onItemTapped(context, index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF1E713D),
      unselectedItemColor: Colors.grey.shade500,
      showUnselectedLabels: true,
      items: [
        BottomNavigationBarItem(
          icon: Image.asset('assets/icons/HOME (2).png', width: 26, height: 26),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Image.asset('assets/icons/bill.png', width: 26, height: 26),
          label: 'Bill',
        ),
        BottomNavigationBarItem(
          icon: Image.asset('assets/icons/settings.png', width: 26, height: 26),
          label: 'Settings',
        ),
        BottomNavigationBarItem(
          icon: Image.asset('assets/icons/person.png', width: 26, height: 26),
          label: 'Profile',
        ),
      ],
    );
  }
}

/// ✅ Address Form Screen
class AddressScreen1 extends StatefulWidget {
  const AddressScreen1({super.key});

  @override
  State<AddressScreen1> createState() => _AddressScreen1State();
}

class _AddressScreen1State extends State<AddressScreen1> {
  final _formKey = GlobalKey<FormState>();

  
  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: const Color(0xFFEFF9F1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ✅ HEADER CONTAINER
              Transform.translate(
                offset: Offset(0, MediaQuery.of(context).size.height * 0.01),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left side icons
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.notification_add_rounded,
                                  color: Colors.white,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 15, 48, 137),
                                ),
                              ),
                              const SizedBox(height: 10),
                              IconButton(
                                onPressed: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PickupScreen(),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(148, 197, 193, 193),
                                  shape: const CircleBorder(),
                                ),
                              ),
                            ],
                          ),

                          // Right side icons
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.location_on_sharp,
                                  color: Colors.white,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 15, 48, 137),
                                ),
                              ),
                              const SizedBox(height: 10),
                              // IconButton removed as it was commented out in original
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Welcome Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Welcome back, T! 👋",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Manage your waste collection and track your environmental impact",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ✅ FORM SECTION
              Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildLabel("Full Name"),
                      // Use provider setter
                      buildTextField(
                        initialValue: addressProvider.name,
                        onChanged: addressProvider.setName,
                        hint: "Full Name",
                      ),

                      buildLabel("Email Address"),
                      // Use provider setter
                      buildTextField(
                        initialValue: addressProvider.email,
                        onChanged: addressProvider.setEmail,
                        hint: "Email Address",
                      ),

                      buildLabel("Contact Number"),
                      // Use provider setter
                      buildTextField(
                        initialValue: addressProvider.contact,
                        onChanged: addressProvider.setContact,
                        hint: "Contact Number",
                      ),

                      buildLabel("Select Pickup Date"),
                      // Use a custom TextFormField for date picking
                      TextFormField(
                        // Use provider getter for display
                        controller: TextEditingController(text: addressProvider.date),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            String formattedDate =
                                "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                            // Use provider setter
                            addressProvider.setDate(formattedDate);
                          }
                        },
                        decoration: inputDecoration("Select Date"),
                        validator: (value) =>
                          value == null || value.isEmpty ? 'Please select a date' : null,
                      ),
                      const SizedBox(height: 10),

                      buildLabel("Pickup Address"),
                      // Use provider setter
                      buildTextField(
                        initialValue: addressProvider.address,
                        onChanged: addressProvider.setAddress,
                        hint: "Pickup Address",
                      ),

                      buildLabel("Land mark"),
                      // Use provider setter
                      buildTextField(
                        initialValue: addressProvider.landmark,
                        onChanged: addressProvider.setLandmark,
                        hint: "Land mark",
                      ),

                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E713D),
                            minimumSize: const Size(double.infinity, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                             
                              
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddressScreen2 (), 
                                ),
                              );
                            }
                          },
                          child: const Text(
                            "NEXT",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
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
      ),

      /// ✅ Bottom Navigation added here
      bottomNavigationBar: const CustomBottomNav(selectedIndex: 0),
    );
  }

  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
    );
  }

  Widget buildTextField({
    required String initialValue,
    required void Function(String) onChanged,
    required String hint,
  }) {
    return TextFormField(
      initialValue: initialValue.isNotEmpty ? initialValue : null,
      onChanged: onChanged,
      decoration: inputDecoration(hint),
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter $hint' : null,
    );
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFF4CAF50),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }
}