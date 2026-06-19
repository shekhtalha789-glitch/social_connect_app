import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../profile/domain/app_user.dart';
import '../domain/comment.dart';
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

  /// Live stream of a single user's posts, newest first.
  /// (Requires a Firestore composite index on authorId + createdAt — the
  /// console offers a one-click link the first time this query runs.)
  Stream<List<Post>> watchUserPosts(String uid) {
    return _posts
        .where('authorId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(Post.fromDoc).toList());
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
      'commentCount': 0,
    });
  }

  /// Likes or unlikes a post for [uid]. Runs in a transaction so the
  /// `likeCount` and `likedBy` array can never drift on concurrent taps.
  Future<void> toggleLike(String postId, String uid) async {
    final ref = _posts.doc(postId);
    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(ref);
      if (!snap.exists) return;

      final likedBy =
          List<String>.from(snap.data()?['likedBy'] as List<dynamic>? ?? const []);
      final liked = likedBy.contains(uid);

      tx.update(ref, {
        'likedBy':
            liked ? FieldValue.arrayRemove([uid]) : FieldValue.arrayUnion([uid]),
        'likeCount': FieldValue.increment(liked ? -1 : 1),
      });
    });
  }

  /// Live comments for a post, oldest first.
  Stream<List<Comment>> watchComments(String postId) {
    return _posts
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt')
        .snapshots()
        .map((snap) => snap.docs.map(Comment.fromDoc).toList());
  }

  /// Adds a comment and bumps the post's `commentCount` atomically.
  Future<void> addComment({
    required String postId,
    required AppUser author,
    required String text,
  }) async {
    final postRef = _posts.doc(postId);
    final commentRef = postRef.collection('comments').doc();

    final batch = _firestore.batch();
    batch.set(commentRef, {
      'authorId': author.uid,
      'authorName': author.name,
      'authorPhotoUrl': author.photoUrl,
      'text': text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    batch.update(postRef, {'commentCount': FieldValue.increment(1)});
    await batch.commit();
  }
}
