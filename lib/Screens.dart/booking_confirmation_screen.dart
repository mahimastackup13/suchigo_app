import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:suchigo_app/Screens.dart/home_screen.dart';
import 'package:suchigo_app/Screens.dart/bill_screen.dart';
import 'package:suchigo_app/Screens.dart/settings_screen.dart';
import 'package:suchigo_app/Screens.dart/profile_screen.dart';

// ─────────────────────────────────────────────
//  DATA MODEL
// ─────────────────────────────────────────────
class BookingDetails {
  final String bookingId;
  final String wasteType;
  final String collectionDate;
  final String collectionTime;
  final String address;
  final String city;
  final String pincode;
  final String contactName;
  final String contactPhone;
  final String status;
  final double estimatedWeight;
  final String specialInstructions;

  const BookingDetails({
    required this.bookingId,
    required this.wasteType,
    required this.collectionDate,
    required this.collectionTime,
    required this.address,
    required this.city,
    required this.pincode,
    required this.contactName,
    required this.contactPhone,
    this.status = 'Confirmed',
    this.estimatedWeight = 0,
    this.specialInstructions = '',
  });
}

// ─────────────────────────────────────────────
//  BOOKING CONFIRMATION SCREEN
// ─────────────────────────────────────────────
class BookingConfirmationScreen extends StatefulWidget {
  final BookingDetails bookingDetails;

