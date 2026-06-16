/// MODEL
/// A plain data class. Holds data only — no UI, no business logic.
class Post {
  final int id;
  final String author;
  final String content;

  const Post({
    required this.id,
    required this.author,
    required this.content,
  });
}
