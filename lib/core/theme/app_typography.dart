import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Centralized typography system for the Sanwariya Imitation app.
///
/// Change [fontFamily] or [brandFontFamily] to retheme the entire app's fonts.
/// All text styles are semantically named for easy discovery and consistency.
class AppTypography {
  AppTypography._();

  // ─── Font Families ─────────────────────────────────────────────────
  /// Primary font family used across the entire app.
  /// Change this single getter to update all body/UI text.
  static String? get fontFamily => GoogleFonts.inter().fontFamily;

  /// Brand font family used for the "SANWARIYA IMITATION" logo text.
  /// Change this single getter to update the brand identity font.
  static String? get brandFontFamily => GoogleFonts.cinzel().fontFamily;

  // ─── Font Sizes ────────────────────────────────────────────────────
  /// Standardized font size scale. Use these instead of raw numbers.
  static const double fontSizeHero = 48.0;
  static const double fontSizeDisplayXL = 46.0;
  static const double fontSizeDisplayLarge = 36.0;
  static const double fontSizeDisplayMedium = 34.0;
  static const double fontSizeDisplay = 32.0;
  static const double fontSizeDisplaySmall = 28.0;
  static const double fontSizeXXL = 26.0;
  static const double fontSizeXL = 24.0;
  static const double fontSizeLG = 20.0;
  static const double fontSizeMD = 18.0;
  static const double fontSizeBase = 16.0;
  static const double fontSizeSM = 14.0;
  static const double fontSizeXS = 12.0;
  static const double fontSizeXXS = 11.0;
  static const double fontSizeTiny = 10.0;
  static const double fontSizeMicro = 9.0;
  static const double fontSizeNano = 8.0;

  // ─── Letter Spacing ────────────────────────────────────────────────
  static const double letterSpacingTight = 0.5;
  static const double letterSpacingNormal = 1.0;
  static const double letterSpacingWide = 1.5;
  static const double letterSpacingXWide = 2.0;
  static const double letterSpacingXXWide = 3.0;
  static const double letterSpacingUltra = 4.0;

  // ─── Display Styles (Hero/Section Titles) ──────────────────────────
  /// 48px — Hero banner title ("The Wedding Edit").
  static TextStyle displayHero({Color color = AppColors.textWhite}) =>
      GoogleFonts.inter(color: color, fontSize: fontSizeHero, height: 1.1);

  /// 46px — Shop collection main title ("The Necklaces").
  static TextStyle displayXL({Color color = AppColors.textWhite}) =>
      GoogleFonts.inter(color: color, fontSize: fontSizeDisplayXL);

  /// 36px — Login welcome title.
  static TextStyle displayLarge({
    Color color = AppColors.primary,
    FontWeight fontWeight = FontWeight.bold,
  }) =>
      GoogleFonts.inter(
        color: color,
        fontSize: fontSizeDisplayLarge,
        fontWeight: fontWeight,
        height: 1.2,
      );

  /// 34px — Product detail main title.
  static TextStyle displayMedium({Color color = AppColors.textWhite}) =>
      GoogleFonts.inter(color: color, fontSize: fontSizeDisplayMedium, height: 1.2);

  /// 32px — Section headers ("Royal Treasures", "My Orders").
  static TextStyle display({
    Color color = AppColors.textWhite,
    FontWeight fontWeight = FontWeight.w600,
    FontStyle fontStyle = FontStyle.normal,
  }) =>
      GoogleFonts.inter(
        color: color,
        fontSize: fontSizeDisplay,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        height: 1.1,
      );

  /// 28px — Feature section titles ("Featured Masterpieces", user name).
  static TextStyle displaySmall({Color color = AppColors.textWhite}) =>
      GoogleFonts.inter(color: color, fontSize: fontSizeDisplaySmall, height: 1.1);

  // ─── Heading Styles ────────────────────────────────────────────────
  /// 26px — Product detail pricing.
  static TextStyle headingXL({Color color = AppColors.primary}) =>
      GoogleFonts.inter(color: color, fontSize: fontSizeXXL);

  /// 24px — Cart summary, checkout header, total prices.
  static TextStyle headingLarge({
    Color color = AppColors.textWhite,
    FontWeight fontWeight = FontWeight.normal,
  }) =>
      GoogleFonts.inter(
        color: color,
        fontSize: fontSizeXL,
        fontWeight: fontWeight,
      );

