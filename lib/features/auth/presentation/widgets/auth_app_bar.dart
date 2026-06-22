import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Shared top app bar for the auth screens: a back button and a centered
/// primary-coloured title, matching the Kinetic Minimalist auth design.
///
/// Back behaviour defaults to popping the current route; if there's nothing to
/// pop (e.g. the user deep-linked straight here), it falls back to Welcome.
class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AuthAppBar({super.key, required this.title, this.onBack});

  final String title;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _defaultBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.welcome);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: scheme.onSurfaceVariant,
        onPressed: onBack ?? () => _defaultBack(context),
      ),
      title: Text(
        title,
        style: AppTextStyles.headlineMd.copyWith(color: scheme.primary),
      ),
    );
  }
}
