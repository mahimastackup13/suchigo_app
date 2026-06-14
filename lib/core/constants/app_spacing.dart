/// Consistent spacing scale for the SuchiGo design system.
///
/// Uses a 4-point base grid. Every margin, padding, and gap in the app
/// should reference this scale instead of using arbitrary pixel values.
///
/// Usage:
/// ```dart
/// Padding(
///   padding: EdgeInsets.all(AppSpacing.md),
///   child: ...,
/// )
/// SizedBox(height: AppSpacing.sm)
/// ```
abstract final class AppSpacing {
  /// 4dp — micro spacing for tight icon gaps.
  static const double xs = 4;

  /// 8dp — small spacing for related element groups.
  static const double sm = 8;

  /// 12dp — between small/medium for fine-tuning.
  static const double smd = 12;

  /// 16dp — default spacing for padding and margins.
  static const double md = 16;

  /// 20dp — between medium/large for section breathing room.
  static const double mlg = 20;

  /// 24dp — large spacing for section separators.
  static const double lg = 24;

  /// 32dp — extra-large for major section breaks.
  static const double xl = 32;

  /// 48dp — jumbo spacing for page-level breathing room.
  static const double xxl = 48;

  // ---------------------------------------------------------------------------
  // Semantic Aliases
  // ---------------------------------------------------------------------------

  /// Standard horizontal page padding (16dp).
  static const double pagePaddingH = md;

  /// Standard vertical page padding (24dp).
  static const double pagePaddingV = lg;

  /// Gap between cards in a list (12dp).
  static const double cardGap = smd;

  /// Internal card padding (18dp — matches existing card padding).
  static const double cardPadding = 18;

  /// Border radius for standard cards (18dp — matches existing cards).
  static const double cardRadius = 18;

  /// Border radius for buttons (16dp — matches existing CTA).
  static const double buttonRadius = 16;

  /// Border radius for input fields (14dp — matches search bar).
  static const double inputRadius = 14;

  /// Minimum touch target size (48dp — Material accessibility standard).
  static const double minTouchTarget = 48;
}
