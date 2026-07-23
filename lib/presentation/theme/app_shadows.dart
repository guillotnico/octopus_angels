import 'package:flutter/material.dart';

/// Design tokens — named shadow presets.
///
/// Prefer these over ad-hoc `BoxShadow(...)` in components.
abstract final class AppShadows {
  /// Subtle elevation for organic cards.
  /// `rgba(10, 30, 92, .06)` — abyss, alpha 0x0F.
  static const List<BoxShadow> card = <BoxShadow>[
    BoxShadow(color: Color(0x0F0A1E5C), offset: Offset(0, 3), blurRadius: 10),
  ];

  /// Floating action elements and sticky footers.
  /// `rgba(10, 30, 92, .20)`.
  static const List<BoxShadow> floating = <BoxShadow>[
    BoxShadow(color: Color(0x330A1E5C), offset: Offset(0, 3), blurRadius: 12),
  ];

  /// Primary CTA glow (cobalt buttons).
  /// `rgba(30, 71, 185, .32)`.
  static const List<BoxShadow> primary = <BoxShadow>[
    BoxShadow(color: Color(0x521E47B9), offset: Offset(0, 12), blurRadius: 28),
  ];

  /// Warm CTA glow (coral buttons).
  /// `rgba(255, 107, 74, .40)`.
  static const List<BoxShadow> coral = <BoxShadow>[
    BoxShadow(color: Color(0x66FF6B4A), offset: Offset(0, 12), blurRadius: 28),
  ];
}
