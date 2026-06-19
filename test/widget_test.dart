import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:social_connect_app/app/app.dart';
import 'package:social_connect_app/core/constants/app_strings.dart';
import 'package:social_connect_app/features/auth/presentation/auth_providers.dart';

/// 1x1 transparent PNG so Image.asset resolves in tests (assets aren't bundled
/// in the unit-test environment).
final _transparentPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==',
);

class _FakeAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    // AssetImage first reads the asset manifest; return a valid empty one.
    if (key.contains('AssetManifest')) {
      return const StandardMessageCodec().encodeMessage(<String, Object>{})!;
    }
    return ByteData.sublistView(Uint8List.fromList(_transparentPng));
  }
}

/// Pumps the app signed out, with a fake asset bundle. Uses fixed-duration
/// pumps because the welcome screen has a looping animation (never "settles").
Future<void> pumpSignedOutApp(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authStateProvider.overrideWith((ref) => Stream<User?>.value(null)),
      ],
      child: DefaultAssetBundle(bundle: _FakeAssetBundle(), child: const App()),
    ),
  );
  await tester.pump(const Duration(milliseconds: 350));
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
    await tester.pump(); // start the route transition
    await tester.pump(const Duration(milliseconds: 400)); // finish it

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Forgot password?'), findsOneWidget);
  });

  testWidgets('Signed-out user cannot reach the feed', (tester) async {
    await pumpSignedOutApp(tester);

    expect(find.byType(NavigationBar), findsNothing);
  });
}
