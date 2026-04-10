import 'package:flutter/material.dart';

/// Centralized color palette for the Sanwariya Imitation app.
///
/// Change any color here and it will update across the entire app.
/// Colors are organized by semantic purpose for easy discovery.
class AppColors {
  AppColors._(); // Prevent instantiation

  // ─── Brand / Primary ────────────────────────────────────────────────
  /// Main gold color used for primary accents, icons, and highlights.
  static const Color primary = Color(0xFFD4AF37);

  /// Lighter gold used for secondary accents and hover states.
  static const Color secondary = Color(0xFFE5C058);

  /// Warm gold for CTA buttons (Place Order, Track Journey, etc.)
  static const Color primaryWarm = Color(0xFFD4A347);

  /// Muted gold for subtle accents ("VIEW ALL" links, etc.)
  static const Color primaryMuted = Color(0xFFC0A054);

  /// Light gold for badges and highlights.
  static const Color primaryLight = Color(0xFFE2C26C);

  /// Bright gold for selected/active radio indicators.
  static const Color primaryBright = Color(0xFFF2D368);

  /// Dark gold for badge backgrounds on product tiles.
  static const Color badgeGold = Color(0xFFB89A42);

  // ─── Backgrounds ────────────────────────────────────────────────────
  /// App-wide deep black background.
  static const Color background = Color(0xFF0D0D0D);

  /// Near-black used for bottom nav bar and brand bar containers.
  static const Color backgroundDark = Color(0xFF0B0B0B);

  /// Bottom sheet / action bar background.
  static const Color backgroundBottomSheet = Color(0xFF0F0E0D);

  // ─── Surfaces (Cards, Containers) ──────────────────────────────────
  /// Standard card / surface color.
  static const Color surface = Color(0xFF1A1A1A);

  /// Darker surface used for product cards, feature cards.
  static const Color surfaceDark = Color(0xFF141414);

  /// Dark surface for quantity pills, summary sections.
  static const Color surfaceDeep = Color(0xFF151515);

  /// Lighter surface for primary content cards (orders, profile options).
  static const Color surfaceLight = Color(0xFF1E1E1E);

  /// Warm dark surface for checkout cards, payment options, address cards.
  static const Color surfaceWarm = Color(0xFF201F1F);

  /// Very dark surface for order tracking product card.
  static const Color surfaceElevated = Color(0xFF161616);

  /// Warm-toned dark surface for limited edition gradient start.
  static const Color surfaceGoldDark = Color(0xFF1E1C16);

  /// Golden-tinted dark surface for active filter chips.
  static const Color surfaceGoldAccent = Color(0xFF262117);

  /// Dark reddish-brown for order tracking image placeholder.
  static const Color surfaceAccent = Color(0xFF2A0612);

  /// Soft dark highlight for login radial gradient.
  static const Color surfaceHighlight = Color(0xFF2A2A2A);

  /// Active bottom nav item background tint.
  static const Color surfaceNavActive = Color(0xFF35301E);

  /// Dark gold-tint for product detail badge background (22K GOLD).
  static const Color surfaceBadge = Color(0xFF231F17);

  // ─── Borders & Dividers ────────────────────────────────────────────
  /// Subtle border for cards and containers.
  static const Color borderSubtle = Color(0xFF222222);

  /// Muted border for filter chips, action buttons.
  static const Color borderMuted = Color(0xFF2D2D2D);

  /// Bottom nav bar top border.
  static const Color borderNav = Color(0xFF1F1F1F);

  /// Gold-tinted border for limited edition section.
  static const Color borderGold = Color(0xFF3B3524);

  /// Gold-tinted border for active filter chips.
  static const Color borderGoldAccent = Color(0xFF53462B);

  /// Divider color used in product detail accordion.
  static const Color divider = Color(0xFF1E1E1E);

  // ─── Text Colors ──────────────────────────────────────────────────
  /// Pure white for primary text on dark backgrounds.
  static const Color textWhite = Color(0xFFFFFFFF);

  /// Muted grey for secondary labels and descriptions.
  static const Color textMuted = Color(0xFFA0A0A0);

  /// Subtle grey for order tracking IDs, metadata.
  static const Color textSubtle = Color(0xFF666666);

  /// Dim grey for strikethrough prices, tax labels.
  static const Color textDim = Color(0xFF6B6B6B);

  /// Feature card subtitle grey.
  static const Color textHint = Color(0xFF888888);

  /// Badge/metadata grey ("IN STOCK" label on product detail).
  static const Color textCaption = Color(0xFF909090);

  // ─── Semantic Colors ──────────────────────────────────────────────
  /// Success green for "IN STOCK" indicators.
  static const Color success = Color(0xFF00C26E);

  /// Error red for form errors, snackbars.
  static const Color error = Color(0xFFCF6679);

  // ─── Opacity Helpers ──────────────────────────────────────────────
  /// Use these for consistent opacity levels throughout the app.
  static Color white70 = Colors.white70;
  static Color white54 = Colors.white54;
  static Color white38 = Colors.white38;
  static Color white30 = Colors.white30;
  static Color white24 = Colors.white24;
  static Color white12 = Colors.white12;
  static Color white10 = Colors.white10;
  static Color black87 = Colors.black87;
  static Color black54 = Colors.black54;
  static Color black45 = Colors.black45;
  static Color black26 = Colors.black26;
}
