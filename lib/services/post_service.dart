import '../models/post.dart';

/// SERVICE (data source / repository)
/// Where data comes from — an API, database, etc.
/// Here it's faked with a delay so the ViewModel stays realistic.
class PostService {
  Future<List<Post>> fetchPosts() async {
    // Simulate a network call.
    await Future.delayed(const Duration(seconds: 1));

    return const [
      Post(id: 1, author: 'Ali', content: 'Hello from my first post! 👋'),
      Post(id: 2, author: 'Sara', content: 'Loving this new social app.'),
      Post(id: 3, author: 'Zain', content: 'MVVM keeps the code clean.'),
    ];
  }
}
