import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/responsive_center.dart';
import '../../feed/presentation/feed_providers.dart';
import '../../feed/presentation/widgets/post_card.dart';
import 'profile_providers.dart';
import 'widgets/profile_header.dart';

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
          return ResponsiveCenter(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 16),
              children: [
                const SizedBox(height: 24),
                ProfileHeader(
                  photoUrl: user.photoUrl,
                  initial: user.initial,
                  name: user.name.isEmpty ? 'No name' : user.name,
                ),
                if (user.bio.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      user.bio,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Text(
                    'Posts',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                _UserPosts(posts: posts),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _UserPosts extends StatelessWidget {
  const _UserPosts({required this.posts});

  final AsyncValue posts;

  @override
  Widget build(BuildContext context) {
    return posts.when(
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
        return Column(children: [for (final p in items) PostCard(post: p)]);
      },
    );
  }
}
