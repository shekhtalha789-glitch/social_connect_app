import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../viewmodels/home_viewmodel.dart';
import 'widgets/post_card.dart';

/// VIEW
/// Pure UI. It owns a ViewModel, listens to it via ListenableBuilder, and
/// only reads state / calls methods. No business logic lives here.
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeViewModel _viewModel = HomeViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.loadPosts();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.feedTitle)),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_viewModel.error != null) {
            return Center(child: Text(_viewModel.error!));
          }

          return ListView.builder(
            itemCount: _viewModel.posts.length,
            itemBuilder: (context, index) {
              return PostCard(post: _viewModel.posts[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _viewModel.loadPosts,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
