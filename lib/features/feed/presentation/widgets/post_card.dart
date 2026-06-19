import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/utils/time_ago.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../../auth/presentation/auth_providers.dart';
import '../../domain/post.dart';
import '../feed_providers.dart';
import 'like_button.dart';

/// A single post in the feed: author header, text, optional image, and the
/// like / comment action row.
class PostCard extends ConsumerWidget {
  const PostCard({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final uid = ref.watch(authStateProvider).asData?.value?.uid;
    final liked = post.isLikedBy(uid);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: UserAvatar(
              photoUrl: post.authorPhotoUrl,
              initial: post.authorInitial,
            ),
            title: Text(
              post.authorName.isEmpty ? 'Unknown' : post.authorName,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(timeAgo(post.createdAt)),
            onTap: post.authorId.isEmpty
                ? null
                : () => context.push(Routes.userProfile(post.authorId)),
          ),
          if (post.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(post.text, style: theme.textTheme.bodyLarge),
            ),
          if (post.hasImage)
            CachedNetworkImage(
              imageUrl: post.imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => const SizedBox(
                height: 120,
                child: Center(child: Icon(Icons.broken_image_outlined)),
              ),
            ),
          Row(
            children: [
              LikeButton(
                liked: liked,
                count: post.likeCount,
                onTap: uid == null
                    ? null
                    : () => ref
                          .read(feedRepositoryProvider)
                          .toggleLike(post.id, uid),
              ),
              _ActionButton(
                icon: Icons.mode_comment_outlined,
                label: post.commentCount > 0
                    ? '${post.commentCount}'
                    : 'Comment',
                onTap: () => context.push(Routes.comments(post.id)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
