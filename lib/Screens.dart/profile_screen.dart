import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suchigo_app/Screens.dart/home_screen.dart';
import 'package:suchigo_app/provider/profile_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // --- Header Background Container ---
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
                            // Home Button (Navigation works as requested)
                            // Positioned(
                            //   top: 16,
                            //   left: 8,
                            //   child: IconButton(
                            //     icon: const Icon(Icons.home_rounded),
                            //     color: Colors.white,
                            //     iconSize: 28,
                            //     tooltip: 'Home',
                            //     onPressed: () {
                            //       // Navigates to HomeScreen
                            //       Navigator.pushReplacement(
                            //         context,
                            //         MaterialPageRoute(
                            //           builder: (context) => const HomeScreen(),
                            //         ),
                            //       );
                            //     },
                            //   ),
                            // ),

                            // Decorative Circles (Kept as is)
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

                            // User Profile Info (Uses Provider)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundImage: AssetImage(
                                    profileProvider
                                        .profileImagePath, // <-- From Provider
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  profileProvider.username, // <-- From Provider
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  profileProvider
                                      .phoneNumber, // <-- From Provider
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // --- Profile Items Container ---
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
      },
    );
  }
}

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
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded, // Added trailing icon for better UI
        color: Colors.grey,
        size: 16,
      ),
      contentPadding: EdgeInsets.zero,
      dense: true,
      horizontalTitleGap: 10,
      onTap: () {
        Provider.of<ProfileProvider>(
          context,
          listen: false,
        ).handleProfileItemTap(context, text);
      },
    );
  }
}
