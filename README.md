# Social Connect

A minimal social media app built with **Flutter** — DevelopersHub Mobile App
Development internship task. Users sign up, manage a profile, post updates, and
interact (like, comment) with other users.

> The assignment brief is written for React Native; this implementation is in
> Flutter, with every RN tool mapped to its Flutter equivalent.

## Stack

| Concern | Choice |
| --- | --- |
| Language / framework | Dart · Flutter |
| State management | Riverpod (`flutter_riverpod`) |
| Navigation | `go_router` (declarative routing + bottom-nav shell) |
| Backend | Firebase — Auth, Cloud Firestore, Storage, Cloud Messaging |
| Images | `image_picker`, `cached_network_image` |
| Dates | `intl` |
| Animations | `flutter_animate` |

## Architecture

Feature-first. Each feature owns its layers:

```
lib/
  app/        # root widget (App) + go_router config
  core/       # theme, constants, shared widgets
  features/
    welcome/  profile/  feed/  home/  settings/
      data/         # repositories + data sources (Firebase)
      domain/       # models
      presentation/ # screens + widgets + Riverpod providers
```

State flows: UI (ConsumerWidget) → Riverpod provider → repository → Firebase.

## Getting started

```bash
flutter pub get
flutter run
```

### Firebase setup (required from the Authentication milestone onward)

Firebase config files are **gitignored** and not part of this repo. To run the
auth/feed features, configure your own Firebase project:

```bash
dart pub global activate flutterfire_cli
flutterfire configure        # generates lib/firebase_options.dart
```

Then in the Firebase console enable **Authentication → Email/Password**, create
**Cloud Firestore**, and enable **Storage** (profile/post images are stored
under `profile_images/{uid}.jpg`). `google-services.json` /
`GoogleService-Info.plist` / `firebase_options.dart` stay local and out of
version control.

The "view user's posts" query needs a Firestore composite index on
`posts (authorId asc, createdAt desc)`. The first time you open another user's
profile, the console logs a one-click link to create it.

### Notifications & real-time

- **Real-time updates** for the feed, likes and comments are already live — every
  screen reads Firestore snapshot streams, so changes appear without a refresh.
- **Push notifications** use Firebase Cloud Messaging. The app requests
  permission and saves each user's FCM token to their `users/{uid}` doc.
  Foreground messages show an in-app banner; background messages appear in the
  system tray.
- **Auto like/comment notifications** are sent by the Cloud Functions in
  [`functions/`](functions/). They trigger on new likes/comments and push to the
  post author's token. Deploy (requires the **Blaze** plan):
  ```bash
  cd functions && npm install && cd ..
  firebase deploy --only functions
  ```
  Without deploying, you can still demo FCM by sending a test message from the
  Firebase console to a device token.

## Build progress

The app is built in small, focused commits (see
[`plans/social-connect-master-plan.md`](plans/social-connect-master-plan.md)):

- [x] Foundation + navigation (Riverpod, go_router, theme, bottom-nav shell)
- [x] Authentication (sign up / login / forgot password + route guard)
- [x] Profile setup/edit (name, bio, profile picture)
- [x] Post feed (create text+image, Firestore, scrollable list, timestamps)
- [x] Like + comment (transactional likes, comments subcollection)
- [x] View other users' profiles (tap an author in the feed)
- [x] Notifications (FCM) + real-time updates (Firestore streams)
- [ ] Animations + responsive polish

## Submission

- Recorded demo video
- Public GitHub repository
- Deadline: 26 June 2026
