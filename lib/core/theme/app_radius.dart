import 'package:flutter/material.dart';

/// Standardized border radius values for the Sanwariya Imitation app.
///
/// Use the pre-built [BorderRadius] objects for convenience, or the
/// raw [double] values when building custom shapes.
class AppRadius {
  AppRadius._();

  // ─── Raw Values ────────────────────────────────────────────────────
  static const double xs = 4.0;
  static const double sm = 6.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 16.0;
  static const double xxl = 20.0;
  static const double pill = 30.0;

  // ─── Pre-built BorderRadius Objects ────────────────────────────────
  static final BorderRadius xsBorder = BorderRadius.circular(xs);
  static final BorderRadius smBorder = BorderRadius.circular(sm);
  static final BorderRadius mdBorder = BorderRadius.circular(md);
  static final BorderRadius lgBorder = BorderRadius.circular(lg);
  static final BorderRadius xlBorder = BorderRadius.circular(xl);
  static final BorderRadius xxlBorder = BorderRadius.circular(xxl);
  static final BorderRadius pillBorder = BorderRadius.circular(pill);

  // ─── Directional Radius (for cards with rounded tops/bottoms) ──────
  static final BorderRadius topLg = BorderRadius.vertical(
    top: Radius.circular(lg),
  );
  static final BorderRadius topMd = BorderRadius.vertical(
    top: Radius.circular(md),
  );
  static final BorderRadius bottomLg = BorderRadius.vertical(
    bottom: Radius.circular(lg),
  );
}
