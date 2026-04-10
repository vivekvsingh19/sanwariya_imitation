import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_typography.dart';
import 'app_radius.dart';

// Re-export all design tokens so screens only need one import.
export 'app_colors.dart';
export 'app_typography.dart';
export 'app_spacing.dart';
export 'app_radius.dart';
export 'app_shadows.dart';

/// App-level [ThemeData] configuration, built from the centralized token files.
///
/// To change the entire app's look:
/// - Colors → [AppColors]
/// - Fonts & Sizes → [AppTypography]
/// - Spacing → [AppSpacing]
/// - Border Radii → [AppRadius]
/// - Shadows → [AppShadows]
class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      fontFamily: AppTypography.fontFamily,
      textTheme: GoogleFonts.interTextTheme(TextTheme(
        displayLarge: TextStyle(
          color: AppColors.primary,
          fontSize: AppTypography.fontSizeDisplay,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: AppColors.textWhite,
          fontSize: AppTypography.fontSizeXL,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: AppColors.textWhite,
          fontSize: AppTypography.fontSizeLG,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textWhite,
          fontSize: AppTypography.fontSizeBase,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textMuted,
          fontSize: AppTypography.fontSizeSM,
        ),
        labelLarge: TextStyle(
          color: AppColors.background,
          fontSize: AppTypography.fontSizeBase,
          fontWeight: FontWeight.bold,
        ),
      )),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.headingMedium(color: AppColors.primary),
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.background,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.mdBorder),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: AppTypography.bodyLarge(fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: AppRadius.mdBorder,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdBorder,
          borderSide: const BorderSide(color: AppColors.surface),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdBorder,
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        hintStyle: GoogleFonts.inter(color: AppColors.textMuted),
        labelStyle: GoogleFonts.inter(color: AppColors.primary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lgBorder),
        shadowColor: AppColors.black54,
      ),
    );
  }
}
