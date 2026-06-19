import 'package:cloud_firestore/cloud_firestore.dart';

/// Domain model for a feed post (a `posts/{postId}` document).
/// Author details are denormalised onto the post so the feed renders without an
/// extra read per author.
class Post {
  const Post({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorPhotoUrl,
    required this.text,
    required this.imageUrl,
    required this.createdAt,
    required this.likeCount,
    required this.likedBy,
    required this.commentCount,
  });

  final String id;
  final String authorId;
  final String authorName;
  final String authorPhotoUrl;
  final String text;
  final String imageUrl;
  final DateTime createdAt;
  final int likeCount;
  final List<String> likedBy;
  final int commentCount;

  bool get hasImage => imageUrl.isNotEmpty;
  String get authorInitial =>
      authorName.isNotEmpty ? authorName[0].toUpperCase() : '?';

  bool isLikedBy(String? uid) => uid != null && likedBy.contains(uid);

  factory Post.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const {};
    final ts = data['createdAt'];
    return Post(
      id: doc.id,
      authorId: (data['authorId'] as String?) ?? '',
      authorName: (data['authorName'] as String?) ?? '',
      authorPhotoUrl: (data['authorPhotoUrl'] as String?) ?? '',
      text: (data['text'] as String?) ?? '',
      imageUrl: (data['imageUrl'] as String?) ?? '',
      // serverTimestamp is null on the local write until the server resolves it.
      createdAt: ts is Timestamp ? ts.toDate() : DateTime.now(),
      likeCount: (data['likeCount'] as num?)?.toInt() ?? 0,
      likedBy: List<String>.from(data['likedBy'] as List<dynamic>? ?? const []),
      commentCount: (data['commentCount'] as num?)?.toInt() ?? 0,
    );
  }
}
