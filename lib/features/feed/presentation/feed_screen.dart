import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/placeholder_view.dart';

/// The post feed. Built out in a later commit (create posts, fetch from
/// Firestore, scrollable list, timestamps).
class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.feedTitle)),
      body: const PlaceholderView(
        icon: Icons.dynamic_feed_outlined,
        title: 'Your feed lives here',
        subtitle: 'Posts from you and others — ${AppStrings.comingSoon}.',
      ),
    );
  }
}
