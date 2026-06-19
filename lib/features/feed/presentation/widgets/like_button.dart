import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';

/// Like action with a bouncy heart. The icon replays a spring-scale animation
/// whenever the liked state flips, giving the tap a tactile, modern feel.
class LikeButton extends StatelessWidget {
  const LikeButton({
    super.key,
    required this.liked,
    required this.count,
    required this.onTap,
  });

  final bool liked;
  final int count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = liked
        ? AppColors.like
        : Theme.of(context).colorScheme.onSurfaceVariant;

    final icon =
        Icon(
              liked ? Icons.favorite : Icons.favorite_border,
              size: 20,
              color: color,
            )
            // key flips with `liked`, so the animation re-runs on each toggle.
            .animate(key: ValueKey(liked))
            .scale(
              begin: const Offset(0.7, 0.7),
              end: const Offset(1, 1),
              duration: 350.ms,
              curve: Curves.elasticOut,
            );

    return TextButton.icon(
      onPressed: onTap,
      icon: icon,
      label: Text(
        count > 0 ? '$count' : 'Like',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      style: TextButton.styleFrom(foregroundColor: color),
    );
  }
}
