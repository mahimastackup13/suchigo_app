import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:suchigo_app/Screens.dart/AddOrder_Screen.dart';
import 'package:suchigo_app/Screens.dart/collector_screen.dart';
import 'package:suchigo_app/Screens.dart/home_screen.dart';
import 'package:suchigo_app/Screens.dart/login_screen.dart';
import 'package:suchigo_app/Screens.dart/register_screen.dart';
import 'package:suchigo_app/Screens.dart/signin_screen.dart';
import 'package:suchigo_app/Screens.dart/spalsh_screen.dart';
import 'package:suchigo_app/Screens.dart/welcome_screen.dart';

import 'package:suchigo_app/provider/AddressProvider.dart';
import 'package:suchigo_app/provider/CollectorProvider.dart';
import 'package:suchigo_app/provider/address_details_provider.dart';
import 'package:suchigo_app/provider/bill_provider.dart';
import 'package:suchigo_app/provider/home_provider.dart';
import 'package:suchigo_app/provider/pickup_provider.dart';
import 'package:suchigo_app/provider/profile_provider.dart';
import 'package:suchigo_app/provider/location_provider.dart';
import 'package:suchigo_app/provider/settings_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e, stack) {
    debugPrint("Firebase initialization failed: $e");
    debugPrint("$stack");
  }

  runApp(
    ProviderScope(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HomeProvider()),
          ChangeNotifierProvider(create: (_) => ProfileProvider()),
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
          ChangeNotifierProvider(create: (_) => LocationProvider()),
          ChangeNotifierProvider(create: (_) => BillProvider()),
          ChangeNotifierProvider(create: (_) => PickupProvider()),
          ChangeNotifierProvider(create: (_) => CollectorProvider()),
          ChangeNotifierProvider(create: (_) => AddressProvider()),
          ChangeNotifierProvider(create: (_) => AddressDetailsProvider()),
        ],
        child: const SuchiGoApp(),
      ),
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
      home: const WelcomeScreen(),
      routes: {
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginScreen(),
        '/collector': (context) => const CollectorScreen(),
        '/home': (context) => const HomeScreen(),
        // '/welcome': (context) => const WelcomeScreen(),
      },
    );
  }
}