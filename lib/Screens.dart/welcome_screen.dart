import 'package:flutter/material.dart';
import 'package:suchigo_app/Screens.dart/register_screen.dart';
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
                        'assets/images/logo.png', 
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

              
              Center(
                child: Image.asset(
                  'assets/images/Tree.png',
                  width: MediaQuery.of(
                    context,
                  ).size.width, 
                  height:
                      MediaQuery.of(context).size.height *
                      0.45, 
                  fit: BoxFit.cover, 
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

              
              SizedBox(
                width: double.infinity,
                height: 60,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE2F2DF), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(), 
                      ),
                    );
                    
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

              
              Center(
                child: GestureDetector(
                  onTap: () {
                     Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
  );
                    
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
