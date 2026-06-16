import 'package:flutter/material.dart';

import '../../models/post.dart';

/// VIEW / WIDGET
/// A small, reusable UI piece for one post. Reusable widgets live here so
/// screens stay short and readable.
class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(child: Text(post.author[0])),
        title: Text(post.author),
        subtitle: Text(post.content),
      ),
    );
  }
}
