import 'package:flutter/material.dart';
import 'package:suchigo_app/Screens.dart/home_screen.dart';
import 'package:suchigo_app/Screens.dart/settings_screen.dart';
import 'package:suchigo_app/Screens.dart/profile_screen.dart';
import 'package:suchigo_app/Screens.dart/pickup_screen.dart';

class BillScreen extends StatefulWidget {
  const BillScreen({super.key});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  int? _selectedOption;
  int _selectedIndex = 1; // Bill tab

  final List<Widget> _screens = const [
    HomeScreen(),
    BillScreen(),
    SettingsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => _screens[index]),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
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

              // Radio options
              Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                RadioListTile<int>(
                  value: 1,
                  groupValue: _selectedOption,
                  activeColor: Colors.green.shade800,
                  title: const Text("Plastic waste"),
                  onChanged: (value) {
                  setState(() => _selectedOption = value);
                  },
                ),
                RadioListTile<int>(
                  value: 2,
                  groupValue: _selectedOption,
                  activeColor: Colors.green.shade800,
                  title: const Text("Organic waste"),
                  onChanged: (value) {
                  setState(() => _selectedOption = value);
                  },
                ),
                RadioListTile<int>(
                  value: 3,
                  groupValue: _selectedOption,
                  activeColor: Colors.green.shade800,
                  title: const Text("E-waste"),
                  onChanged: (value) {
                  setState(() => _selectedOption = value);
                  },
                ),
                RadioListTile<int>(
                  value: 4,
                  groupValue: _selectedOption,
                  activeColor: Colors.green.shade800,
                  title: const Text("Household items"),
                  onChanged: (value) {
                  setState(() => _selectedOption = value);
                  },
                ),
                ],
              ),
              ),

              // Continue Button
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
                onPressed: _selectedOption != null
                  ? () {
                    Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const PickupScreen()),
                    );
                  }
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

      // Bottom navigation
      
    );
  }
}
