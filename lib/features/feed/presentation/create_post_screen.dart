import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../profile/presentation/profile_providers.dart';
import 'feed_providers.dart';

/// Compose a new post: text with an optional image.
class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _text = TextEditingController();
  final _picker = ImagePicker();
  File? _image;
  bool _posting = false;

  @override
  void initState() {
    super.initState();
    // Enable/disable the Post button as the user types.
    _text.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  bool get _canPost =>
      !_posting && (_text.text.trim().isNotEmpty || _image != null);

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 80,
    );
    if (picked != null) setState(() => _image = File(picked.path));
  }

  Future<void> _submit() async {
    final author = ref.read(currentUserProfileProvider).asData?.value;
    if (author == null) return;

    setState(() => _posting = true);
    try {
      await ref.read(feedRepositoryProvider).createPost(
            author: author,
            text: _text.text,
            image: _image,
          );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not publish post. Try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _posting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Post'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: FilledButton(
              onPressed: _canPost ? _submit : null,
              child: _posting
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Post'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _text,
                maxLines: 6,
                maxLength: 500,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "What's on your mind?",
                  border: InputBorder.none,
                  counterText: '',
                ),
              ),
              if (_image != null) ...[
                const SizedBox(height: 12),
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(_image!, fit: BoxFit.cover),
                    ),
                    IconButton.filled(
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => _image = null),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: _posting ? null : _pickImage,
                  icon: const Icon(Icons.image_outlined),
                  label: Text(_image == null ? 'Add photo' : 'Change photo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
