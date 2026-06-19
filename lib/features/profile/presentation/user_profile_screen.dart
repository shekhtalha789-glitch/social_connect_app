import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../feed/presentation/feed_providers.dart';
import '../../feed/presentation/widgets/post_card.dart';
import '../domain/app_user.dart';
import 'profile_providers.dart';

/// Public profile of another user: their info plus the posts they've made.
/// Reached by tapping an author in the feed.
class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider(uid));
    final posts = ref.watch(userPostsStreamProvider(uid));

    return Scaffold(
      appBar: AppBar(
        title: Text(profile.asData?.value?.name ?? AppStrings.profileTitle),
      ),
      body: profile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const Center(child: Text(AppStrings.loadError)),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('User not found'));
          }
          return ListView(
            children: [
              _Header(user: user),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Posts',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              posts.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text(AppStrings.loadError)),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: Text('No posts yet.')),
                    );
                  }
                  return Column(
                    children: [for (final p in items) PostCard(post: p)],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          UserAvatar(
            photoUrl: user.photoUrl,
            initial: user.initial,
            radius: 48,
          ),
          const SizedBox(height: 12),
          Text(
            user.name.isEmpty ? 'No name' : user.name,
            style: theme.textTheme.headlineSmall,
          ),
          if (user.bio.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(user.bio, textAlign: TextAlign.center),
          ],
        ],
      ),
    );
  }
}
