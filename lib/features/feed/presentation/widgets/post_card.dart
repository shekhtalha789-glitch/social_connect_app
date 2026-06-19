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

/// A single post in the feed: tappable author header, text, optional image, and
/// the like / comment action row.
class PostCard extends ConsumerWidget {
  const PostCard({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final uid = ref.watch(authStateProvider).asData?.value?.uid;
    final liked = post.isLikedBy(uid);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: scheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author header (tappable -> profile)
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: post.authorId.isEmpty
                  ? null
                  : () => context.push(Routes.userProfile(post.authorId)),
              child: Row(
                children: [
                  UserAvatar(
                    photoUrl: post.authorPhotoUrl,
                    initial: post.authorInitial,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName.isEmpty ? 'Unknown' : post.authorName,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        timeAgo(post.createdAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (post.text.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(post.text, style: theme.textTheme.bodyLarge),
            ],
            if (post.hasImage) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: CachedNetworkImage(
                    imageUrl: post.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: scheme.surfaceContainerHigh,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: scheme.surfaceContainerHigh,
                      child: const Center(
                        child: Icon(Icons.broken_image_outlined),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Divider(color: scheme.surfaceContainerHigh, height: 1),
            const SizedBox(height: 4),
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
                const SizedBox(width: 8),
                _ActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: post.commentCount > 0
                      ? '${post.commentCount}'
                      : 'Comment',
                  onTap: () => context.push(Routes.comments(post.id)),
                ),
              ],
            ),
          ],
        ),
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
      label: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
