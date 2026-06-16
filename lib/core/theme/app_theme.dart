import 'package:flutter/material.dart';

/// CORE / THEME
/// One place that owns the app's look & feel. Change colors/fonts here and
/// the whole app updates. Keeps styling out of individual widgets.
class AppTheme {
  AppTheme._(); // not meant to be instantiated

  static const Color seedColor = Colors.deepPurple;

  static ThemeData get light => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        useMaterial3: true,
      );
}
