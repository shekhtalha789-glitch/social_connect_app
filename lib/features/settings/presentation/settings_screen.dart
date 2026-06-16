import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/placeholder_view.dart';

/// App settings. Built out in later commits (theme, sign out, notifications).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.settingsTitle)),
      body: const PlaceholderView(
        icon: Icons.settings_outlined,
        title: 'Settings',
        subtitle: 'Account, theme and notifications — ${AppStrings.comingSoon}.',
      ),
    );
  }
}
