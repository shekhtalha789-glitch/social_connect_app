import 'package:flutter/material.dart';

import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'views/home_view.dart';

/// APP
/// Root widget. Holds app-wide config (title, theme, first screen).
/// Kept separate from main.dart so the entry point stays a one-liner.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      theme: AppTheme.light,
      home: const HomeView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
