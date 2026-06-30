import 'package:flutter/material.dart';

class PrivacyAndSecurity extends StatefulWidget {
  const PrivacyAndSecurity({super.key});

  @override
  State<PrivacyAndSecurity> createState() => _PrivacyAndSecurityState();
}

class _PrivacyAndSecurityState extends State<PrivacyAndSecurity> {
  static const Color _primaryGreen = Color(0xFF1E713D);
  static const Color _backgroundGrey = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundGrey,
      appBar: AppBar(
        title: const Text(
          "Privacy & Security",
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Security status card
            _buildStatusCard(),
            const SizedBox(height: 20),

            const Text(
              "Privacy Policies & Info",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),

            // Policy Accordions
            _buildPolicyCard(
              icon: Icons.shield_rounded,
              title: "Data Protection & Encryption",
              content:
                  "SuchiGo takes your data security seriously. All personal information, billing details, and collection logs are encrypted in transit using SSL/TLS and at rest using AES-256 standard encryption. Your data is strictly secured in compliance with global data privacy guidelines.",
            ),
            _buildPolicyCard(
              icon: Icons.location_on_rounded,
              title: "Location Data Usage",
              content:
                  "We collect and process your geographical location data solely to facilitate optimized waste pickup routing, connect you to local waste collectors, and track your active collection requests in real-time. Your location is never shared with third parties for marketing purposes.",
            ),
            _buildPolicyCard(
              icon: Icons.person_search_rounded,
              title: "Personal Information Sharing",
              content:
                  "To facilitate smooth waste processing, your basic details (Name, Contact Number, Pickup Address) are shared only with the designated collection agent assigned to your request. We do not sell or lease your personal information to third-party advertisers.",
            ),
            _buildPolicyCard(
              icon: Icons.delete_forever_rounded,
              title: "Account & Data Deletion",
              content:
                  "You hold the right to delete your SuchiGo account and erase your historical records at any time. Under settings, you can submit a Request Account Deletion, which permanently purges your personal profile, credentials, and address list from our active databases within 14 business days.",
            ),

            const SizedBox(height: 30),

            // Security Tips Card
            _buildSecurityTipsCard(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_primaryGreen, Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _primaryGreen.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your connection is secure",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "App version 1.0.0 is secured with industry-grade security protocols.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
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

  Widget _buildPolicyCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      color: Colors.white,
      child: ExpansionTile(
        leading: Icon(icon, color: _primaryGreen),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        iconColor: _primaryGreen,
        collapsedIconColor: Colors.grey,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedAlignment: Alignment.topLeft,
        children: [
          Text(
            content,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityTipsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                color: Colors.amber.shade800,
              ),
              const SizedBox(width: 8),
              Text(
                "Security Tips",
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTipRow(
            "Never share your verification OTP with anyone, including SuchiGo agents.",
          ),
          _buildTipRow(
            "Ensure your mobile device has a screen lock enabled for data protection.",
          ),
          _buildTipRow(
            "Verify the identity of the collector at your doorstep using the track map.",
          ),
        ],
      ),
    );
  }

  Widget _buildTipRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "•",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.amber.shade800,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.5,
                color: Colors.amber.shade900,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
