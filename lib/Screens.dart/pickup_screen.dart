
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:suchigo_app/provider/PickupDetailsProvider.dart';

import 'package:suchigo_app/Screens.dart/address_screen.dart';
import 'package:suchigo_app/Screens.dart/home_screen.dart';
import 'package:suchigo_app/Screens.dart/bill_screen.dart';
import 'package:suchigo_app/Screens.dart/profile_screen.dart';
import 'package:suchigo_app/Screens.dart/settings_screen.dart';
import 'package:suchigo_app/Screens.dart/track_screen.dart';


class PickupScreen extends StatelessWidget {
  const PickupScreen({super.key});

  Future<void> _selectDate(BuildContext context, PickupDetailsProvider provider) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: provider.selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      provider.setSelectedDate(picked);
    }
  }

  
  Future<void> _selectTime(BuildContext context, PickupDetailsProvider provider) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: provider.selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      provider.setSelectedTime(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use context.watch<T>() to listen for changes to the state
    final pickupProvider = context.watch<PickupDetailsProvider>();
    // Use context.read<T>() for functions/actions that don't rebuild the widget
    final pickupAction = context.read<PickupDetailsProvider>();

    // Using a local controller to manage the TextField,
    // which then updates the provider on change.
    final TextEditingController addressController = TextEditingController(text: pickupProvider.pickupAddress);
    addressController.selection = TextSelection.fromPosition(
        TextPosition(offset: addressController.text.length)); // Keep cursor at end

    return Scaffold(
      backgroundColor: const Color(0xFFE6F4E6), // light green background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row with Back + Home icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BillScreen(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Title
                const Text(
                  "Pickup Details",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),

                const Text(
                  "Let us know where and when to pick up your waste.\nThis helps us plan accordingly",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 30),

                // Pickup Address Label
                const Text(
                  "Pickup Address",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),

                // Address field
                TextField(
                  controller: addressController,
                  onChanged: (value) => pickupAction.setPickupAddress(value), // Update Provider on change
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.location_searching_outlined,
                      color: Colors.black54,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFE6F4E6),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.4),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.4),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // Change location text
                GestureDetector(
                  onTap: () {
                    // Navigate to a dedicated location screen or open a map picker
                  },
                  child: const Text(
                    "Change location",
                    style: TextStyle(
                      color: Color(0xFF1E713D),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Date & Time Row
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "Pickup Date",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "Pickup Time",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selectDate(context, pickupAction),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6F4E6),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.4),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_outlined,
                                    size: 18,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    // Use state from the provider
                                    pickupProvider.selectedDate != null
                                        ? DateFormat('yyyy-MM-dd')
                                            .format(pickupProvider.selectedDate!)
                                        : "Select Date",
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selectTime(context, pickupAction),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6F4E6),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.4),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.access_time_outlined,
                                    size: 18,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    // Use state from the provider
                                    pickupProvider.selectedTime != null
                                        ? pickupProvider.selectedTime!.format(context)
                                        : "Select Time",
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 150),

                // Schedule Pickup (outlined)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF1E713D)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Logic for "Schedule Pickup"
                    },
                    child: const Text(
                      "Schedule Pickup",
                      style: TextStyle(
                        color: Color(0xFF1E713D),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Confirm Pickup (filled)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E713D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Call the action method on the provider
                      pickupAction.confirmPickup(); 
                      
                      // Your original navigation logic
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddressScreen1(),
                        ),
                      );
                    },
                    child: const Text(
                      "Confirm Pickup",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(selectedIndex: 0),
    );
  }
}

// --------------------- Custom Bottom Navigation ----------------------

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