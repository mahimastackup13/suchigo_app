import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suchigo_app/provider/home_provider.dart';

import 'package:suchigo_app/Screens.dart/bill_screen.dart';
import 'package:suchigo_app/Screens.dart/profile_screen.dart';
import 'package:suchigo_app/Screens.dart/settings_screen.dart';
import 'package:suchigo_app/Screens.dart/location_picker_screen.dart';

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
      backgroundColor: const Color(0xFFF5F5F5),
      body: screensWithCallback[homeProvider.selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: homeProvider.getBottomNavBarCurrentIndex(),
          onTap: homeProvider.handleBottomNavTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF4CAF50),
          unselectedItemColor: Colors.grey.shade500,
          showUnselectedLabels: true,
          elevation: 0,
          items: bottomNavItems,
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  final VoidCallback onBookNow;

  const HomeContent({super.key, required this.onBookNow});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String _selectedLocation = "Add location";

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            // ── Green Header with gradient ───────────────────────────────────
            _GreenHeader(),

            // ── Scrollable Content ───────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Search Bar (Clickable) ──────────────────────
                      GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const LocationPickerScreen(),
                            ),
                          );
                          if (result != null &&
                              result is Map<String, dynamic>) {
                            setState(() {
                              _selectedLocation =
                                  result['address'] ?? "Location Selected";
                            });
                          }
                        },
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search_rounded,
                                color: Colors.grey.shade500,
                                size: 22,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _selectedLocation,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: _selectedLocation == "Add location"
                                        ? Colors.grey.shade500
                                        : Colors.black87,
                                    fontSize: 15,
                                    fontWeight:
                                        _selectedLocation == "Add location"
                                        ? FontWeight.normal
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // ── Ad Banner ─────────────────────────────────────
                      _AdBanner(),

                      const SizedBox(height: 20),

                      // ── Waste Category Icons ──────────────────────────
                      _WasteCategoryRow(),

                      const SizedBox(height: 20),

                      // ── Stat Cards ────────────────────────────────────
                      Row(
                        children: [
                          // Trees card
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 18,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6F5EC),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.park_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Trees",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        "11,235",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 14),

                          // 300 Pks card
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 18,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: Colors.grey.shade200),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "300",
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          height: 1.0,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 2.0),
                                        child: Text(
                                          "Pks",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w500,
                                            height: 1.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "50KG GIVES",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // ── Waste Activity Card ────────────────────────────
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6F5EC),
                          borderRadius: BorderRadius.circular(18),
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
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    "Great job! You've received\n50kg this month!",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: const [
                                  _Bar(height: 12),
                                  SizedBox(width: 5),
                                  _Bar(height: 22),
                                  SizedBox(width: 5),
                                  _Bar(height: 36),
                                  SizedBox(width: 5),
                                  _Bar(height: 50),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        // ── Floating Book Now Button ───────────────────────────────────────
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Center(
            child: SizedBox(
              width: 200, // reduced width
              height: 54,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF00BCD4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF4CAF50).withValues(alpha: 0.5),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: widget.onBookNow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Book Now",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Green Header ─────────────────────────────────────────────────────────────

class _GreenHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4CAF50), Color(0xFF00BCD4), Color(0xFF2ECC71)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 36),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Avatar + Name + Progress
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('assets/icons/pic.png'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "SACHIN",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Progress bar
                      Container(
                        height: 5,
                        width: 90,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.7,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // SuchiGo Logo area
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: 26,
                              height: 26,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "SuchiGo",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "Schedule. Collect. Sustain",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Ad Banner ─────────────────────────────────────────────────────────────────

class _AdBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: const DecorationImage(
          image: AssetImage('assets/images/homesuchi2.png'),
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF4CAF50).withValues(alpha: 64),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background decorative circles
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            right: 30,
            bottom: -30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Text content
                // Expanded(
                // child: Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Container(
                //       padding: const EdgeInsets.symmetric(
                //         horizontal: 10,
                //         vertical: 4,
                //       ),
                //       decoration: BoxDecoration(
                //         color: Colors.white.withValues(alpha: 0.2),
                //         borderRadius: BorderRadius.circular(20),
                //       ),
                //       child: const Text(
                //         "Coming Soon",
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 11,
                //           fontWeight: FontWeight.w600,
                //         ),
                //       ),
                //     ),
                //     const SizedBox(height: 10),
                //     const Text(
                //       "Mark the Date\nSuchiGo...!\nis on the Way",
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 18,
                //         fontWeight: FontWeight.bold,
                //         height: 1.3,
                //       ),
                //     ),
                //     const SizedBox(height: 10),
                //     const Text(
                //       "Whatever the waste,\nwhenever the time\nSuchiGo arrives right\non schedule.",
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 11,
                //         height: 1.4,
                //       ),
                //     ),
                //   ],
                // ),
                // ),

                // Right side illustration placeholder
                // Container(
                //   width: 110,
                //   height: 160,
                //   decoration: BoxDecoration(
                //     color: Colors.white.withValues(alpha: 0.15),
                //     borderRadius: BorderRadius.circular(12),
                //   ),
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       // Truck icon
                //       Container(
                //         width: 60,
                //         height: 36,
                //         decoration: BoxDecoration(
                //           color: const Color(0xFFFFCC00),
                //           borderRadius: BorderRadius.circular(8),
                //         ),
                //         child: const Icon(
                //           Icons.local_shipping_rounded,
                //           color: Colors.white,
                //           size: 22,
                //         ),
                //       ),
                //       const SizedBox(height: 8),
                //       // Bins
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           _MiniBin(color: const Color(0xFF00BFAE)),
                //           const SizedBox(width: 4),
                //           _MiniBin(color: const Color(0xFFFF5252)),
                //           const SizedBox(width: 4),
                //           _MiniBin(color: const Color(0xFF64B5F6)),
                //         ],
                //       ),
                //       const SizedBox(height: 8),
                //       const Icon(
                //         Icons.recycling_rounded,
                //         color: Colors.white,
                //         size: 20,
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniBin extends StatelessWidget {
  final Color color;
  const _MiniBin({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 26,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Icon(
        Icons.delete_outline_rounded,
        color: Colors.white,
        size: 14,
      ),
    );
  }
}

// ── Waste Category Row ────────────────────────────────────────────────────────

class _WasteCategoryRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categories = [
      _WasteCategory(
        label: "Hazardous",
        imageAsset: "assets/images/haza.png",
        color: const Color(0xFFFF7043),
      ),
      _WasteCategory(
        label: "General",
        icon: Icons.delete_outline_rounded,
        color: const Color(0xFF78909C),
      ),
      _WasteCategory(
        label: "Recycle",
        icon: Icons.recycling_rounded,
        color: const Color(0xFF42A5F5),
      ),
      _WasteCategory(
        label: "Food Waste",
        icon: Icons.fastfood_rounded,
        color: const Color(0xFF66BB6A),
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categories
          .map(
            (cat) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: cat.imageAsset != null
                          ? Image.asset(cat.imageAsset!, width: 30, height: 30)
                          : Icon(cat.icon, size: 30, color: cat.color),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      cat.label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _WasteCategory {
  final String label;
  final IconData? icon;
  final String? imageAsset;
  final Color color;
  const _WasteCategory({
    required this.label,
    this.icon,
    this.imageAsset,
    required this.color,
  });
}

// ── Reusable Bar Widget ───────────────────────────────────────────────────────

class _Bar extends StatelessWidget {
  final double height;
  const _Bar({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: height,
      decoration: BoxDecoration(
        color: Color(0xFF4CAF50),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
