import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Reusable box shadow presets for consistent depth and elevation.
class AppShadows {
  AppShadows._();

  /// Subtle shadow for slightly raised elements.
  static const BoxShadow subtle = BoxShadow(
    color: Colors.black26,
    blurRadius: 10,
    offset: Offset(0, 4),
  );

  /// Standard card shadow for product cards and containers.
  static const BoxShadow card = BoxShadow(
    color: Colors.black45,
    blurRadius: 14,
    offset: Offset(0, 8),
  );

  /// Elevated shadow for floating elements and dialogs.
  static BoxShadow elevated = BoxShadow(
    color: Colors.black.withValues(alpha: 0.3),
    blurRadius: 20,
    offset: const Offset(0, 10),
  );

  /// Soft shadow for address cards and payment options.
  static BoxShadow soft = BoxShadow(
    color: Colors.black.withValues(alpha: 0.1),
    blurRadius: 20,
    offset: const Offset(0, 10),
  );

  /// Gold glow shadow for primary CTA buttons.
  static BoxShadow primaryGlow = BoxShadow(
    color: AppColors.primary.withValues(alpha: 0.3),
    blurRadius: 10,
    offset: const Offset(0, 4),
  );
}
