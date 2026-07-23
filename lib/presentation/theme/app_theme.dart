import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// Composes [ThemeData] instances from the design tokens.
///
/// Only tokens that map naturally to Material (`ColorScheme`, `TextTheme`)
/// are exposed through `Theme.of(context)`. Custom tokens (spacing, radii,
/// shadows, gradients, size-class palette) are read directly from their
/// static classes:
///
/// - `AppSpacing.l`
/// - `AppRadius.card`
/// - `AppShadows.card`
/// - `AppGradients.dive`
/// - `AppColors.sizeClassColors`
///
/// This keeps components fully typed and self-documenting without a runtime
/// hook layer.
abstract final class AppTheme {
  static ThemeData get light => _base(_lightScheme);

  static ThemeData get dark => _base(_darkScheme);

  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.cobalt,
    onPrimary: AppColors.surface,
    secondary: AppColors.coral,
    onSecondary: AppColors.surface,
    surface: AppColors.offWhite,
    onSurface: AppColors.abyss,
    outline: AppColors.border,
    error: AppColors.coral,
    onError: AppColors.surface,
  );

  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.cobalt,
    onPrimary: AppColors.surface,
    secondary: AppColors.coralLight,
    onSecondary: AppColors.abyss,
    surface: AppColors.abyss,
    onSurface: AppColors.surface,
    outline: AppColors.darkSurfaceBorder,
    error: AppColors.coralLight,
    onError: AppColors.abyss,
  );

  static ThemeData _base(ColorScheme scheme) {
    const baseTextTheme = TextTheme(
      displayLarge: AppTypography.displayXL,
      displayMedium: AppTypography.displayL,
      headlineLarge: AppTypography.screenTitle,
      titleLarge: AppTypography.cardTitle,
      labelLarge: AppTypography.buttonL,
      labelMedium: AppTypography.buttonM,
      bodyLarge: AppTypography.body,
      bodyMedium: AppTypography.body,
      labelSmall: AppTypography.sectionLabel,
      bodySmall: AppTypography.caption,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      fontFamily: 'InstrumentSans',
      textTheme: baseTextTheme.apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
      ),
    );
  }
}
