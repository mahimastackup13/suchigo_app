// 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:suchigo_app/Screens.dart/home_screen.dart';
import 'package:suchigo_app/Screens.dart/pickup_screen.dart';
import 'package:suchigo_app/provider/bill_provider.dart'; // Import BillProvider

class BillScreen extends StatelessWidget {
  const BillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Consumer to access the BillProvider state and logic
    return Consumer<BillProvider>(
      builder: (context, billProvider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFE6F4E6),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  IconButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    ),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color.fromARGB(148, 197, 193, 193),
                      shape: const CircleBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Title
                  const Text(
                    "Household waste details",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Help us understand what you’re disposing \n of so we can come prepared with the right \n tools and team",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Radio options (Uses Provider state and setter)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRadioTile(
                          context,
                          value: 1,
                          title: "Plastic waste",
                          billProvider: billProvider,
                        ),
                        _buildRadioTile(
                          context,
                          value: 2,
                          title: "Organic waste",
                          billProvider: billProvider,
                        ),
                        _buildRadioTile(
                          context,
                          value: 3,
                          title: "E-waste",
                          billProvider: billProvider,
                        ),
                        _buildRadioTile(
                          context,
                          value: 4,
                          title: "Household items",
                          billProvider: billProvider,
                        ),
                      ],
                    ),
                  ),

                  // Continue Button (Uses Provider state for enabled/disabled, and logic for onPressed)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: billProvider.selectedOption != null
                          ? () => billProvider.continueToPickup(context) // Calls Provider logic
                          : null,
                      child: const Text(
                        "CONTINUE",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Note: Bottom navigation bar logic is complex for a single screen;
          // it is typically handled by a shell widget (like a main scaffold) 
          // that contains the _screens list.
        );
      },
    );
  }

  // Helper function to build cleaner RadioListTiles
  Widget _buildRadioTile(
    BuildContext context, {
    required int value,
    required String title,
    required BillProvider billProvider,
  }) {
    return RadioListTile<int>(
      value: value,
      groupValue: billProvider.selectedOption, // Reads state from Provider
      activeColor: Colors.green.shade800,
      title: Text(title),
      onChanged: billProvider.setSelectedOption, // Calls setter on Provider
    );
  }
}