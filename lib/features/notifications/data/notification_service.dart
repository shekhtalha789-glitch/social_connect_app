import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

/// Global messenger key so foreground push messages can show an in-app banner
/// without needing a BuildContext.
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

/// Background/terminated messages: the system tray shows the notification
/// payload automatically, so this handler only needs to exist and be registered.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

/// NOTIFICATION SERVICE
/// Client-side Firebase Cloud Messaging: asks permission, stores the device
/// token on the user document (so the Cloud Function can target it), and shows
/// foreground messages as an in-app banner.
class NotificationService {
  NotificationService(this._messaging, this._firestore, this._auth);

  final FirebaseMessaging _messaging;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Future<void> init() async {
    await _messaging.requestPermission();

    FirebaseMessaging.onMessage.listen(_showForeground);
    _messaging.onTokenRefresh.listen(_saveToken);

    final token = await _messaging.getToken();
    if (token != null) await _saveToken(token);
  }

  Future<void> _saveToken(String token) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    await _firestore
        .collection('users')
        .doc(uid)
        .set({'fcmToken': token}, SetOptions(merge: true));
  }

  void _showForeground(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    final title = notification.title;
    final body = notification.body ?? '';
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(title == null ? body : '$title — $body')),
    );
  }
}
