import 'package:flutter/material.dart';
import 'package:suchigo_app/Screens.dart/home_screen.dart';
import 'package:suchigo_app/Screens.dart/bill_screen.dart';
import 'package:suchigo_app/Screens.dart/settings_screen.dart';
import 'package:suchigo_app/Screens.dart/profile_screen.dart';
import 'package:suchigo_app/Screens.dart/login_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  static const _green = Color(0xFF1E713D);
  static const _headerGreen = Color(0xFF4CAF50);
  static const _bgGreen = Color(0xFFEFF9F1);

  int _currentNavIndex = 0;

  // Form controllers
  final _nameController = TextEditingController(text: 'Thariq R.');
  final _emailController = TextEditingController(text: 'thariq@email.com');
  final _phoneController = TextEditingController(text: '+91 98765 43210');
  final _altPhoneController = TextEditingController();
  final _addressController = TextEditingController(
    text: '42, Rose Garden Rd, Palarivattom',
  );
  final _cityController = TextEditingController(text: 'Ernakulam');
  final _pincodeController = TextEditingController(text: '682025');

  bool _editMode = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _altPhoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    if (index == _currentNavIndex) return;
    setState(() => _currentNavIndex = index);
    final destinations = [
      const HomeScreen(),
      const BillScreen(),
      const SettingsScreen(),
      const ProfileScreen(),
    ];
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => destinations[index]),
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
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Avatar section ───────────────────────
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: _green, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: _green.withValues(alpha: 0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const CircleAvatar(
                            radius: 44,
                            backgroundColor: Color(0xFFE8F5E9),
                            child: Text(
                              'T',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: _green,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: _green,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  Center(
                    child: Text(
                      _nameController.text,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      _emailController.text,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Stats row ─────────────────────────────
                  Row(
                    children: [
                      _StatCard(
                        icon: Icons.recycling_rounded,
                        value: '12',
                        label: 'Total\nPickups',
                      ),
                      const SizedBox(width: 12),
                      _StatCard(
                        icon: Icons.scale_rounded,
                        value: '84.5 kg',
                        label: 'Waste\nCollected',
                      ),
                      const SizedBox(width: 12),
                      _StatCard(
                        icon: Icons.eco_rounded,
                        value: '28',
                        label: 'Trees\nEquiv.',
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── Personal Info card ────────────────────
                  _SectionHeader(
                    title: 'Personal Information',
                    trailing: GestureDetector(
                      onTap: () => setState(() => _editMode = !_editMode),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _editMode ? _green : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _green),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _editMode
                                  ? Icons.check_rounded
                                  : Icons.edit_rounded,
                              size: 14,
                              color: _editMode ? Colors.white : _green,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _editMode ? 'Save' : 'Edit',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _editMode ? Colors.white : _green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  _InfoCard(
                    children: [
                      _AccountField(
                        icon: Icons.person_outline_rounded,
                        label: 'Full Name',
                        controller: _nameController,
                        editable: _editMode,
                      ),
                      _Divider(),
                      _AccountField(
                        icon: Icons.email_outlined,
                        label: 'Email Address',
                        controller: _emailController,
                        editable: _editMode,
                        keyboard: TextInputType.emailAddress,
                      ),
                      _Divider(),
                      _AccountField(
                        icon: Icons.phone_outlined,
                        label: 'Phone Number',
                        controller: _phoneController,
                        editable: _editMode,
                        keyboard: TextInputType.phone,
                      ),
                      _Divider(),
                      _AccountField(
                        icon: Icons.phone_callback_outlined,
                        label: 'Alt. Phone',
                        controller: _altPhoneController,
                        editable: _editMode,
                        keyboard: TextInputType.phone,
                        hint: 'Add alternate number',
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ── Address card ──────────────────────────
                  const _SectionHeader(title: 'Address Details'),
                  const SizedBox(height: 10),

                  _InfoCard(
                    children: [
                      _AccountField(
                        icon: Icons.home_outlined,
                        label: 'Address',
                        controller: _addressController,
                        editable: _editMode,
                        maxLines: 2,
                      ),
                      _Divider(),
                      _AccountField(
                        icon: Icons.location_city_outlined,
                        label: 'City',
                        controller: _cityController,
                        editable: _editMode,
                      ),
                      _Divider(),
                      _AccountField(
                        icon: Icons.pin_drop_outlined,
                        label: 'Pincode',
                        controller: _pincodeController,
                        editable: _editMode,
                        keyboard: TextInputType.number,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ── Account Actions ───────────────────────
                  const _SectionHeader(title: 'Account Actions'),
                  const SizedBox(height: 10),

                  _ActionTile(
                    icon: Icons.lock_outline_rounded,
                    label: 'Change Password',
                    color: const Color(0xFF1565C0),
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  _ActionTile(
                    icon: Icons.notifications_outlined,
                    label: 'Notification Preferences',
                    color: const Color(0xFFF57C00),
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  _ActionTile(
                    icon: Icons.delete_outline_rounded,
                    label: 'Delete Account',
                    color: const Color(0xFFC62828),
                    onTap: () => _showDeleteDialog(),
                  ),
                  const SizedBox(height: 8),
                  _ActionTile(
                    icon: Icons.logout_rounded,
                    label: 'Logout',
                    color: Colors.grey.shade600,
                    onTap: () => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Account',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC62828),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
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
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (route) => false,
                    ),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'My Account',
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
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Welcome back, T! 👋',
                      style: TextStyle(
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

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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

// ── Reusable Widgets ──────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF1E713D), size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade500,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  const _SectionHeader({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(children: children),
      ),
    );
  }
}

class _AccountField extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final bool editable;
  final TextInputType keyboard;
  final int maxLines;
  final String? hint;

  const _AccountField({
    required this.icon,
    required this.label,
    required this.controller,
    required this.editable,
    this.keyboard = TextInputType.text,
    this.maxLines = 1,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: maxLines > 1
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade400),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 2),
                editable
                    ? TextField(
                        controller: controller,
                        keyboardType: keyboard,
                        maxLines: maxLines,
                        style: const TextStyle(
                          fontSize: 13.5,
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          hintText: hint,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 13.5,
                          ),
                        ),
                      )
                    : Text(
                        controller.text.isEmpty
                            ? (hint ?? '—')
                            : controller.text,
                        style: TextStyle(
                          fontSize: 13.5,
                          color: controller.text.isEmpty
                              ? Colors.grey.shade400
                              : Colors.black87,
                          height: 1.4,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Divider(height: 1, color: Colors.grey.shade100);
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey.shade400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
