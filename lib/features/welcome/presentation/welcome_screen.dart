import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/responsive_center.dart';

/// Landing screen for signed-out users. Animates in on launch and routes to
/// Log In / Sign Up.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: ResponsiveCenter(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                Icon(
                      Icons.connect_without_contact,
                      size: 96,
                      color: theme.colorScheme.primary,
                    )
                    .animate()
                    .scale(
                      duration: 450.ms,
                      curve: Curves.easeOutBack,
                      begin: const Offset(0.6, 0.6),
                      end: const Offset(1, 1),
                    )
                    .fadeIn(duration: 450.ms),
                const SizedBox(height: 24),
                Text(
                  AppStrings.appName,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                const SizedBox(height: 8),
                Text(
                  AppStrings.appTagline,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ).animate().fadeIn(delay: 350.ms, duration: 400.ms),
                const Spacer(),
                FilledButton(
                  onPressed: () => context.go(Routes.login),
                  child: const Text('Log In'),
                ).animate().fadeIn(delay: 500.ms, duration: 350.ms),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => context.go(Routes.signup),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                  child: const Text('Create account'),
                ).animate().fadeIn(delay: 600.ms, duration: 350.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
