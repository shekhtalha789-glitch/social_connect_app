import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';
import '../../auth/presentation/auth_providers.dart';
import '../data/notification_service.dart';

final firebaseMessagingProvider = Provider<FirebaseMessaging>(
  (ref) => FirebaseMessaging.instance,
);

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(
    ref.watch(firebaseMessagingProvider),
    ref.watch(firebaseFirestoreProvider),
    ref.watch(firebaseAuthProvider),
  );
});

/// Initialises messaging once a user is signed in (so the FCM token is saved
/// against their account). Kept alive by being watched in [App].
final notificationSetupProvider = Provider<void>((ref) {
  ref.listen<AsyncValue>(authStateProvider, (_, next) {
    if (next.asData?.value != null) {
      ref.read(notificationServiceProvider).init();
    }
  }, fireImmediately: true);
});
