import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';

/// ENTRY POINT
/// The only job of main() is to start the app inside a Riverpod [ProviderScope],
/// which makes every provider available to the whole widget tree.
/// All app config lives in [App].
void main() {
  runApp(const ProviderScope(child: App()));
}
