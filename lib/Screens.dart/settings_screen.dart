import 'package:flutter/material.dart';
import 'package:suchigo_app/Screens.dart/home_screen.dart';
import 'package:suchigo_app/Screens.dart/login_screen.dart';
import 'pickup_screen.dart';
import 'bill_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PickupScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BillScreen()),
        );
        break;
      case 2:
        // Already on Settings
        break;
      case 3:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile Screen Coming Soon")),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F4E6),
      body: SafeArea(
        child: Column(
          children: [
            // Green Header
            Stack(
              children: [
              Container(
              width: double.infinity,
              height: 250,
              decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E713D), Color(0xFF48A86E)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              ),
              child: const Center(
              child: Text(
                "Settings",
                style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
                ),
              ),
              ),
              ),

              // Home icon button at top-left
              Positioned(
              top: 12,
              left: 12,
              child: SafeArea(
                child: Material(
                color: Colors.transparent,
                child: IconButton(
                  icon: const Icon(Icons.home_rounded),
                  color: Colors.white,
                  iconSize: 28,
                  tooltip: 'Home',
                  onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                  },
                ),
                ),
              ),
              ),

              Positioned(
                    top: 20,
                    left: 60,
                    child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.15),
                        Colors.white.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      ),
                    ),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    right: 40,
                    child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.05),
                      ],
                      ),
                    ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 100,
                    child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.03),
                      ],
                      ),
                    ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 40,
                    child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.12),
                        Colors.white.withOpacity(0.04),
                      ],
                      ),
                    ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 30),

            // White Rounded Card
            Expanded(
              child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
                ],
              ),
              child: ListView(
                children: [
                _buildSettingItem(Icons.lock_outline, "Privacy & Security"),
                _buildSettingItem(Icons.notifications_outlined,
                  "Notification Preferences"),
                _buildSettingItem(Icons.language, "Language"),
                _buildSettingItem(Icons.help_outline, "Help & Support"),
                _buildSettingItem(Icons.info_outline, "About App"),
                _buildSettingItem(Icons.logout, "Logout", isLogout: true),
                ],
              ),
              ),
            ),
            const SizedBox(height: 20), // Add space above the card
            
          ],
        ),
      ),

     
    );
  }

  Widget _buildSettingItem(IconData icon, String title,
      {bool isLogout = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon,
        color: isLogout ? Colors.red : const Color(0xFF1E713D), size: 26),
        title: Text(
          title,
          style: TextStyle(
        color: isLogout ? Colors.red : Colors.black87,
        fontSize: 16,
        fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded,
        color: Colors.grey, size: 16),
        onTap: () {
          if (isLogout) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
          }
        },
      ),
    );
  }
}
