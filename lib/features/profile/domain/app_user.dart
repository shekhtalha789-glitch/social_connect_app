import 'package:cloud_firestore/cloud_firestore.dart';

/// Domain model for a user profile (the `users/{uid}` document).
class AppUser {
  const AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.bio,
    required this.photoUrl,
  });

  final String uid;
  final String name;
  final String email;
  final String bio;
  final String photoUrl;

  bool get hasPhoto => photoUrl.isNotEmpty;

  /// First letter of the name, used as the avatar fallback.
  String get initial => name.isNotEmpty ? name[0].toUpperCase() : '?';

  factory AppUser.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const {};
    return AppUser(
      uid: doc.id,
      name: (data['name'] as String?) ?? '',
      email: (data['email'] as String?) ?? '',
      bio: (data['bio'] as String?) ?? '',
      photoUrl: (data['photoUrl'] as String?) ?? '',
    );
  }

  AppUser copyWith({String? name, String? bio, String? photoUrl}) {
    return AppUser(
      uid: uid,
      name: name ?? this.name,
      email: email,
      bio: bio ?? this.bio,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
