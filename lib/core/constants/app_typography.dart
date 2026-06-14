import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:suchigo_app/core/constants/app_colors.dart';

/// Typography scale for the SuchiGo design system.
///
/// Uses Poppins via [google_fonts] — the established brand font.
/// Scale follows the approved architecture (display → caption).
///
/// Usage:
/// ```dart
/// Text('Dashboard', style: AppTypography.headline);
/// Text('Pickup Date', style: AppTypography.label);
/// ```
abstract final class AppTypography {
  // ---------------------------------------------------------------------------
  // Scale
  // ---------------------------------------------------------------------------

  /// 28sp / Bold — hero text, screen titles.
  static TextStyle get display => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  /// 22sp / SemiBold — section headers, card titles.
  static TextStyle get headline => GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  /// 18sp / SemiBold — sub-section headers.
  static TextStyle get titleLarge => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  /// 16sp / Medium — prominent labels, navigation items.
  static TextStyle get titleMedium => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  /// 16sp / Regular — paragraph text, descriptions.
  static TextStyle get body => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  /// 14sp / Regular — secondary body text.
  static TextStyle get bodySmall => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.5,
      );

  /// 14sp / Medium — form labels, tab labels, button text.
  static TextStyle get label => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  /// 12sp / Regular — captions, timestamps, helper text.
  static TextStyle get caption => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  /// 16sp / Bold / White — button text on primary backgrounds.
  static TextStyle get button => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textOnPrimary,
        letterSpacing: 0.5,
        height: 1.4,
      );

  // ---------------------------------------------------------------------------
  // Theme Integration
  // ---------------------------------------------------------------------------

  /// Returns a [TextTheme] configured with Poppins for use in
  /// [ThemeData.textTheme]. Preserves Material Design semantic names.
  static TextTheme get textTheme => TextTheme(
        displayLarge: display,
        headlineMedium: headline,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        bodyLarge: body,
        bodyMedium: bodySmall,
        labelLarge: label,
        bodySmall: caption,
        labelMedium: button,
      );
}
