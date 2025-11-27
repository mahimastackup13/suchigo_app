import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suchigo_app/Screens.dart/AddOrder_Screen.dart';
import 'package:suchigo_app/Screens.dart/collector_screen.dart';

// Your Screens
import 'package:suchigo_app/Screens.dart/login_screen.dart';
import 'package:suchigo_app/Screens.dart/register_screen.dart';
import 'package:suchigo_app/Screens.dart/spalsh_screen.dart';

// Providers
import 'package:suchigo_app/provider/register_provider.dart';
import 'package:suchigo_app/provider/waste_provider.dart';
import 'package:suchigo_app/provider/location_provider.dart';



void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        // ChangeNotifierProvider(create: (_) => WasteProvider()),
      ],
      child: const SuchiGoApp(),
    ),
  );
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
      home: const LoginScreen(),
      routes: {
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginScreen(),
        '/collector': (context) => const CollectorScreen(),
      
      },
    );
  }
}
