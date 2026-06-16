import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:suchigo_app/core/constants/app_colors.dart';
import 'package:suchigo_app/core/constants/app_typography.dart';
import 'package:suchigo_app/core/storage/local_db.dart';
import 'package:suchigo_app/core/utils/app_logger.dart';
import 'package:suchigo_app/routing/app_router.dart';
import 'package:suchigo_app/shared/widgets/app_lifecycle_observer.dart';
import 'package:suchigo_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialisation
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e, stack) {
    AppLogger.error('Firebase initialization failed', error: e, stackTrace: stack);
  }

  // Pre-warm local SQLite database
  try {
    final db = LocalDb();
    await db.open();
    AppLogger.info('LocalDb initialised');
  } catch (e, stack) {
    AppLogger.error('LocalDb init failed', error: e, stackTrace: stack);
  }

  runApp(const ProviderScope(child: SuchiGoApp()));
}

class SuchiGoApp extends ConsumerStatefulWidget {
  const SuchiGoApp({super.key});

  @override
  ConsumerState<SuchiGoApp> createState() => _SuchiGoAppState();
}

class _SuchiGoAppState extends ConsumerState<SuchiGoApp> {
  late AppLifecycleObserver _lifecycleObserver;

  @override
  void initState() {
    super.initState();
    _lifecycleObserver = AppLifecycleObserver(ref);
    WidgetsBinding.instance.addObserver(_lifecycleObserver);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_lifecycleObserver);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'SuchiGo',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          surface: AppColors.surface,
        ),
        scaffoldBackgroundColor: AppColors.scaffoldBackground,
        textTheme: AppTypography.textTheme,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.primary, width: 2),
          ),
          filled: true,
          fillColor: AppColors.surface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),

      // Router
      routerConfig: router,
    );
  }
}