# Social Connect — Master Plan

DevelopersHub internship assignment. A minimal social media platform built in **Flutter**
(the assignment spec is written for React Native; every RN tool is mapped to its Flutter
equivalent). Learning + portfolio piece, built production-grade.

## Spec

**User story:** A user signs up, sets up a profile, posts text/image updates to a shared
feed, likes and comments on posts, views other users' profiles, and gets notified when
others interact with their posts.

**In scope (3 milestones from the doc):**
- Week 1: Auth (sign up / login / forgot password), navigation, profile setup.
- Week 2: Post feed (create text+image, fetch, list, timestamps), like + comment, view
  other users' profiles, global state.
- Week 3: Push notifications, real-time updates, animations, responsive UI, polish.

**Out of scope:** DMs, follow/unfollow graph, search, feed ranking, media beyond images,
moderation tooling.

## Architecture

- **State management:** Riverpod (`flutter_riverpod`). Auth state, feed, likes, comments as
  providers/notifiers. Chosen over Bloc (overkill for this size) and Provider (weaker async).
- **Navigation:** `go_router` — declarative routing with an auth redirect guard +
  `StatefulShellRoute` for the bottom-nav tabs (Stack + Tab equivalent from the doc).
- **Folder structure:** feature-first.
  `lib/features/<feature>/{data,domain,presentation}` + `lib/core` (theme, constants,
  shared widgets) + `lib/app` (root widget + router).
- **Backend:** Firebase — Auth (email/password), Cloud Firestore (users, posts, comments),
  Storage (profile + post images), Cloud Messaging (interaction notifications). Realtime via
  Firestore snapshot streams.
- **Data layer:** repository pattern over Firebase. Each feature owns a repository
  abstracting Firestore/Storage/Auth; providers expose it to the UI.

### Key packages (Flutter ↔ RN spec)
| Concern | Package | RN spec equivalent |
| --- | --- | --- |
| State | flutter_riverpod | Redux / Context API |
| Routing | go_router | React Navigation (Stack + Tab) |
| Backend | firebase_core, firebase_auth, cloud_firestore, firebase_storage | Firebase |
| Push | firebase_messaging | expo-notifications |
| Image pick | image_picker | react-native-image-picker |
| Image cache | cached_network_image | — |
| Dates | intl | — |
| Animations | flutter_animate | reanimated / Lottie |
| Validation | Flutter Form + validators | yup + formik |
| Responsive | MediaQuery / LayoutBuilder | react-native-responsive-dimensions |

## Data model (Firestore)

- `users/{uid}`: name, bio, photoUrl, email, createdAt.
- `posts/{postId}`: authorId, authorName, authorPhotoUrl, text, imageUrl?, createdAt,
  likeCount, likedBy[] (or `posts/{id}/likes/{uid}` subcollection for scale).
- `posts/{postId}/comments/{commentId}`: authorId, authorName, text, createdAt.

## Commit plan (max 9 total, incl. existing Initial commit)

1. **(exists)** Initial commit — Flutter scaffold.
2. **Foundation + Navigation** — Riverpod, go_router, feature-first structure, theme
   (light/dark), bottom-nav shell (Feed/Profile/Settings), welcome screen, docs.
3. **Authentication** — Firebase Auth (sign up / login / forgot password) + form
   validation + route guard. `flutterfire configure` happens here.
4. **Profile setup/edit** — name, bio, profile picture upload (Storage).
5. **Post feed** — create text+image → Firestore, fetch, scrollable list, timestamps.
6. **Like + comment system** — like/unlike, comments screen.
7. **View other users' profiles** — tap author in feed.
8. **Notifications (FCM) + real-time updates** — Firestore streams + push.
9. **Animations + responsive + final polish**.

## Risks & edge cases
- **Firebase config secrets:** `firebase_options.dart`, `google-services.json`,
  `GoogleService-Info.plist` are gitignored — never committed to the public repo.
- **Auth expiry / cold start:** router redirect guard keyed on `authStateChanges()` stream.
- **Empty/error/loading states:** every async screen handles all three (Riverpod `AsyncValue`).
- **Large feed rebuilds:** `ListView.builder` + paginated Firestore queries + cached images.
- **Image upload failures:** show retry; cap image size before upload.
- **Spam/abuse:** Firestore security rules restrict writes to authed users + own documents.
- **Like race conditions:** use Firestore transactions / `FieldValue.increment`.
