import 'package:flutter/material.dart';

import '../../../../core/widgets/user_avatar.dart';

/// Centered profile header: a ringed avatar, the name, and an optional
/// secondary line (email for the owner, nothing for others).
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.photoUrl,
    required this.initial,
    required this.name,
    this.secondaryLine,
  });

  final String photoUrl;
  final String initial;
  final String name;
  final String? secondaryLine;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.10),
              width: 4,
            ),
          ),
          child: UserAvatar(
            photoUrl: photoUrl,
            initial: initial,
            radius: 56,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          name,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium,
        ),
        if (secondaryLine != null && secondaryLine!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            secondaryLine!,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
