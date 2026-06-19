import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../profile/domain/app_user.dart';
import '../domain/post.dart';

/// FEED REPOSITORY
/// Creates posts (with an optional image in Storage) and streams the feed.
class FeedRepository {
  FeedRepository(this._firestore, this._storage);

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  CollectionReference<Map<String, dynamic>> get _posts =>
      _firestore.collection('posts');

  /// Live feed, newest first.
  Stream<List<Post>> watchPosts() {
    return _posts.orderBy('createdAt', descending: true).snapshots().map(
          (snap) => snap.docs.map(Post.fromDoc).toList(),
        );
  }

  /// Creates a post. Uploads the optional image first so the document is written
  /// once, already pointing at its image URL.
  Future<void> createPost({
    required AppUser author,
    required String text,
    File? image,
  }) async {
    final docRef = _posts.doc();

    var imageUrl = '';
    if (image != null) {
      final ref = _storage.ref('post_images/${docRef.id}.jpg');
      await ref.putFile(image, SettableMetadata(contentType: 'image/jpeg'));
      imageUrl = await ref.getDownloadURL();
    }

    await docRef.set({
      'authorId': author.uid,
      'authorName': author.name,
      'authorPhotoUrl': author.photoUrl,
      'text': text.trim(),
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
      'likeCount': 0,
      'likedBy': <String>[],
    });
  }
}
