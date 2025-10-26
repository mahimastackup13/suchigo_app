import 'package:flutter/material.dart';
import 'package:suchigo_app/Screens.dart/otp_screen.dart';
import 'Screens.dart/Spalsh_screen.dart';
import 'Screens.dart/welcome_screen.dart';
import 'Screens.dart/signin_screen.dart';
import 'Screens.dart/otp_screen.dart';
import 'Screens.dart/register_screen.dart';
void main() {
  runApp(const SuchiGoApp());
}

class SuchiGoApp extends StatelessWidget {
  const SuchiGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      title: 'SuchiGo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
      ),
      home: const RegisterScreen(), // Starting with OTP Screen for testing
    );
  }
}
