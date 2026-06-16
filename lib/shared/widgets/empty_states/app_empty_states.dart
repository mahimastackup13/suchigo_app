import 'package:flutter/material.dart';
import 'package:suchigo_app/core/constants/app_colors.dart';
import 'package:suchigo_app/core/constants/app_strings.dart';
import 'package:suchigo_app/core/constants/app_typography.dart';

/// Reusable empty state component.
///
/// Accepts any [icon], [title], [description], and an optional primary action.
/// All feature empty states should use this — no duplicate empty state widgets.
class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: AppTypography.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: AppTypography.bodySmall,
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 32),
              FilledButton(
                onPressed: onAction,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(180, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(actionLabel!, style: AppTypography.button),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Concrete Empty State Variants
// ---------------------------------------------------------------------------

class NoBillsEmptyState extends StatelessWidget {
  final VoidCallback? onCreateBill;
  const NoBillsEmptyState({super.key, this.onCreateBill});

  @override
  Widget build(BuildContext context) => AppEmptyState(
        icon: Icons.receipt_long_outlined,
        title: 'No Bills Yet',
        description: 'Your billing history will appear here once records are available.',
        actionLabel: onCreateBill != null ? 'Add Bill' : null,
        onAction: onCreateBill,
      );
}

class NoPickupsEmptyState extends StatelessWidget {
  final VoidCallback? onSchedule;
  const NoPickupsEmptyState({super.key, this.onSchedule});

  @override
  Widget build(BuildContext context) => AppEmptyState(
        icon: Icons.local_shipping_outlined,
        title: 'No Pickups Scheduled',
        description: 'Schedule a waste pickup and we\'ll come right to you.',
        actionLabel: onSchedule != null ? 'Schedule Pickup' : null,
        onAction: onSchedule,
      );
}

class NoAddressesEmptyState extends StatelessWidget {
  final VoidCallback? onAdd;
  const NoAddressesEmptyState({super.key, this.onAdd});

  @override
  Widget build(BuildContext context) => AppEmptyState(
        icon: Icons.location_on_outlined,
        title: 'No Addresses Saved',
        description: 'Add a pickup address so collectors know where to find you.',
        actionLabel: onAdd != null ? 'Add Address' : null,
        onAction: onAdd,
      );
}

class NoInternetEmptyState extends StatelessWidget {
  final VoidCallback? onRetry;
  const NoInternetEmptyState({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) => AppEmptyState(
        icon: Icons.wifi_off_outlined,
        title: 'You\'re Offline',
        description: AppStrings.errorNoInternet,
        actionLabel: onRetry != null ? AppStrings.retry : null,
        onAction: onRetry,
      );
}

class GenericErrorEmptyState extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;
  const GenericErrorEmptyState({super.key, this.message, this.onRetry});

  @override
  Widget build(BuildContext context) => AppEmptyState(
        icon: Icons.error_outline,
        title: 'Something Went Wrong',
        description: message ?? AppStrings.errorUnknown,
        actionLabel: onRetry != null ? AppStrings.retry : null,
        onAction: onRetry,
      );
}
