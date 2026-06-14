import 'package:flutter/material.dart';

/// Design tokens for the SuchiGo colour palette.
///
/// Extracted from the existing codebase (Color(0xFF1E713D) in providers,
/// Color(0xFF4CAF50) in screens) and formalised as a single source of truth.
///
/// No hardcoded Color() values should appear anywhere outside this class.
abstract final class AppColors {
  // ---------------------------------------------------------------------------
  // Brand
  // ---------------------------------------------------------------------------

  /// Primary brand green — forest green from the original theme.
  static const Color primary = Color(0xFF1E713D);

  /// Lighter primary for backgrounds, cards, and success-state containers.
  static const Color primaryLight = Color(0xFFD4EDDA);

  /// The vibrant green used in gradients and CTAs (existing in home_screen).
  static const Color primaryVibrant = Color(0xFF4CAF50);

  /// Teal accent used in gradient endpoints (existing in home_screen).
  static const Color accent = Color(0xFF00BCD4);

  /// Secondary green for the eco branding.
  static const Color secondary = Color(0xFF2ECC71);

  // ---------------------------------------------------------------------------
  // Surfaces & Backgrounds
  // ---------------------------------------------------------------------------

  /// Pure white surface for cards and dialogs.
  static const Color surface = Color(0xFFFFFFFF);

  /// Slightly tinted background (off-white with green warmth).
  static const Color background = Color(0xFFF5F7F5);

  /// Scaffold background matching the existing F5F5F5 usage.
  static const Color scaffoldBackground = Color(0xFFF5F5F5);

  // ---------------------------------------------------------------------------
  // Text
  // ---------------------------------------------------------------------------

  /// Primary text colour for headings and body text.
  static const Color textPrimary = Color(0xFF1A1A1A);

  /// Secondary text for captions, labels, and hints.
  static const Color textSecondary = Color(0xFF6B6B6B);

  /// Text on primary-coloured backgrounds.
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ---------------------------------------------------------------------------
  // Semantic
  // ---------------------------------------------------------------------------

  /// Error/destructive actions.
  static const Color error = Color(0xFFD32F2F);

  /// Light error background for error banners.
  static const Color errorLight = Color(0xFFFFEBEE);

  /// Success state.
  static const Color success = Color(0xFF4CAF50);

  /// Warning state.
  static const Color warning = Color(0xFFFFA726);

  /// Informational state.
  static const Color info = Color(0xFF42A5F5);

  // ---------------------------------------------------------------------------
  // Waste Category (from home_screen.dart)
  // ---------------------------------------------------------------------------

  /// Hazardous waste icon background.
  static const Color wasteHazardous = Color(0xFFFF7043);

  /// General waste icon background.
  static const Color wasteGeneral = Color(0xFF78909C);

  /// Recyclable waste icon background.
  static const Color wasteRecyclable = Color(0xFF42A5F5);

  /// Food waste icon background.
  static const Color wasteFoodWaste = Color(0xFF66BB6A);

  // ---------------------------------------------------------------------------
  // Neutral
  // ---------------------------------------------------------------------------

  /// Dividers, borders, and subtle separators.
  static const Color divider = Color(0xFFE0E0E0);

  /// Disabled state for buttons and fields.
  static const Color disabled = Color(0xFFBDBDBD);

  /// Card shadow colour (from home_screen BoxShadow).
  static const Color shadow = Color(0x14000000);

  // ---------------------------------------------------------------------------
  // Gradient Presets
  // ---------------------------------------------------------------------------

  /// Primary CTA gradient (Book Now button).
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryVibrant, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Header gradient (Green Header in home_screen).
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryVibrant, accent, secondary],
  );
}
