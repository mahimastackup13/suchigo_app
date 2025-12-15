import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:suchigo_app/Screens.dart/home_screen.dart';
import 'package:suchigo_app/Screens.dart/login_screen.dart';
import 'package:suchigo_app/provider/settings_provider.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Widget _buildSettingItem(
    BuildContext context,
    IconData icon,
    String title, {
    bool isLogout = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout ? Colors.red : const Color(0xFF1E713D),
          size: 26,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isLogout ? Colors.red : Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.grey,
          size: 16,
        ),
        onTap: () async { 
          if (isLogout) {
            final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

            await settingsProvider.logout(); 

            if (context.mounted) { 
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (Route<dynamic> route) => false, 
                );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text("$title tapped!")),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F4E6),
      body: SafeArea(
        child: Column(
          children: [
            // --- Header Section ---
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

                // --- Back to Home Button ---
                Positioned(
                  top: 12,
                  left: 12,
                  child: SafeArea(
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        color: Colors.white,
                        iconSize: 28,
                        tooltip: 'Back to Home',
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                             Navigator.pop(context);
                          } else {
                             Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const HomeScreen()),
                              );
                          }
                        },
                      ),
                    ),
                  ),
                ),

                // --- Decorative Circles (Unchanged) ---
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

            // --- Settings List Section ---
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 25,
                ),
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
                    _buildSettingItem(context, Icons.lock_outline, "Privacy & Security"),
                    _buildSettingItem(
                      context,
                      Icons.notifications_outlined,
                      "Notification Preferences",
                    ),
                    _buildSettingItem(context, Icons.language, "Language"),
                    _buildSettingItem(context, Icons.help_outline, "Help & Support"),
                    _buildSettingItem(context, Icons.info_outline, "About App"),
                    // Logout now uses the Provider's logic
                    _buildSettingItem(context, Icons.logout, "Logout", isLogout: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}