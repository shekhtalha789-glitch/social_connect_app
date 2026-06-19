import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_theme.dart';
import '../features/notifications/data/notification_service.dart';
import '../features/notifications/presentation/notification_providers.dart';
import 'router.dart';

/// APP
/// Root widget. Owns app-wide config (title, theme, router).
/// A [ConsumerWidget] so it can read Riverpod providers — the router is exposed
/// as a provider so future features (e.g. auth redirects) can drive navigation.
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    // Start FCM setup once a user signs in.
    ref.watch(notificationSetupProvider);

    return MaterialApp.router(
      title: AppStrings.appName,
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      scaffoldMessengerKey: scaffoldMessengerKey,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
