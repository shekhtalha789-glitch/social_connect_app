import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

/// User-facing message shown when an image upload fails because Cloud Storage
/// isn't available on the Firebase project (it requires the Blaze plan).
const String storageUpgradeMessage =
    'Image uploads are turned off. Firebase Storage needs the project to be on '
    'the Blaze (pay-as-you-go) plan before photos can be uploaded.';

/// True when [error] is a Cloud Storage failure (vs. a Firestore/other error).
bool isStorageError(Object error) =>
    error is FirebaseException && error.plugin == 'firebase_storage';

/// Shows the Storage/Blaze message for ~7s, or [fallback] for other errors.
void showUploadErrorSnackBar(
  BuildContext context,
  Object error, {
  required String fallback,
}) {
  final storage = isStorageError(error);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(storage ? storageUpgradeMessage : fallback),
      duration: Duration(seconds: storage ? 7 : 4),
    ),
  );
}