  const BookingConfirmationScreen({super.key, required this.bookingDetails});

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen>
    with TickerProviderStateMixin {
  late AnimationController _checkController;
  late AnimationController _cardController;
  late Animation<double> _checkScale;
  late Animation<double> _checkOpacity;
  late Animation<Offset> _cardSlide;
  late Animation<double> _cardFade;

  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();

    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _checkScale = CurvedAnimation(
      parent: _checkController,
      curve: Curves.elasticOut,
    );
    _checkOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _checkController, curve: const Interval(0, 0.4)),
    );
    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _cardController, curve: Curves.easeOut));
    _cardFade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _cardController, curve: Curves.easeIn));

    _checkController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _cardController.forward();
    });
  }

  @override
  void dispose() {
    _checkController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  // ── Theme colours ──────────────────────────
  static const _green = Color(0xFF2E7D32);
  static const _greenLight = Color(0xFF4CAF50);
  static const _greenSurface = Color(0xFFE8F5E9);
  static const _greenBorder = Color(0xFFC8E6C9);
  static const _textDark = Color(0xFF1B2A1C);
  static const _textMid = Color(0xFF4A6350);
  static const _textLight = Color(0xFF7A9480);
  static const _white = Colors.white;

  // ── Bottom nav tap handler ─────────────────
  void _onNavTap(int index) {
    if (index == _currentNavIndex) return;
    setState(() => _currentNavIndex = index);

    Widget destination;
    switch (index) {
      case 0:
        destination = const HomeScreen();
        break;
      case 1:
        destination = const BillScreen();
        break;
      case 2:
        destination = const SettingsScreen();
        break;
      case 3:
        destination = const ProfileScreen();
        break;
      default:
        destination = const HomeScreen();
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => destination),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.bookingDetails;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: _greenSurface,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  child: FadeTransition(
                    opacity: _cardFade,
                    child: SlideTransition(
                      position: _cardSlide,
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          _buildSuccessBadge(b),
                          const SizedBox(height: 16),
                          _buildDetailCard(b),
                          const SizedBox(height: 14),
                          _buildAddressCard(b),
                          if (b.specialInstructions.isNotEmpty) ...[
                            const SizedBox(height: 14),
                            _buildInstructionsCard(b),
                          ],
                          const SizedBox(height: 14),
                          _buildEnvironmentImpactCard(b),
                          const SizedBox(height: 24),
                          _buildActions(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  // ── Top header ─────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        color: _green,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Booking Confirmed',
                  style: TextStyle(
                    color: _white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              ScaleTransition(
                scale: _checkScale,
                child: FadeTransition(
                  opacity: _checkOpacity,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: _white,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Your waste collection has been scheduled.',
            style: TextStyle(color: Color(0xFFB9DFB9), fontSize: 13),
          ),
        ],
      ),
    );
  }

  // ── Booking ID + status badge ───────────────
  Widget _buildSuccessBadge(BookingDetails b) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _greenBorder),
        boxShadow: [
          BoxShadow(
            color: _green.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Booking ID',
                style: TextStyle(
                  fontSize: 11,
                  color: _textLight,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                b.bookingId,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: _textDark,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: _greenSurface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _greenBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: _greenLight,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  b.status,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Collection detail card ──────────────────
  Widget _buildDetailCard(BookingDetails b) {
    return _SectionCard(
      title: 'Collection Details',
      icon: Icons.recycling_rounded,
      children: [
        _DetailRow(
          icon: Icons.delete_outline_rounded,
          label: 'Waste Type',
          value: b.wasteType,
          highlight: true,
        ),
        _RowDivider(),
        _DetailRow(
          icon: Icons.calendar_today_rounded,
          label: 'Collection Date',
          value: b.collectionDate,
        ),
        _RowDivider(),
        _DetailRow(
          icon: Icons.access_time_rounded,
          label: 'Time Slot',
          value: b.collectionTime,
        ),
        if (b.estimatedWeight > 0) ...[
          _RowDivider(),
          _DetailRow(
            icon: Icons.scale_rounded,
            label: 'Est. Weight',
            value: '${b.estimatedWeight.toStringAsFixed(1)} kg',
          ),
        ],
      ],
    );
  }

  // ── Address card ────────────────────────────
  Widget _buildAddressCard(BookingDetails b) {
    return _SectionCard(
      title: 'Pickup Address',
      icon: Icons.location_on_rounded,
      children: [
        _DetailRow(
          icon: Icons.person_outline_rounded,
          label: 'Contact',
          value: b.contactName,
        ),
        _RowDivider(),
        _DetailRow(
          icon: Icons.phone_outlined,
          label: 'Phone',
          value: b.contactPhone,
        ),
        _RowDivider(),
        _DetailRow(
          icon: Icons.home_outlined,
          label: 'Address',
          value: '${b.address},\n${b.city} – ${b.pincode}',
          multiLine: true,
        ),
      ],
    );
  }

  // ── Special instructions card ───────────────
  Widget _buildInstructionsCard(BookingDetails b) {
    return _SectionCard(
      title: 'Special Instructions',
      icon: Icons.info_outline_rounded,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            b.specialInstructions,
            style: const TextStyle(
              fontSize: 13.5,
              color: _textMid,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  // ── Environmental impact ────────────────────
  Widget _buildEnvironmentImpactCard(BookingDetails b) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF388E3C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _green.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.eco_rounded, color: Colors.white70, size: 18),
              SizedBox(width: 8),
              Text(
                'Your Environmental Impact',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Row(
            children: [
              _ImpactTile(icon: '🌱', label: 'CO₂ Saved', value: '2.4 kg'),
              _ImpactTile(icon: '♻️', label: 'Recycled', value: '85%'),
              _ImpactTile(icon: '🌍', label: 'Trees Equiv.', value: '0.3'),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Thank you for contributing to a greener planet! 🌿',
            style: TextStyle(color: Color(0xFFB9DFB9), fontSize: 11.5),
          ),
        ],
      ),
    );
  }

  // ── Action buttons ──────────────────────────
  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            ),
            icon: const Icon(Icons.home_rounded, size: 20),
            label: const Text(
              'Back to Home',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _green,
              foregroundColor: _white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: Track booking logic
            },
            icon: const Icon(Icons.my_location_rounded, size: 18),
            label: const Text(
              'Track My Booking',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: _green,
              side: const BorderSide(color: _greenBorder, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Bottom nav ──────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: _white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _green,
        unselectedItemColor: _textLight,
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

// ─────────────────────────────────────────────
//  REUSABLE WIDGETS
// ─────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC8E6C9)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D32).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: const Color(0xFF2E7D32), size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1B2A1C),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE8F5E9)),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool highlight;
  final bool multiLine;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.highlight = false,
    this.multiLine = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: multiLine
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF7A9480)),
          const SizedBox(width: 10),
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12.5, color: Color(0xFF7A9480)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
                color: highlight
                    ? const Color(0xFF2E7D32)
                    : const Color(0xFF1B2A1C),
                height: 1.4,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, color: Color(0xFFF1F8F1));
  }
}

class _ImpactTile extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _ImpactTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 10.5),
          ),
        ],
      ),
    );
  }
}
