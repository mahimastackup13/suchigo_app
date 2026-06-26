import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suchigo_app/provider/bill_provider.dart';
import 'package:suchigo_app/Screens.dart/home_screen.dart';

class BillScreen extends StatefulWidget {
  const BillScreen({super.key});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  int _selectedTab = 0;

  final List<_WasteCategory> _residentialCategories = const [
    _WasteCategory(
      icon: Icons.baby_changing_station_outlined,
      title: 'SANITARY WASTE',
      subtitle: 'Diaper, Sanitary Pad,\nExpired Medicine, Hair Waste',
      value: 1,
      isDisable: false,
    ),
    _WasteCategory(
      icon: Icons.delete_outline_rounded,
      title: 'SOLID WASTE',
      subtitle: 'Paper, Plastic, Metals,\nE-Waste, Glass, Wood',
      value: 2,
    ),
    _WasteCategory(
      icon: Icons.eco_outlined,
      title: 'ORGANIC WASTE',
      subtitle: 'Food Scraps, Garden\nWaste, Compostables',
      value: 3,
    ),
    _WasteCategory(
      icon: Icons.devices_other_outlined,
      title: 'E-WASTE',
      subtitle: 'Electronics, Batteries,\nCables, Old Devices',
      value: 4,
    ),
  ];

