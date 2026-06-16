import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suchigo_app/core/utils/app_logger.dart';
import 'package:suchigo_app/features/auth/presentation/providers/auth_notifier.dart';
import 'package:suchigo_app/features/auth/presentation/states/auth_state.dart';
import 'package:suchigo_app/features/home/presentation/providers/home_notifier.dart';
import 'package:suchigo_app/features/profile/presentation/providers/profile_notifier.dart';

/// Observes the app's [AppLifecycleState] and refreshes critical data on resume.
///
/// Attach this as a [WidgetsBindingObserver] in the root widget. On resume:
/// 1. Validates the auth token is still present.
/// 2. Refreshes home data to pick up server-side changes.
/// 3. Refreshes profile data.
///
/// This protects against stale data after extended backgrounding and against
/// tokens that expired while the app was in the background.
class AppLifecycleObserver extends WidgetsBindingObserver {
  final WidgetRef ref;

  AppLifecycleObserver(this.ref);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      AppLogger.info('App resumed — refreshing critical data');
      _onResume();
    }
  }

  Future<void> _onResume() async {
    final authState = ref.read(authProvider);

    if (authState is! AuthAuthenticated) {
      AppLogger.debug('App resumed but not authenticated — skipping refresh');
      return;
    }

    // Validate session is still alive by re-reading the token
    await ref.read(authProvider.notifier).restoreSession();

    // Refresh time-sensitive data quietly
    if (ref.read(authProvider) is AuthAuthenticated) {
      ref.read(homeProvider.notifier).loadHome();
      ref.read(profileProvider.notifier).loadProfile();
    }
  }
}
