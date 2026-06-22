import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';

/// HOME SHELL
/// Hosts the bottom navigation bar and swaps between the Feed, Profile and
/// Settings branches. [StatefulNavigationShell] (from go_router) keeps each
/// tab's navigation stack alive when switching tabs.
class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final onFeedTab = navigationShell.currentIndex == 0;
    return PopScope(
      // On a non-Feed tab, the system back button returns to Feed instead of
      // exiting the app. On Feed, back is allowed to pop (exit).
      canPop: onFeedTab,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) navigationShell.goBranch(0);
      },
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _onTap,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: AppStrings.feedTitle,
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: AppStrings.profileTitle,
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: AppStrings.settingsTitle,
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(int index) {
    // initialLocation: jumps back to the branch root if the tab is re-tapped.
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
