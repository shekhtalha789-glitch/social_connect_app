import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:social_connect_app/app/app.dart';
import 'package:social_connect_app/core/constants/app_strings.dart';
import 'package:social_connect_app/features/auth/presentation/auth_providers.dart';

/// Pumps the app with a signed-out auth state so tests don't touch Firebase.
Future<void> pumpSignedOutApp(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authStateProvider.overrideWith((ref) => Stream<User?>.value(null)),
      ],
      child: const App(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Welcome screen shows app name and auth CTAs', (tester) async {
    await pumpSignedOutApp(tester);

    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);
  });

  testWidgets('Tapping Log In opens the login screen', (tester) async {
    await pumpSignedOutApp(tester);

    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Forgot password?'), findsOneWidget);
  });

  testWidgets('Signed-out user cannot reach the feed', (tester) async {
    await pumpSignedOutApp(tester);

    // No bottom-nav shell should be visible while signed out.
    expect(find.byType(NavigationBar), findsNothing);
  });
}
