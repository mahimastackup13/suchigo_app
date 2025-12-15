//
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:suchigo_app/Screens.dart/login_screen.dart';
import 'otp_screen.dart';
// import 'package:suchigo_app/Screens.dart/home_screen.dart'; // Removed as navigation is handled in AuthProvider
// import 'package:suchigo_app/Screens.dart/register_screen.dart'; // Removed unused import
// import 'package:firebase_auth/firebase_auth.dart'; // Removed as logic is in AuthProvider
// import 'package:firebase_core/firebase_core.dart'; // Removed as logic is in main.dart
import 'package:suchigo_app/provider/auth_provider.dart'; // Import your AuthProvider

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _phoneController = TextEditingController();

  // Set the country code (e.g., for India)
  final String _countryCode = "+91";

  void _validateAndProceed() async {
    String number = _phoneController.text.trim();

    if (number.isEmpty || number.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid 10-digit phone number")),
      );
      return;
    }

    // ⭐ Call the AuthProvider to handle Firebase logic
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Call the function that handles sending the OTP via Firebase
    await authProvider.signInWithPhoneNumber(context, number, _countryCode);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFEAF7EA),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Top Image (Code remains the same)
                SizedBox(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 40),
                      child: Image.asset(
                        'assets/images/signin.png',
                        width: double.infinity,
                        height: h * 0.35,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Main Card Container
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(
                    vertical: 60,
                    horizontal: 30,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Enter your number to continue',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Phone Number Input
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: InputDecoration(
                          counterText: "",
                          hintText: 'Enter your number here',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold,
                          ),
                          // Use prefixText so the country code stays inline with the input
                          prefixText: '$_countryCode ',
                          prefixStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                          suffixIcon: const Icon(
                            Icons.person_outlined,
                            size: 30,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 18.0,
                            horizontal: 16.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Sign In Button
                      SizedBox(
                        width: 250,
                        height: 60,
                        child: ElevatedButton(
                          onPressed:
                              _validateAndProceed, // Call the updated method
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF545454),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(36),
                            ),
                            elevation: 6,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Text(
                                'Sign in',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: Icon(
                                    Icons.arrow_circle_right_outlined,
                                    size: 32,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Already Have Account Text
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Already have an account?',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
