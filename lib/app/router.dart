import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/feed/presentation/feed_screen.dart';
import '../features/home/presentation/home_shell.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/welcome/presentation/welcome_screen.dart';

/// Route path constants — referenced everywhere instead of raw strings so a
/// rename happens in one place.
abstract class Routes {
  static const welcome = '/welcome';
  static const feed = '/feed';
  static const profile = '/profile';
  static const settings = '/settings';
}

/// Exposes the app's [GoRouter] as a provider. Keeping it in Riverpod lets later
/// features (auth) plug a `redirect` keyed on auth state without touching [App].
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.welcome,
    routes: [
      GoRoute(
        path: Routes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      // Bottom-nav tabs live inside a StatefulShellRoute so each tab keeps its
      // own navigation stack — the Stack + Tab navigator combo from the spec.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            HomeShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.feed,
                builder: (context, state) => const FeedScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Route not found: ${state.uri}')),
    ),
  );
});
