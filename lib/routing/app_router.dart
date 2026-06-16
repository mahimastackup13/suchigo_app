import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:suchigo_app/Screens.dart/home_screen.dart';
import 'package:suchigo_app/Screens.dart/login_screen.dart';
import 'package:suchigo_app/Screens.dart/profile_screen.dart';
import 'package:suchigo_app/Screens.dart/register_screen.dart';
import 'package:suchigo_app/Screens.dart/settings_screen.dart';
import 'package:suchigo_app/Screens.dart/spalsh_screen.dart';
import 'package:suchigo_app/Screens.dart/bill_screen.dart';
import 'package:suchigo_app/Screens.dart/address_screen.dart';
import 'package:suchigo_app/Screens.dart/welcome_screen.dart';
import 'package:suchigo_app/features/auth/presentation/providers/auth_notifier.dart';
import 'package:suchigo_app/features/auth/presentation/states/auth_state.dart';
import 'package:suchigo_app/routing/app_routes.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    redirect: (context, routerState) {
      final location = routerState.uri.path;

      // Still resolving session — stay on splash
      if (authState is AuthInitial || authState is AuthLoading) {
        if (location != AppRoutes.splash) return AppRoutes.splash;
        return null;
      }

      final isAuthenticated = authState is AuthAuthenticated;

      // Public routes that don't need auth
      final isPublic = location == AppRoutes.login ||
          location == AppRoutes.register ||
          location == AppRoutes.welcome ||
          location == AppRoutes.splash;

      if (!isAuthenticated && !isPublic) {
        return AppRoutes.login;
      }

      if (isAuthenticated && isPublic) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.bills,
        builder: (context, state) => const BillScreen(),
      ),
      GoRoute(
        path: AppRoutes.pickups,
        builder: (context, state) => const _PickupsPlaceholderScreen(),
      ),
      GoRoute(
        path: AppRoutes.addresses,
        builder: (context, state) => const AddressScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => _RouterErrorScreen(error: state.error),
  );
}

/// Placeholder shown for the Pickups route until the screen is fully implemented.
class _PickupsPlaceholderScreen extends StatelessWidget {
  const _PickupsPlaceholderScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pickups')),
      body: const Center(
        child: Text(
          'Pickups coming soon.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

/// Fallback displayed when an unknown route is accessed.
class _RouterErrorScreen extends StatelessWidget {
  final Exception? error;

  const _RouterErrorScreen({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Page not found', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
