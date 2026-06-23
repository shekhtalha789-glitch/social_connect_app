import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/widgets/user_avatar.dart';
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
    if (author == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Still loading your profile. Try again.')),
      );
      return;
    }

    setState(() => _posting = true);
    try {
      await ref
          .read(feedRepositoryProvider)
          .createPost(author: author, text: _text.text, image: _image);
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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final author = ref.watch(currentUserProfileProvider).asData?.value;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          color: scheme.onSurfaceVariant,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text('New Post', style: theme.textTheme.titleLarge),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: FilledButton(
              onPressed: _canPost ? _submit : null,
              style: FilledButton.styleFrom(
                minimumSize: const Size(72, 40),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: const StadiumBorder(),
              ),
              child: _posting
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Post'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Author anchor
                    if (author != null)
                      Row(
                        children: [
                          UserAvatar(
                            photoUrl: author.photoUrl,
                            initial: author.initial,
                            radius: 20,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                author.name.isEmpty ? 'You' : author.name,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.public,
                                    size: 14,
                                    color: scheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Public',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: scheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _text,
                      maxLines: null,
                      minLines: 4,
                      maxLength: 500,
                      autofocus: true,
                      style: theme.textTheme.bodyLarge,
                      decoration: const InputDecoration(
                        hintText: "What's on your mind?",
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        filled: false,
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    if (_image != null) ...[
                      const SizedBox(height: 16),
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Image.file(_image!, fit: BoxFit.cover),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Material(
                              color: Colors.black54,
                              shape: const CircleBorder(),
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                onTap: () => setState(() => _image = null),
                                child: const Padding(
                                  padding: EdgeInsets.all(6),
                                  child: Icon(
                                    Icons.close,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // Bottom action bar
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: scheme.outlineVariant.withValues(alpha: 0.4),
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: _posting ? null : _pickImage,
                  icon: const Icon(Icons.photo_outlined),
                  label: Text(_image == null ? 'Add photo' : 'Change photo'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
