import 'package:flutter/material.dart';
import 'package:suchigo_app/Screens.dart/home_screen.dart';
import 'package:suchigo_app/Screens.dart/bill_screen.dart';
import 'package:suchigo_app/Screens.dart/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 3; // Profile tab

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // 🌿 Header with gradient and background bubbles
                    Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                      colors: [
                        Color(0xFF1E713D),
                        Color.fromARGB(235, 137, 208, 139),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(80),
                      bottomRight: Radius.circular(80),
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                      // ← Back button at top-left
                      Positioned(
                        top: 16,
                        left: 8,
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

                      // 💫 Bubbles
                      Positioned(
                        top: 40,
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
                        top: 100,
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
                        bottom: 30,
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

                      // 🧍 Profile content
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage(
                          'assets/icons/pic.png',
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "Username",
                          style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "+917736905991",
                          style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          ),
                        ),
                        ],
                      ),
                      ],
                    ),
                    ),

                  // 🧾 White card with shadow & profile options
                  Positioned(
                    left: 40,
                    right: 40,
                    top: 300,
                    bottom: 120,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.25),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              SizedBox(height: 8),
                              ProfileItem(
                                icon: Icons.account_balance_wallet_outlined,
                                text: "SuchiGo Wallet",
                              ),
                              ProfileItem(
                                icon: Icons.history_outlined,
                                text: "Order History",
                              ),
                              ProfileItem(
                                icon: Icons.person_outline,
                                text: "Account",
                              ),
                              ProfileItem(
                                icon: Icons.phone_outlined,
                                text: "Contact Us",
                              ),
                              ProfileItem(
                                icon: Icons.card_giftcard_outlined,
                                text: "My Rewards",
                              ),
                              ProfileItem(
                                icon: Icons.more_vert,
                                text: "More....",
                              ),
                              SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🌱 Reusable Profile Item widget
class ProfileItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const ProfileItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1E713D)),
      title: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF1E713D),
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      contentPadding: EdgeInsets.zero,
      dense: true,
      horizontalTitleGap: 10,
    );
  }
}
