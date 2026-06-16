import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suchigo_app/core/constants/app_colors.dart';
import 'package:suchigo_app/core/constants/app_strings.dart';
import 'package:suchigo_app/core/constants/app_typography.dart';
import 'package:suchigo_app/core/network/connectivity_service.dart';

/// Animated banner shown at the top of the app when the device is offline.
///
/// Wrap any screen's body with [OfflineAwarePage] to get offline detection
/// without coupling each screen to the connectivity provider.
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityAsync = ref.watch(connectivityStreamProvider);

    return connectivityAsync.when(
      data: (isConnected) {
        if (isConnected) return const SizedBox.shrink();
        return _buildBanner();
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildBanner() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: AppColors.warning.withAlpha(230),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.wifi_off, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              AppStrings.offlineBanner,
              style: AppTypography.caption.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

/// Wraps a page [child] with an [OfflineBanner] at the top.
///
/// Usage in any screen's build:
/// ```dart
/// return OfflineAwarePage(child: _buildContent());
/// ```
class OfflineAwarePage extends StatelessWidget {
  final Widget child;

  const OfflineAwarePage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const OfflineBanner(),
        Expanded(child: child),
      ],
    );
  }
}

/// Riverpod provider exposing a stream of connectivity state.
final connectivityStreamProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.connectivityStream;
});

/// Provider for the [ConnectivityService] singleton.
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});
