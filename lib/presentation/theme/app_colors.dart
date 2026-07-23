import 'package:flutter/material.dart';

/// Design tokens — colours for the "Anges de Poulpes" design system.
///
/// Palette rules:
/// - A single warm accent ([coral]). No other orange/red/yellow outside of
///   [sizeClassColors] and [waterTempColor].
/// - Screen backgrounds always use [offWhite], never pure white.
abstract final class AppColors {
  // Signature
  static const Color cobalt = Color(0xFF1E47B9);
  static const Color abyss = Color(0xFF0A1E5C);
  static const Color coral = Color(0xFFFF6B4A);
  static const Color coralLight = Color(0xFFFF9E85);

  // Backgrounds & surfaces
  static const Color offWhite = Color(0xFFF8F6F1);
  static const Color surface = Color(0xFFFFFFFF);

  // Blue tints
  static const Color blueTint100 = Color(0xFFE7EDFB);
  static const Color blueTint200 = Color(0xFFDCE5F8);
  static const Color blueTint300 = Color(0xFFCFDBF6);
  static const Color blueMuted = Color(0xFF8FA5E8);
  static const Color textMuted = Color(0xFF5A6EA8);

  static const Color border = Color(0xFFE0E4F0);

  // Dive metaphor
  static const Color diveMid1 = Color(0xFF16388F);
  static const Color diveMid2 = Color(0xFF102C7A);
  static const Color sheetDark = Color(0xFF0E2670);

  /// Cross-cutting size-class palette (fist, grapefruit, ball, watermelon).
  /// Used on map markers, charts, observation cards, illustrations.
  static const List<Color> sizeClassColors = <Color>[
    Color(0xFFF2B8A0), // fist — skin pink
    Color(0xFFFF9E4F), // grapefruit — orange
    Color(0xFFFFD34D), // ball — yellow
    Color(0xFF4CA85A), // watermelon — green
  ];

  // Dark-surface tokens (bottom sheets, overlays over dive gradient)
  static const Color darkSurfaceFill = Color(0x12FFFFFF); // white .07
  static const Color darkSurfaceFillActive = Color(0x4CFF6B4A); // coral .30
  static const Color darkSurfaceBorder = Color(0x33FFFFFF); // white .20
  static const Color darkSurfaceChip = Color(0x1FFFFFFF); // white .12

  /// Colour code for water temperature (°C).
  ///
  /// Ranges (per spec):
  /// - `< 14`      : deep cold blue
  /// - `14 – 17`   : mid blue
  /// - `18 – 21`   : teal
  /// - `22 – 25`   : green
  /// - `> 25`      : warm orange
  static Color waterTempColor(num celsius) {
    if (celsius < 14) return const Color(0xFF3E7BD6);
    if (celsius < 18) return const Color(0xFF2E9BC6);
    if (celsius < 22) return const Color(0xFF19A8A0);
    if (celsius < 26) return const Color(0xFF3FA75C);
    return const Color(0xFFE2703A);
  }
}
