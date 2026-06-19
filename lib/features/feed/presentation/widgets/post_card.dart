import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/time_ago.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../domain/post.dart';

/// A single post in the feed: author header, text, and an optional image.
class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
