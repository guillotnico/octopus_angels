import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Design tokens — linear gradients.
abstract final class AppGradients {
  /// Splash screen — vertical cobalt → abyss.
  static const LinearGradient splash = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[AppColors.cobalt, AppColors.abyss],
  );

  /// Dive screen — depth metaphor (three-stop descent to the abyss).
  static const LinearGradient dive = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[AppColors.diveMid1, AppColors.diveMid2, AppColors.abyss],
  );

  /// Start screen — gentle top-down tint.
  static const LinearGradient startScreen = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[AppColors.offWhite, AppColors.blueTint200],
  );
}
