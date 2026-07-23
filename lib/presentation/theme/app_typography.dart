import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Design tokens — typography scale.
///
/// Two font families:
/// - [_anton] — display only (titles, hero numbers, primary button labels).
///   Always paired with positive letter-spacing (+3 % to +8 %).
/// - [_instrumentSans] — running text (weights 400/500/600/700).
///
/// The corresponding .ttf files are not yet embedded — as long as they are
/// missing under `assets/fonts/` and undeclared in `pubspec.yaml`, text
/// falls back to the platform default font. Once the files are placed,
/// declare them in `pubspec.yaml` (see the follow-up in CLAUDE.md) and no
/// code here needs to change.
///
/// Absolute minimum size is 9.5 sp; tap targets stay >= 44 px.
abstract final class AppTypography {
  static const String _anton = 'Anton';
  static const String _instrumentSans = 'InstrumentSans';

  // -- Display / titles (Anton) -----------------------------------------

  /// Hero counters (huge stat numbers).
  static const TextStyle displayXL = TextStyle(
    fontFamily: _anton,
    fontSize: 74,
    letterSpacing: 74 * 0.05,
    height: 1.0,
  );

  /// Large display headline.
  static const TextStyle displayL = TextStyle(
    fontFamily: _anton,
    fontSize: 32,
    letterSpacing: 32 * 0.05,
    height: 1.05,
  );

  /// Screen title.
  static const TextStyle screenTitle = TextStyle(
    fontFamily: _anton,
    fontSize: 26,
    letterSpacing: 26 * 0.04,
    height: 1.1,
  );

  /// Card title.
  static const TextStyle cardTitle = TextStyle(
    fontFamily: _anton,
    fontSize: 17,
    letterSpacing: 17 * 0.03,
    height: 1.15,
  );

  /// Stat numbers (inline in cards).
  static const TextStyle number = TextStyle(
    fontFamily: _anton,
    fontSize: 24,
    letterSpacing: 24 * 0.03,
    height: 1.0,
  );

  /// Large button label.
  static const TextStyle buttonL = TextStyle(
    fontFamily: _anton,
    fontSize: 20,
    letterSpacing: 20 * 0.05,
    height: 1.0,
  );

  /// Medium button label.
  static const TextStyle buttonM = TextStyle(
    fontFamily: _anton,
    fontSize: 16,
    letterSpacing: 16 * 0.05,
    height: 1.0,
  );

  // -- Body copy (Instrument Sans) --------------------------------------

  /// UPPERCASE section header (bold, +9 % tracking, muted colour).
  static const TextStyle sectionLabel = TextStyle(
    fontFamily: _instrumentSans,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 12 * 0.09,
    color: AppColors.textMuted,
  );

  /// Default running text.
  static const TextStyle body = TextStyle(
    fontFamily: _instrumentSans,
    fontSize: 14.5,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  /// Emphasised body copy.
  static const TextStyle bodyStrong = TextStyle(
    fontFamily: _instrumentSans,
    fontSize: 14.5,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  /// Caption / helper text (muted colour).
  static const TextStyle caption = TextStyle(
    fontFamily: _instrumentSans,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.35,
  );

  /// Micro labels (badges, footnote figures). Never smaller than 9.5 sp.
  static const TextStyle micro = TextStyle(
    fontFamily: _instrumentSans,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );
}
