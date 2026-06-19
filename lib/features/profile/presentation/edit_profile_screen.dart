import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/validators.dart';
import '../../../core/widgets/responsive_center.dart';
import '../../../core/widgets/user_avatar.dart';
import 'profile_providers.dart';

/// Create / edit the signed-in user's profile: name, bio and profile picture.
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _bio = TextEditingController();
  final _picker = ImagePicker();

  File? _pickedImage;
  bool _saving = false;
  bool _prefilled = false;

  @override
  void dispose() {
    _name.dispose();
    _bio.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save(String uid) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final repo = ref.read(profileRepositoryProvider);
      String? photoUrl;
      if (_pickedImage != null) {
        photoUrl = await repo.uploadPhoto(uid, _pickedImage!);
      }
      await repo.updateProfile(
        uid: uid,
        name: _name.text,
        bio: _bio.text,
        photoUrl: photoUrl,
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Profile updated')));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not save profile. Try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileAsync = ref.watch(currentUserProfileProvider);
    final user = profileAsync.asData?.value;

    // Prefill the form once from the existing profile.
    if (!_prefilled && user != null) {
      _name.text = user.name;
      _bio.text = user.bio;
      _prefilled = true;
    }

    final uid = user?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: uid == null
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ResponsiveCenter(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(child: _buildAvatar(context, user!)),
                        const SizedBox(height: 12),
                        Text(
                          'Change Profile Picture',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _name,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(labelText: 'Name'),
                          validator: Validators.name,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _bio,
                          maxLines: 5,
                          maxLength: 250,
                          decoration: const InputDecoration(
                            labelText: 'Bio',
                            hintText: 'Tell us about yourself…',
                            alignLabelWithHint: true,
                          ),
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: _saving ? null : () => _save(uid),
                          child: _saving
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Save'),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'All changes are immediately reflected on your '
                          'public profile.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildAvatar(BuildContext context, dynamic user) {
    final scheme = Theme.of(context).colorScheme;
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: scheme.primaryContainer.withValues(alpha: 0.10),
              width: 4,
            ),
          ),
          child: _pickedImage != null
              ? CircleAvatar(radius: 56, backgroundImage: FileImage(_pickedImage!))
              : UserAvatar(
                  photoUrl: user.photoUrl,
                  initial: user.initial,
                  radius: 56,
                ),
        ),
        Positioned(
          right: 4,
          bottom: 4,
          child: Material(
            color: scheme.primaryContainer,
            shape: CircleBorder(
              side: BorderSide(color: scheme.surface, width: 2),
            ),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _saving ? null : _showImageSourceSheet,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.photo_camera,
                  size: 18,
                  color: scheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
