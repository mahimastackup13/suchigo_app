import 'package:flutter/material.dart';
import 'package:suchigo_app/Screens.dart/bill_screen.dart';
import 'package:suchigo_app/Screens.dart/profile_screen.dart';
import 'package:suchigo_app/Screens.dart/settings_screen.dart';

// The new screen indices will be:
// 0: HomeContent
// 1: BillScreen <--- Target for the "Book Now" button
// 2: SettingsScreen
// 3: ProfileScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomePageState();

  // You can keep the operator overload, though it's not standard practice.
  operator [](int other) {}
}

class _HomePageState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // The screens list contains ALL navigable destinations.
  // Note: We cannot use const here because HomeContent requires the callback.
  // The list is defined and populated in the build method.

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Define the callback function to navigate to the BillScreen (index 1)
  void _navigateToBillScreen() {
    // The BillScreen is at index 1 in the screensWithCallback list.
    _onItemTapped(1);
  }

  @override
  Widget build(BuildContext context) {
    // The list of screens with the HomeContent callback included.
    final List<Widget> screensWithCallback = [
      HomeContent(onBookNow: _navigateToBillScreen), // Index 0 (Home)
      const BillScreen(), // Index 1 (Bill - Hidden from Nav Bar)
      const SettingsScreen(), // Index 2 (Settings)
      const ProfileScreen(), // Index 3 (Profile)
    ];

    // This is the list of items for the actual BottomNavigationBar.
    // It will only contain Home, Settings, and Profile.
    // The index values here correspond to the position in the screensWithCallback list.
    final List<BottomNavigationBarItem> bottomNavItems = [
      BottomNavigationBarItem(
        icon: Image.asset('assets/icons/HOME (2).png', width: 26, height: 26),
        label: 'Home',
      ),
      // BillScreen is intentionally omitted from the BottomNavigationBar,
      // but is at index 1 in screensWithCallback.

      BottomNavigationBarItem(
        // This is the Settings Item, which corresponds to index 2 (SettingsScreen)
        // in the screensWithCallback list.
        icon: Image.asset(
          'assets/icons/settings.png',
          width: 26,
          height: 26,
        ),
        label: 'Settings',
      ),
      BottomNavigationBarItem(
        // This is the Profile Item, which corresponds to index 3 (ProfileScreen)
        // in the screensWithCallback list.
        icon: Image.asset('assets/icons/person.png', width: 26, height: 26),
        label: 'Profile',
      ),
    ];

    // Function to map BottomNavigationBar index to screen index.
    // Since the BillScreen (index 1) is skipped, the navigation bar indices are 0, 1, 2.
    // We need to map them to the full screen list: 0, 2, 3.
    // However, for simplicity and proper state management when switching *back* to Home,
    // we must allow all screens to be selected, including Bill.
    // The `_selectedIndex` holds the index of the screen to display (0, 1, 2, or 3).
    // The `currentIndex` of the nav bar must be managed carefully.

    // Let's adjust the `_onItemTapped` to correctly handle the non-linear indices.
    void _handleBottomNavTap(int navBarIndex) {
        int screenIndex = 0; // Default to Home

        if (navBarIndex == 0) {
            screenIndex = 0; // Home -> Home (Index 0)
        } else if (navBarIndex == 1) {
            screenIndex = 2; // Settings -> Settings (Index 2)
        } else if (navBarIndex == 2) {
            screenIndex = 3; // Profile -> Profile (Index 3)
        }
        _onItemTapped(screenIndex);
    }

    // Determine the active index for the BottomNavigationBar:
    // If the selected index is 0, 2, or 3, it should highlight Home (0), Settings (1), or Profile (2).
    // If the selected index is 1 (BillScreen), we don't want any item highlighted, so we use 0 (Home) as a fallback.
    int getBottomNavBarCurrentIndex() {
      if (_selectedIndex == 0) return 0; // Home
      if (_selectedIndex == 2) return 1; // Settings (is item index 1 in the nav bar)
      if (_selectedIndex == 3) return 2; // Profile (is item index 2 in the nav bar)
      return 0; // BillScreen (index 1) or any unexpected index falls back to Home
    }


    return Scaffold(
      backgroundColor: Colors.white,
      body: screensWithCallback[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: getBottomNavBarCurrentIndex(),
        onTap: _handleBottomNavTap, // Use the custom handler
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
  // 1. Define the callback function as a required parameter
  final VoidCallback onBookNow;

  const HomeContent({super.key, required this.onBookNow}); // 2. Require the callback

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header (Unchanged)
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
                    // color: const Color(0xFF1E713D),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Search Bar (Unchanged)
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

            // Trees & Points section (Unchanged)
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

            // Waste Activity (Unchanged)
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

            // Time Filter Buttons - Re-added as they were commented out above the new button
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

            // *** NEW: Book Now Button ***
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: onBookNow, // Triggers navigation to BillScreen (Index 1)
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E713D), // Green color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
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

            const SizedBox(height: 16), // Space between button and ad container

            // Ad section placeholder (Unchanged)
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