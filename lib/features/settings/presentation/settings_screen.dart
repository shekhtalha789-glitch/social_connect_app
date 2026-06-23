import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/responsive_center.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../profile/presentation/profile_providers.dart';

/// App settings — shows the signed-in account (real name + email) and sign-out.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // Real registered profile (users/{uid}); fall back to the auth record.
    final profile = ref.watch(currentUserProfileProvider).asData?.value;
    final authUser = ref.watch(authStateProvider).asData?.value;

    final name = profile?.name.isNotEmpty == true
        ? profile!.name
        : (authUser?.displayName ?? 'Account');
    final email = profile?.email.isNotEmpty == true
        ? profile!.email
        : (authUser?.email ?? '');

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.settingsTitle)),
      body: ResponsiveCenter(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            // Account card
            Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.2,
                  ),
                ),
              ),
              child: Row(
                children: [
                  UserAvatar(
                    photoUrl: profile?.photoUrl ?? '',
                    initial: name.isNotEmpty ? name[0].toUpperCase() : '?',
                    radius: 28,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: theme.textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          email,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: theme.colorScheme.error),
              title: Text(
                'Sign out',
                style: TextStyle(color: theme.colorScheme.error),
              ),
              onTap: () => _confirmSignOut(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text('You can log back in any time.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // The router's auth guard redirects to the welcome flow on sign-out.
      await ref.read(authRepositoryProvider).signOut();
    }
  }
}
