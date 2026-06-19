import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography tokens — Inter, per DESIGN.md. Use these named styles directly,
/// or the mapped Material [TextTheme] slots built in app_theme.dart.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle get headlineLg => GoogleFonts.inter(
        fontSize: 32,
        height: 40 / 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.02 * 32,
      );

  static TextStyle get headlineMd => GoogleFonts.inter(
        fontSize: 24,
        height: 32 / 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.01 * 24,
      );

  static TextStyle get titleMd => GoogleFonts.inter(
        fontSize: 18,
        height: 24 / 18,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get bodyLg => GoogleFonts.inter(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get bodyMd => GoogleFonts.inter(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get labelMd => GoogleFonts.inter(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.01 * 12,
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w400,
      );

  /// Button label style (16px bold).
  static TextStyle get button => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w700,
      );
}
