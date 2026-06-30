import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suchigo_app/provider/home_provider.dart';
import 'package:suchigo_app/provider/profile_provider.dart';
import 'package:suchigo_app/Screens.dart/home_screen.dart';
import 'package:suchigo_app/Screens.dart/bill_screen.dart';
import 'package:suchigo_app/Screens.dart/settings_screen.dart';
import 'package:suchigo_app/Screens.dart/profile_screen.dart';

// ── Data Model ────────────────────────────────────────────────────────────────
class OrderHistory {
  final String orderId;
  final String wasteType;
  final String date;
  final String timeSlot;
  final String address;
  final double weight;
  final String status;
  final Color statusColor;
  final IconData statusIcon;

  const OrderHistory({
    required this.orderId,
    required this.wasteType,
    required this.date,
    required this.timeSlot,
    required this.address,
    required this.weight,
    required this.status,
    required this.statusColor,
    required this.statusIcon,
  });
}

// ── Screen ────────────────────────────────────────────────────────────────────
class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  static const _green = Color(0xFF1E713D);
  static const _headerGreen = Color(0xFF4CAF50);
  static const _bgGreen = Color(0xFFEFF9F1);

  int _currentNavIndex = 3;
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Completed', 'Pending', 'Cancelled'];

  final List<OrderHistory> _orders = const [
    OrderHistory(
      orderId: 'WC-2026-08741',
      wasteType: 'Sanitary Waste',
      date: '22 Apr 2026',
      timeSlot: '09:00 AM – 12:00 PM',
      address: '42, Rose Garden Rd, Palarivattom',
      weight: 12.5,
      status: 'Completed',
      statusColor: Color(0xFF2E7D32),
      statusIcon: Icons.check_circle_rounded,
    ),
    OrderHistory(
      orderId: 'WC-2026-07892',
      wasteType: 'Solid Waste',
      date: '15 Apr 2026',
      timeSlot: '01:00 PM – 04:00 PM',
      address: '12, MG Road, Kochi',
      weight: 8.0,
      status: 'Completed',
      statusColor: Color(0xFF2E7D32),
      statusIcon: Icons.check_circle_rounded,
    ),
    OrderHistory(
      orderId: 'WC-2026-09120',
      wasteType: 'E-Waste',
      date: '28 Apr 2026',
      timeSlot: '09:00 AM – 12:00 PM',
      address: '7, Hill View Colony, Thrissur',
      weight: 5.2,
      status: 'Pending',
      statusColor: Color(0xFFF57C00),
      statusIcon: Icons.hourglass_top_rounded,
    ),
    OrderHistory(
      orderId: 'WC-2026-06543',
      wasteType: 'Organic Waste',
      date: '10 Apr 2026',
      timeSlot: '10:00 AM – 01:00 PM',
      address: '3, Nehru Nagar, Kollam',
      weight: 20.0,
      status: 'Cancelled',
      statusColor: Color(0xFFC62828),
      statusIcon: Icons.cancel_rounded,
    ),
    OrderHistory(
      orderId: 'WC-2026-05210',
      wasteType: 'Bulk Waste',
      date: '02 Apr 2026',
      timeSlot: '08:00 AM – 11:00 AM',
      address: '88, Park Street, Ernakulam',
      weight: 35.0,
      status: 'Completed',
      statusColor: Color(0xFF2E7D32),
      statusIcon: Icons.check_circle_rounded,
    ),
  ];

  List<OrderHistory> get _filteredOrders => _selectedFilter == 'All'
      ? _orders
      : _orders.where((o) => o.status == _selectedFilter).toList();

  void _onNavTap(int index) {
    Provider.of<HomeProvider>(context, listen: false).setSelectedIndex(index);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgGreen,
      body: Column(
        children: [
          _buildHeader(),
          // ── Filter chips ─────────────────────────────────
          Container(
            color: _bgGreen,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((f) {
                  final selected = _selectedFilter == f;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: selected ? _green : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected ? _green : Colors.grey.shade300,
                        ),
                        boxShadow: selected
                            ? [
                                BoxShadow(
                                  color: _green.withOpacity(0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : [],
                      ),
                      child: Text(
                        f,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: selected ? Colors.white : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ── Order list ───────────────────────────────────
          Expanded(
            child: _filteredOrders.isEmpty
                ? _buildEmpty()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _filteredOrders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) =>
                        _OrderCard(order: _filteredOrders[i]),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: _headerGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            children: [
              // Top bar
              Row(
                children: [
                  _headerIconBtn(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        Provider.of<HomeProvider>(
                          context,
                          listen: false,
                        ).setSelectedIndex(3);
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                          (route) => false,
                        );
                      }
                    },
                  ),
                  const Expanded(
                    child: Text(
                      'Order History',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
              const SizedBox(height: 14),
              // Welcome card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Welcome back, ${Provider.of<ProfileProvider>(context).username}! 👋',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage your waste collection and track your\nenvironmental impact',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_rounded, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No orders found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Schedule a pickup to see your orders here.',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  Widget _headerIconBtn({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.25),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _green,
        unselectedItemColor: Colors.grey.shade500,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        backgroundColor: Colors.transparent,
        elevation: 0,
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Bill',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ── Order Card ────────────────────────────────────────────────────────────────
class _OrderCard extends StatelessWidget {
  final OrderHistory order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Card header ──────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FFF8),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.recycling_rounded,
                    color: Color(0xFF1E713D),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.wasteType,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        order.orderId,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: order.statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        order.statusIcon,
                        color: order.statusColor,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        order.status,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: order.statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Card body ────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _InfoRow(icon: Icons.calendar_today_rounded, text: order.date),
                const SizedBox(height: 8),
                _InfoRow(icon: Icons.access_time_rounded, text: order.timeSlot),
                const SizedBox(height: 8),
                _InfoRow(icon: Icons.location_on_outlined, text: order.address),
                const SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.scale_rounded,
                  text: '${order.weight.toStringAsFixed(1)} kg',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: Colors.grey.shade400),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700),
          ),
        ),
      ],
    );
  }
}