  /// 20px — Order card title, app bar title, checkout quantity.
  static TextStyle headingMedium({
    Color color = AppColors.textWhite,
    FontWeight fontWeight = FontWeight.bold,
  }) =>
      GoogleFonts.inter(
        color: color,
        fontSize: fontSizeLG,
        fontWeight: fontWeight,
      );

  /// 18px — Address name, accordion title, product detail section.
  static TextStyle headingSmall({
    Color color = AppColors.textWhite,
    FontWeight fontWeight = FontWeight.w600,
  }) =>
      GoogleFonts.inter(
        color: color,
        fontSize: fontSizeMD,
        fontWeight: fontWeight,
      );

  // ─── Body Styles ──────────────────────────────────────────────────
  /// 16px — Primary body text, product title, CTA text.
  static TextStyle bodyLarge({
    Color color = AppColors.textWhite,
    FontWeight fontWeight = FontWeight.normal,
  }) =>
      GoogleFonts.inter(
        color: color,
        fontSize: fontSizeBase,
        fontWeight: fontWeight,
      );

  /// 14px — Secondary body text, descriptions, amounts.
  static TextStyle bodyMedium({
    Color color = AppColors.textMuted,
    FontWeight fontWeight = FontWeight.normal,
    double? height,
  }) =>
      GoogleFonts.inter(
        color: color,
        fontSize: fontSizeSM,
        fontWeight: fontWeight,
        height: height,
      );

  /// 12px — Subtitles, chip text, descriptions, hero descriptions.
  static TextStyle bodySmall({
    Color color = AppColors.textWhite,
    FontWeight fontWeight = FontWeight.normal,
    double? letterSpacing,
    double? height,
  }) =>
      GoogleFonts.inter(
        color: color,
        fontSize: fontSizeXS,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        height: height,
      );

  // ─── Label / Caption Styles ────────────────────────────────────────
  /// 11px — Status text, small button labels, in-stock text.
  static TextStyle labelLarge({
    Color color = AppColors.textWhite,
    FontWeight fontWeight = FontWeight.w600,
    double? letterSpacing,
  }) =>
      GoogleFonts.inter(
        color: color,
        fontSize: fontSizeXXS,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
      );

  /// 10px — Tags, letter-spaced labels, badge text, tab labels.
  static TextStyle labelMedium({
    Color color = AppColors.textMuted,
    FontWeight fontWeight = FontWeight.w600,
    double letterSpacing = letterSpacingWide,
  }) =>
      GoogleFonts.inter(
        color: color,
        fontSize: fontSizeTiny,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
      );

  /// 9px — Tiny badges, product metadata, "VIEW ALL", fine print.
  static TextStyle labelSmall({
    Color color = AppColors.textWhite,
    FontWeight fontWeight = FontWeight.bold,
    double letterSpacing = letterSpacingWide,
  }) =>
      GoogleFonts.inter(
        color: color,
        fontSize: fontSizeMicro,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
      );

  /// 8px — Cart badge count, feature card tiny text.
  static TextStyle caption({
    Color color = AppColors.textWhite,
    FontWeight fontWeight = FontWeight.bold,
  }) =>
      GoogleFonts.inter(
        color: color,
        fontSize: fontSizeNano,
        fontWeight: fontWeight,
      );

  // ─── Brand Styles ─────────────────────────────────────────────────
  /// Cinzel brand title for "SANWARIYA IMITATION" logo header.
  static TextStyle brandTitle({
    double fontSize = fontSizeBase,
    double letterSpacing = letterSpacingXWide,
    FontWeight fontWeight = FontWeight.bold,
    Color color = AppColors.primary,
  }) =>
      GoogleFonts.cinzel(
        color: color,
        fontSize: fontSize,
        letterSpacing: letterSpacing,
        fontWeight: fontWeight,
      );

  /// Brand subtitle for the "IMITATION" portion when displayed separately.
  static TextStyle brandSubtitle({
    double fontSize = fontSizeBase,
    double letterSpacing = letterSpacingXWide,
    Color color = AppColors.primary,
  }) =>
      GoogleFonts.cinzel(
        color: color,
        fontSize: fontSize,
        letterSpacing: letterSpacing,
      );
}