  final List<_WasteCategory> _commercialCategories = const [
    _WasteCategory(
      icon: Icons.business_center_outlined,
      title: 'INDUSTRIAL WASTE',
      subtitle: 'Factory Scraps,\nMachinery Parts, Oil',
      value: 5,
    ),
    _WasteCategory(
      icon: Icons.local_shipping_outlined,
      title: 'BULK WASTE',
      subtitle: 'Large Volumes, Pallets,\nCommercial Packaging',
      value: 6,
    ),
    _WasteCategory(
      icon: Icons.science_outlined,
      title: 'CHEMICAL WASTE',
      subtitle: 'Hazardous Liquids,\nSafety Disposal Needed',
      value: 7,
    ),
    _WasteCategory(
      icon: Icons.construction_outlined,
      title: 'CONSTRUCTION WASTE',
      subtitle: 'Debris, Cement, Tiles,\nMetal Rods, Wood',
      value: 8,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final categories = _selectedTab == 0
        ? _residentialCategories
        : _commercialCategories;

    return Consumer<BillProvider>(
      builder: (context, billProvider, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            bottom: false, // We handle bottom padding in the button
            child: Column(
              children: [
                // ── Top Section (Illustration & Text) ──────────────────────────
                const SizedBox(height: 10),

                // Illustration (Scaled down slightly to save space)
                SizedBox(height: 150, child: _BinIllustration()),

                const SizedBox(height: 12),

                // Title
                const Text(
                  'WASTE DETAILS',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF4CAF50),
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 4),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'Help us understand what you\'re disposing of so we can come prepared.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      height: 1.4,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Bottom Section (Tabs, Grid, Button) ──────────────────────
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          // Tab Selector
                          Container(
                            height: 44, // Reduced height
                            decoration: BoxDecoration(
                              color: const Color(0xFFC8E6C9),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                _TabButton(
                                  label: 'Residential',
                                  selected: _selectedTab == 0,
                                  onTap: () => setState(() => _selectedTab = 0),
                                ),
                                _TabButton(
                                  label: 'Commercial',
                                  selected: _selectedTab == 1,
                                  onTap: () => setState(() => _selectedTab = 1),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // ── Responsive Waste Category Grid ──────────────────
                          // We use Expanded Rows/Columns so it perfectly fills the
                          // remaining screen height without scrolling!
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: _WasteCategoryCard(
                                          category: categories[0],
                                          isSelected:
                                              billProvider.selectedOption ==
                                              categories[0].value,
                                          onTap: () =>
                                              billProvider.setSelectedOption(
                                                categories[0].value,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: _WasteCategoryCard(
                                          category: categories[1],
                                          isSelected:
                                              billProvider.selectedOption ==
                                              categories[1].value,
                                          onTap: () =>
                                              billProvider.setSelectedOption(
                                                categories[1].value,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: _WasteCategoryCard(
                                          category: categories[2],
                                          isSelected:
                                              billProvider.selectedOption ==
                                              categories[2].value,
                                          onTap: () =>
                                              billProvider.setSelectedOption(
                                                categories[2].value,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: _WasteCategoryCard(
                                          category: categories[3],
                                          isSelected:
                                              billProvider.selectedOption ==
                                              categories[3].value,
                                          onTap: () =>
                                              billProvider.setSelectedOption(
                                                categories[3].value,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ── Continue Button ─────────────────────────────────
                          Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: Builder(
                              builder: (context) {
                                final enabled =
                                    billProvider.selectedOption != null;
                                return AnimatedOpacity(
                                  opacity: enabled ? 1.0 : 0.5,
                                  duration: const Duration(milliseconds: 250),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(
                                            0xFF4CAF50,
                                          ).withOpacity(0.35),
                                          blurRadius: 20,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: enabled
                                          ? () => billProvider.continueToPickup(
                                              context,
                                            )
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF4CAF50),
                                        disabledBackgroundColor: const Color(
                                          0xFF1A7A40,
                                        ).withOpacity(0.5),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        minimumSize: const Size(
                                          double.infinity,
                                          52,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Text(
                                            'Continue',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Bin Illustration ──────────────────────────────────────────────────────────

class _BinIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Soft green blob background
        Container(
          width: 180,
          height: 180,
          decoration: const BoxDecoration(
            color: Color(0xFFD6EFD8),
            shape: BoxShape.circle,
          ),
        ),

        // Bin body
        Positioned(
          bottom: 10,
          child: Column(
            children: [
              // Lid
              Container(
                width: 118,
                height: 14,
                decoration: BoxDecoration(
                  color: const Color(0xFF155C30),
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              // Body
              Container(
                width: 106,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(14),
                    bottomRight: Radius.circular(14),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.recycling_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Person head
        Positioned(
          right: 52,
          top: 24,
          child: Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: Color(0xFFE8A87C),
              shape: BoxShape.circle,
            ),
          ),
        ),

        // Person body
        Positioned(
          right: 53,
          top: 48,
          child: Container(
            width: 20,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE57373),
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        ),

        // Trash item
        Positioned(
          right: 80,
          top: 18,
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.delete_outline,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),

        // Left leaf
        Positioned(
          left: 30,
          bottom: 8,
          child: Transform.rotate(
            angle: -0.3,
            child: const Icon(
              Icons.eco_rounded,
              color: Color(0xFF2E7D32),
              size: 30,
            ),
          ),
        ),

        // Right leaf
        Positioned(
          right: 28,
          bottom: 8,
          child: Transform.rotate(
            angle: 0.3,
            child: const Icon(
              Icons.eco_rounded,
              color: Color(0xFF388E3C),
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Tab Button ────────────────────────────────────────────────────────────────

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
              color: selected ? Color(0xFF4CAF50) : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Waste Category Card ───────────────────────────────────────────────────────

class _WasteCategoryCard extends StatelessWidget {
  final _WasteCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const _WasteCategoryCard({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = category.isDisable;
    final bool isActiveSelected = isSelected && !isDisabled;

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: isDisabled
              ? const Color(0xFFF4F4F4)
              : isActiveSelected
              ? const Color(0xFF4CAF50)
              : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDisabled
                ? Colors.grey.shade300
                : isActiveSelected
                ? const Color(0xFF4CAF50)
                : Colors.grey.shade200,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isActiveSelected
                  ? const Color(0xFF4CAF50).withOpacity(0.25)
                  : Colors.black.withOpacity(isDisabled ? 0.02 : 0.05),
              blurRadius: isDisabled ? 6 : 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon circle
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: isDisabled
                        ? Colors.grey.shade300
                        : isActiveSelected
                        ? Colors.white.withValues(alpha: 0.2)
                        : const Color(0xFFF1F8F2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    category.icon,
                    size: 26,
                    color: isDisabled
                        ? Colors.grey.shade600
                        : isActiveSelected
                        ? Colors.white
                        : const Color(0xFF4CAF50),
                  ),
                ),

                const SizedBox(height: 10),

                // Title
                Flexible(
                  child: Text(
                    category.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                      color: isDisabled
                          ? Colors.grey.shade600
                          : isActiveSelected
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                // Subtitle
                Flexible(
                  child: Text(
                    category.subtitle,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      color: isDisabled
                          ? Colors.grey.shade500
                          : isActiveSelected
                          ? Colors.white.withValues(alpha: 0.8)
                          : Colors.grey.shade500,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
            if (isDisabled)
              Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  Icons.lock_outline,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Data Model ────────────────────────────────────────────────────────────────

class _WasteCategory {
  final IconData icon;
  final String title;
  final String subtitle;
  final int value;
  final bool isDisable;

  const _WasteCategory({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    this.isDisable = true,
  });
}
