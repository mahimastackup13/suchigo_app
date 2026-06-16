import 'package:flutter/material.dart';
import 'package:suchigo_app/core/constants/app_colors.dart';
import 'package:suchigo_app/core/constants/app_strings.dart';
import 'package:suchigo_app/core/constants/app_typography.dart';
import 'package:suchigo_app/core/errors/app_error.dart';

/// Centralised error-to-UI mapper.
///
/// Maps [AppError] subclasses to user-friendly snackbars and dialogs.
/// All error display in the app MUST route through this class.
/// Never show raw exception messages to the user.
abstract final class GlobalErrorHandler {
  /// Shows a [SnackBar] with an appropriate message for [error].
  /// Includes a retry action when [onRetry] is provided.
  static void showSnackBar(
    BuildContext context,
    AppError error, {
    VoidCallback? onRetry,
  }) {
    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    final isDestructive =
        error is ServerError || error is UnknownError || error is ParseError;

    messenger.showSnackBar(
      SnackBar(
        content: Text(error.userMessage, style: AppTypography.bodySmall.copyWith(color: Colors.white)),
        backgroundColor: isDestructive ? AppColors.error : AppColors.warning,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 4),
        action: onRetry != null
            ? SnackBarAction(
                label: AppStrings.retry,
                textColor: Colors.white,
                onPressed: onRetry,
              )
            : null,
      ),
    );
  }

  /// Shows a dismissible dialog for critical errors (e.g., session expired).
  static Future<void> showDialog(
    BuildContext context,
    AppError error, {
    VoidCallback? onAction,
    String? actionLabel,
  }) async {
    if (!context.mounted) return;
    await showAdaptiveDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(_errorTitle(error), style: AppTypography.titleLarge),
        content: Text(error.userMessage, style: AppTypography.bodySmall),
        actions: [
          if (onAction != null)
            FilledButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                onAction();
              },
              style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary),
              child: Text(
                  actionLabel ?? AppStrings.retry,
                  style: AppTypography.button),
            ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Dismiss'),
          ),
        ],
      ),
    );
  }

  static String _errorTitle(AppError error) {
    return switch (error) {
      NoInternetError() => 'No Connection',
      TimeoutError() => 'Request Timeout',
      ServerError() => 'Server Error',
      InvalidCredentialsError() || TokenExpiredError() || TokenNotFoundError() =>
        'Session Expired',
      ParseError() => 'Data Error',
      DbReadError() || DbWriteError() => 'Storage Error',
      _ => 'Something Went Wrong',
    };
  }
}
