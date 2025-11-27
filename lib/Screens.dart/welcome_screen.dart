import 'package:flutter/material.dart';
import 'package:suchigo_app/Screens.dart/signin_screen.dart';
import 'package:suchigo_app/Screens.dart/login_screen.dart';
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Logo + Skip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/logo.png', // <-- replace with your logo asset
                        height: 80,
                      ),
                      const SizedBox(width: 8),
                    
                    ],
                  ),
                  const Text(
                    "Skip",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Main Illustration
              //
              Center(
                child: Image.asset(
                  'assets/images/Tree.png',
                  width: MediaQuery.of(
                    context,
                  ).size.width, // fills screen width
                  height:
                      MediaQuery.of(context).size.height *
                      0.45, // 45% of screen height
                  fit: BoxFit.cover, // makes it fill space nicely
                ),
              ),

              const SizedBox(height: 20),

              // Title Text
              const Text(
                "Planting Green,\nGrowing Life",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 10),

              // Subtitle Text
              const Text(
                "Your investment is susceptible greater\nvulnerability from external influences",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
              ),

              const Spacer(),

              // Get Started Button
              SizedBox(
                width: double.infinity,
                height: 60,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE2F2DF), // light green
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignInScreen(), // replace with your next screen
                      ),
                    );
                    // Navigate to next screen
                  },
                  child: const Text(
                    "Get started",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Already have an account
              Center(
                child: GestureDetector(
                  onTap: () {
                     Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
  );
                    // Navigate to login
                  },
                  child: const Text(
                    "Already have an account",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
