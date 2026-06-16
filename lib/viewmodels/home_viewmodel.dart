import 'package:flutter/foundation.dart';

import '../models/post.dart';
import '../services/post_service.dart';

/// VIEWMODEL
/// Holds the screen's STATE and the LOGIC to change it.
/// It knows nothing about widgets. The View listens to it via ChangeNotifier
/// and rebuilds whenever notifyListeners() is called.
class HomeViewModel extends ChangeNotifier {
  final PostService _service;

  HomeViewModel({PostService? service}) : _service = service ?? PostService();

  // ----- State (private fields, public getters) -----
  bool _isLoading = false;
  List<Post> _posts = [];
  String? _error;

  bool get isLoading => _isLoading;
  List<Post> get posts => _posts;
  String? get error => _error;

  // ----- Logic -----
  Future<void> loadPosts() async {
    _isLoading = true;
    _error = null;
    notifyListeners(); // tell the View to show a spinner

    try {
      _posts = await _service.fetchPosts();
    } catch (e) {
      _error = 'Failed to load posts';
    }

    _isLoading = false;
    notifyListeners(); // tell the View to show the posts (or the error)
  }
}
