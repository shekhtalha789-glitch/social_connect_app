import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/auth_providers.dart';
import '../features/auth/presentation/forgot_password_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/signup_screen.dart';
import '../features/feed/presentation/comments_screen.dart';
import '../features/feed/presentation/create_post_screen.dart';
import '../features/feed/presentation/feed_screen.dart';
import '../features/home/presentation/home_shell.dart';
import '../features/profile/presentation/edit_profile_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/welcome/presentation/welcome_screen.dart';

/// Route path constants — referenced everywhere instead of raw strings so a
/// rename happens in one place.
abstract class Routes {
  static const welcome = '/welcome';
  static const login = '/login';
  static const signup = '/signup';
  static const forgot = '/forgot-password';
  static const feed = '/feed';
  static const createPost = '/create-post';
  static const profile = '/profile';
  static const editProfile = '/edit-profile';
  static const settings = '/settings';

  static String comments(String postId) => '/posts/$postId/comments';
}

/// Routes reachable while signed out. Everything else requires auth.
const _authArea = {
  Routes.welcome,
  Routes.login,
  Routes.signup,
  Routes.forgot,
};

/// Exposes the app's [GoRouter] as a provider. The router watches auth state via
/// a [ValueNotifier] (its `refreshListenable`) so it re-evaluates the redirect
/// whenever the user signs in or out.
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ValueNotifier<AsyncValue<User?>>(const AsyncValue.loading());
  ref.listen(
    authStateProvider,
    (_, next) => authState.value = next,
    fireImmediately: true,
  );
  ref.onDispose(authState.dispose);

  return GoRouter(
    initialLocation: Routes.welcome,
    refreshListenable: authState,
    redirect: (context, state) {
      // While the first auth check is in flight, don't bounce the user around.
      if (authState.value.isLoading) return null;

      final loggedIn = authState.value.asData?.value != null;
      final inAuthArea = _authArea.contains(state.matchedLocation);

      if (!loggedIn) return inAuthArea ? null : Routes.welcome;
      if (loggedIn && inAuthArea) return Routes.feed;
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: Routes.forgot,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      // Full-screen routes pushed over the shell (auth-gated by default).
      GoRoute(
        path: Routes.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: Routes.createPost,
        builder: (context, state) => const CreatePostScreen(),
      ),
      GoRoute(
        path: '/posts/:id/comments',
        builder: (context, state) =>
            CommentsScreen(postId: state.pathParameters['id']!),
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
