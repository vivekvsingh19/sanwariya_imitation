import 'package:flutter/material.dart';

/// Standardized spacing scale based on a 4px grid system.
///
/// Use these constants instead of raw numbers for consistent spacing.
class AppSpacing {
  AppSpacing._();

  // ─── Base Scale (4px grid) ─────────────────────────────────────────
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double huge = 40.0;
  static const double massive = 48.0;
  static const double giant = 64.0;
  static const double colossal = 80.0;

  // ─── Semantic Constants ────────────────────────────────────────────
  /// Horizontal padding for full-width screen content.
  static const double screenPaddingH = 24.0;

  /// Vertical padding typically used at the top of screen content.
  static const double screenPaddingV = 16.0;

  /// Standard inner padding for cards and containers.
  static const double cardPadding = 16.0;

  /// Generous padding for larger cards (summary, address).
  static const double cardPaddingLarge = 24.0;

  /// Gap between major sections on a screen.
  static const double sectionGap = 32.0;

  /// Gap between related items within a section.
  static const double itemGap = 16.0;

  /// Gap between tightly coupled elements (e.g., label and input).
  static const double elementGap = 8.0;

  // ─── Convenience EdgeInsets ────────────────────────────────────────
  /// Standard horizontal screen padding.
  static const EdgeInsets screenH = EdgeInsets.symmetric(horizontal: screenPaddingH);

  /// Standard screen padding (horizontal + vertical).
  static const EdgeInsets screen = EdgeInsets.symmetric(
    horizontal: screenPaddingH,
    vertical: screenPaddingV,
  );

  /// Standard card padding.
  static const EdgeInsets card = EdgeInsets.all(cardPadding);

  /// Large card padding.
  static const EdgeInsets cardLarge = EdgeInsets.all(cardPaddingLarge);
}
