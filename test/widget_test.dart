import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:social_connect_app/app/app.dart';
import 'package:social_connect_app/core/constants/app_strings.dart';

void main() {
  testWidgets('Welcome screen renders with app name and CTA', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.getStarted), findsOneWidget);
  });

  testWidgets('Get Started navigates into the bottom-nav shell', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.getStarted));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
