import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../domain/app_user.dart';

/// PROFILE REPOSITORY
/// Reads/writes the `users/{uid}` document and the profile image in Storage.
class ProfileRepository {
  ProfileRepository(this._firestore, this._storage, this._auth);

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _firestore.collection('users').doc(uid);

  /// Live stream of a user's profile.
  Stream<AppUser?> watchUser(String uid) {
    return _userDoc(uid).snapshots().map(
          (doc) => doc.exists ? AppUser.fromDoc(doc) : null,
        );
  }

  /// Uploads a new profile image and returns its download URL.
  Future<String> uploadPhoto(String uid, File file) async {
    final ref = _storage.ref('profile_images/$uid.jpg');
    await ref.putFile(file, SettableMetadata(contentType: 'image/jpeg'));
    return ref.getDownloadURL();
  }

  /// Persists profile edits. Writes the Firestore doc and keeps the Firebase
  /// Auth display name / photo in sync so they're available app-wide.
  Future<void> updateProfile({
    required String uid,
    required String name,
    required String bio,
    String? photoUrl,
  }) async {
    final data = <String, dynamic>{
      'name': name.trim(),
      'bio': bio.trim(),
      'photoUrl': ?photoUrl,
    };
    await _userDoc(uid).set(data, SetOptions(merge: true));

    final user = _auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(name.trim());
      if (photoUrl != null) await user.updatePhotoURL(photoUrl);
    }
  }
}
