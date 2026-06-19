import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';
import '../data/feed_repository.dart';
import '../domain/comment.dart';
import '../domain/post.dart';

final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  return FeedRepository(
    ref.watch(firebaseFirestoreProvider),
    ref.watch(firebaseStorageProvider),
  );
});

/// Live feed of posts, newest first.
final postsStreamProvider = StreamProvider<List<Post>>((ref) {
  return ref.watch(feedRepositoryProvider).watchPosts();
});

/// Live comments for a given post id.
final commentsStreamProvider =
    StreamProvider.family<List<Comment>, String>((ref, postId) {
  return ref.watch(feedRepositoryProvider).watchComments(postId);
});
