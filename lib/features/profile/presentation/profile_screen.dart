import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/placeholder_view.dart';

/// The current user's profile. Built out in a later commit (name, bio,
/// profile picture, the user's own posts).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.profileTitle)),
      body: const PlaceholderView(
        icon: Icons.person_outline,
        title: 'Your profile',
        subtitle: 'Name, bio and photo — ${AppStrings.comingSoon}.',
      ),
    );
  }
}
