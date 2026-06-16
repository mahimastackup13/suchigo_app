import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:suchigo_app/core/constants/app_colors.dart';
import 'package:suchigo_app/core/constants/app_strings.dart';
import 'package:suchigo_app/core/constants/app_typography.dart';
import 'package:suchigo_app/features/auth/presentation/providers/auth_notifier.dart';
import 'package:suchigo_app/features/auth/presentation/states/auth_state.dart';
import 'package:suchigo_app/routing/app_routes.dart';

/// Session-restoring splash screen.
///
/// On mount, triggers [AuthNotifier.restoreSession]. The GoRouter redirect
/// rule reacts to auth state changes and navigates automatically — this screen
/// only needs to kick off restoration and display the brand animation.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  bool _sessionRestored = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    // Kick off session restoration after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).restoreSession();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // React to auth state — GoRouter redirect handles navigation
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (!_sessionRestored &&
          (next is AuthAuthenticated || next is AuthUnauthenticated)) {
        _sessionRestored = true;
        // GoRouter redirect logic handles the actual navigation
      }
    });

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 220,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.eco,
                    size: 100,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  AppStrings.appName,
                  style: AppTypography.display.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.appTagline,
                  style: AppTypography.bodySmall.copyWith(
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 48),
                const SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
