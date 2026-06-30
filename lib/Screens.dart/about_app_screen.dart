import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  static const Color _primaryGreen = Color(0xFF1E713D);
  static const Color _backgroundGrey = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundGrey,
      appBar: AppBar(
        title: const Text(
          "About App",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: _primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),

            // App Logo
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Image.asset(
                'assets/icons/suchigologo.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),

            // App Name & Version
            const Text(
              "SuchiGo",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: _primaryGreen,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Version 1.0.0 (Build 7)",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 32),

            // App Mission Card
            _buildInfoCard(
              title: "Our Mission",
              icon: Icons.eco_rounded,
              child: const Text(
                "SuchiGo is a smart waste management platform built with the mission to automate, optimize, and digitize rubbish collection. We aim to help citizens schedule pickups effortlessly, support local sanitation workers, and measure our collective impact in building a greener, more sustainable world.",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),

            // Key Highlights Card
            _buildInfoCard(
              title: "Key Highlights",
              icon: Icons.star_rounded,
              child: Column(
                children: [
                  _buildHighlightRow(
                    icon: Icons.calendar_today_rounded,
                    title: "Flexible Scheduling",
                    desc:
                        "Book pickups for residential or commercial waste on your time.",
                  ),
                  const Divider(
                    color: Color(0xFFF1F5F2),
                    thickness: 1,
                    height: 16,
                  ),
                  _buildHighlightRow(
                    icon: Icons.bar_chart_rounded,
                    title: "Impact Metrics",
                    desc:
                        "Track carbon reduction, trees saved, and recycling ratios live.",
                  ),
                  const Divider(
                    color: Color(0xFFF1F5F2),
                    thickness: 1,
                    height: 16,
                  ),
                  _buildHighlightRow(
                    icon: Icons.security_rounded,
                    title: "Safe Verification",
                    desc:
                        "Full verification profiles of door-to-door sanitation agents.",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Copyright Info
            Text(
              "© 2026 SuchiGo Inc.",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "All Rights Reserved.",
              style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: _primaryGreen, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(color: Color(0xFFF1F5F2), thickness: 1),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildHighlightRow({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _primaryGreen.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: _primaryGreen, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
