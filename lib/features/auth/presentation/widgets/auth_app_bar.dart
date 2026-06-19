import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';

/// Shared top app bar for the auth screens: a back button and a centered
/// primary-coloured title, matching the Kinetic Minimalist auth design.
class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AuthAppBar({super.key, required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: scheme.onSurfaceVariant,
        onPressed: onBack,
      ),
      title: Text(
        title,
        style: AppTextStyles.headlineMd.copyWith(color: scheme.primary),
      ),
    );
  }
}
