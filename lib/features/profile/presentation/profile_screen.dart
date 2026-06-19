import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/user_avatar.dart';
import '../domain/app_user.dart';
import 'profile_providers.dart';

/// The signed-in user's profile: avatar, name, bio, email, and an edit action.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentUserProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profileTitle),
        actions: [
          if (profile.asData?.value != null)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit profile',
              onPressed: () => context.push(Routes.editProfile),
            ),
        ],
      ),
      body: profile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const Center(child: Text(AppStrings.loadError)),
        data: (user) => user == null
            ? _EmptyProfile(onCreate: () => context.push(Routes.editProfile))
            : _ProfileBody(user: user),
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Center(
          child: UserAvatar(
            photoUrl: user.photoUrl,
            initial: user.initial,
            radius: 56,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user.name.isEmpty ? 'No name yet' : user.name,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 4),
        Text(
          user.email,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),
        Text('About', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(
          user.bio.isEmpty ? 'No bio yet. Tap edit to add one.' : user.bio,
          style: theme.textTheme.bodyLarge,
        ),
      ],
    );
  }
}

class _EmptyProfile extends StatelessWidget {
  const _EmptyProfile({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Finish setting up your profile'),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: onCreate,
            child: const Text('Set up profile'),
          ),
        ],
      ),
    );
  }
}
