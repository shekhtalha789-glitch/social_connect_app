import 'package:flutter/material.dart';

/// Design tokens — "Kinetic Minimalist" palette (see DESIGN.md).
/// Single source of truth for colour; the [ColorScheme] in app_theme.dart is
/// built from these.
class AppColors {
  AppColors._();

  // Primary (high-signal indigo for actions, active states, links)
  static const primary = Color(0xFF4241BC);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFF5B5BD6);
  static const onPrimaryContainer = Color(0xFFEDEAFF);
  static const inversePrimary = Color(0xFFC1C1FF);
  static const surfaceTint = Color(0xFF4E4EC9);
  static const primaryFixed = Color(0xFFE2DFFF);
  static const onPrimaryFixed = Color(0xFF0A006B);

  // Secondary (spirited red — reserved for "Like" and critical accents)
  static const secondary = Color(0xFFB7131A);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFDB322F);
  static const onSecondaryContainer = Color(0xFFFFFBFF);

  // Tertiary (cool neutral)
  static const tertiary = Color(0xFF51525C);
  static const onTertiary = Color(0xFFFFFFFF);
  static const tertiaryContainer = Color(0xFF6A6A75);
  static const onTertiaryContainer = Color(0xFFEDEBF8);

  // Error
  static const error = Color(0xFFBA1A1A);
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF93000A);

  // Surfaces (cool-tinted neutrals; value shifts instead of heavy borders)
  static const background = Color(0xFFFBF8FF);
  static const surface = Color(0xFFFBF8FF);
  static const surfaceDim = Color(0xFFDCD9E0);
  static const surfaceBright = Color(0xFFFBF8FF);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF5F2F9);
  static const surfaceContainer = Color(0xFFF0EDF4);
  static const surfaceContainerHigh = Color(0xFFEAE7EE);
  static const surfaceContainerHighest = Color(0xFFE4E1E8);
  static const onSurface = Color(0xFF1B1B20);
  static const onSurfaceVariant = Color(0xFF464553);
  static const inverseSurface = Color(0xFF303035);
  static const inverseOnSurface = Color(0xFFF3EFF7);

  // Outlines
  static const outline = Color(0xFF777585);
  static const outlineVariant = Color(0xFFC7C4D6);

  /// The "Like" accent. Per the design, the spirited red secondary is reserved
  /// for likes.
  static const like = secondary;
}
