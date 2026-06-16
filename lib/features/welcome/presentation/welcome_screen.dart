import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/constants/app_strings.dart';

/// Landing screen shown on first launch. For now its CTA drops the user into the
/// app shell; once auth is built (next commit) the router redirects
/// unauthenticated users here and the CTA leads to Sign Up / Login.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Icon(Icons.connect_without_contact,
                  size: 96, color: theme.colorScheme.primary),
              const SizedBox(height: 24),
              Text(
                AppStrings.appName,
                style: theme.textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.appTagline,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => context.go(Routes.feed),
                child: const Text(AppStrings.getStarted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
