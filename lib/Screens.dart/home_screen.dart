import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suchigo_app/provider/home_provider.dart';

import 'package:suchigo_app/Screens.dart/bill_screen.dart';
import 'package:suchigo_app/Screens.dart/profile_screen.dart';
import 'package:suchigo_app/Screens.dart/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();

    final List<Widget> screensWithCallback = [
      HomeContent(onBookNow: homeProvider.navigateToBillScreen),
      const BillScreen(),
      const SettingsScreen(),
      const ProfileScreen(),
    ];

    final List<BottomNavigationBarItem> bottomNavItems = [
      BottomNavigationBarItem(
        icon: Image.asset('assets/icons/HOME (2).png', width: 26, height: 26),
        label: 'Home',
      ),

      BottomNavigationBarItem(
        icon: Image.asset('assets/icons/settings.png', width: 26, height: 26),
        label: 'Settings',
      ),
      BottomNavigationBarItem(
        icon: Image.asset('assets/icons/person.png', width: 26, height: 26),
        label: 'Profile',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,

      body: screensWithCallback[homeProvider.selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: homeProvider.getBottomNavBarCurrentIndex(),

        onTap: homeProvider.handleBottomNavTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1E713D),
        unselectedItemColor: Colors.grey.shade500,
        showUnselectedLabels: true,
        items: bottomNavItems,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final VoidCallback onBookNow;

  const HomeContent({super.key, required this.onBookNow});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/icons/pic.png'),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "SACHIN",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 5,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: 0.7, // progress level
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E713D),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/icons/message.png',
                    width: 40,
                    height: 40,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.grey, size: 40),
                  SizedBox(width: 8),
                  Text(
                    "Add location",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF8E9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/icons/blacktree.png',
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Trees",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "11,235",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              "300",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              "Pks",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          "50KG GIVES",
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF8E9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your waste activity",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Great job! You’ve received \n 50kg this month!",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        _Bar(height: 8),
                        SizedBox(width: 6),
                        _Bar(height: 18),
                        SizedBox(width: 6),
                        _Bar(height: 28),
                        SizedBox(width: 6),
                        _Bar(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _TimeButton(label: "D", selected: true),
                const SizedBox(width: 8),
                _TimeButton(label: "W"),
                const SizedBox(width: 8),
                _TimeButton(label: "M"),
                const SizedBox(width: 8),
                _TimeButton(label: "Y"),
              ],
            ),

            const SizedBox(height: 20),

            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: onBookNow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E713D), // Green color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 60,
                    vertical: 12,
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  "Book Now",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  "ads",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double height;
  const _Bar({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF1E713D),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class _TimeButton extends StatelessWidget {
  final String label;
  final bool selected;
  const _TimeButton({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? Colors.black : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.grey.shade700,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
