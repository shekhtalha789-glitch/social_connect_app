import 'package:cloud_firestore/cloud_firestore.dart';

/// Domain model for a comment (a `posts/{postId}/comments/{commentId}` doc).
class Comment {
  const Comment({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorPhotoUrl,
    required this.text,
    required this.createdAt,
  });

  final String id;
  final String authorId;
  final String authorName;
  final String authorPhotoUrl;
  final String text;
  final DateTime createdAt;

  String get authorInitial =>
      authorName.isNotEmpty ? authorName[0].toUpperCase() : '?';

  factory Comment.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const {};
    final ts = data['createdAt'];
    return Comment(
      id: doc.id,
      authorId: (data['authorId'] as String?) ?? '',
      authorName: (data['authorName'] as String?) ?? '',
      authorPhotoUrl: (data['authorPhotoUrl'] as String?) ?? '',
      text: (data['text'] as String?) ?? '',
      createdAt: ts is Timestamp ? ts.toDate() : DateTime.now(),
    );
  }
}
