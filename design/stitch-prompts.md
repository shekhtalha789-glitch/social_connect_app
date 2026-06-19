# Social Connect — Stitch UI Prompts

Copy-paste prompts for [Google Stitch](https://stitch.withgoogle.com) to generate
a consistent, modern UI for every screen in the app. These describe the **same
screens that already exist in code**, so the generated designs map 1:1 to the
build.

## How to use
1. Start a **Mobile** project in Stitch.
2. Paste **Prompt 0 (Design System)** first — it sets the theme. Generate.
3. For each screen, paste its prompt. Start each with “Using the same design
   system, theme, colors and components as before,” so Stitch stays consistent.
4. Generate light mode first; then re-prompt “same screen in dark mode” for the
   dark variants (the app supports system light/dark).

---

## Prompt 0 — Design System (set the theme first)

```
Design a modern, clean mobile UI design system for a minimal social media app
called "Social Connect". Friendly, polished, and uncluttered — think a refined
take on Material 3 / Material You.

Brand & color:
- Primary: indigo-violet #5B5BD6 (used for primary buttons, active icons, links).
- Like/active accent: red #E53935 for the liked heart.
- Light theme: background #FFFFFF, surfaces/cards #F6F6FB, dividers #ECECF2.
- Dark theme: background #121218, surfaces/cards #1E1E26, text #ECECF2.
- Text: near-black #1A1A1F on light; soft white on dark. Muted secondary text
  in cool gray.

Typography: clean geometric sans-serif (Inter / SF Pro style). Bold headlines,
medium section titles, regular body, small muted captions.

Components:
- Primary button: full-width, filled indigo, 12px corner radius, ~52px tall,
  white label.
- Secondary button: full-width outlined, same size, indigo label.
- Text button / links: indigo, no fill.
- Text fields: outlined, rounded corners, floating label, clear focus state.
- Cards: rounded 16px, very soft shadow, comfortable padding.
- Avatars: circular; when no photo, a colored circle (light indigo) with the
  user's first initial in bold.
- Bottom navigation bar: 3 tabs, outline icon when inactive, filled icon +
  indigo tint when active.
- Floating action button: extended pill style with icon + label.

Spacing is generous (16–24px). Rounded, soft, modern, accessible with good
contrast. Avoid clutter and heavy borders.
```

---

## Prompt 1 — Welcome / Onboarding

```
Using the same design system, design a Welcome screen for "Social Connect".
Centered vertically: a large friendly app icon (people-connecting glyph) in
indigo, the app name "Social Connect" in bold below it, and a one-line tagline
"Share moments. Connect with people." in muted text.
At the bottom: a full-width filled indigo "Log In" button, and below it a
full-width outlined "Create account" button. Clean, airy, lots of whitespace.
```

## Prompt 2 — Log In

```
Using the same design system, design a Log In screen.
Top app bar titled "Log In" (centered). Body: a bold heading "Welcome back",
then an outlined "Email" text field, then a "Password" field with a show/hide
eye icon on the right. A right-aligned "Forgot password?" text link beneath the
password. A full-width filled indigo "Log In" button. At the very bottom, a
centered row: "Don't have an account?" followed by a "Sign Up" text link.
```

## Prompt 3 — Sign Up

```
Using the same design system, design a Sign Up screen.
Top app bar titled "Create Account". Body: bold heading "Join Social Connect",
then outlined fields in order: "Name", "Email", "Password" (with show/hide eye
icon), and "Confirm password". A full-width filled indigo "Sign Up" button.
Bottom centered row: "Already have an account?" with a "Log In" text link.
```

## Prompt 4 — Forgot Password

```
Using the same design system, design a Reset Password screen.
App bar titled "Reset Password". Body: short helper text "Enter your email and
we'll send you a link to reset your password.", an outlined "Email" field, and a
full-width filled "Send reset link" button.
Also design the success state: a large email/check icon in indigo, a title
"Check your inbox", a line "We sent a reset link to your email.", and a
full-width "Back to login" button.
```

## Prompt 5 — Feed (home)

```
Using the same design system, design the main Feed screen of a social app.
Top app bar titled "Feed" (centered). Body: a vertically scrolling list of post
cards (see the Post Card prompt). Bottom: a 3-tab bottom navigation bar — Feed
(active, filled feed icon, indigo), Profile (person icon), Settings (gear icon).
A floating extended action button bottom-right: pencil icon + "Post" label in
indigo.
Also design the empty state: a centered forum/chat icon in indigo, "No posts
yet" title, and muted subtitle "Be the first to share something."
```

## Prompt 6 — Post Card (component)

```
Using the same design system, design a single social Post Card component (rounded
16px card, soft shadow).
Header row: circular user avatar on the left, the author's name in semibold, and
a small muted relative timestamp under it (e.g. "3h"). Below the header: the post
text in regular body size. Optionally a full-width rounded post image beneath the
text. Bottom action row with two text buttons: a heart icon + like count
("Like" when zero), and a comment-bubble icon + comment count ("Comment" when
zero). Show one variant with the heart filled red (liked) and one outlined
(not liked). The whole header (avatar + name) looks tappable.
```

## Prompt 7 — Create Post

```
Using the same design system, design a Create Post screen.
App bar titled "New Post" with a small filled indigo "Post" button in the top-
right corner. Body: a large borderless multiline text area with placeholder
"What's on your mind?". Below it (when an image is attached) a rounded image
preview with a small circular close/remove button in its top-right corner. At the
bottom-left, a text button with an image icon labeled "Add photo".
```

## Prompt 8 — Comments

```
Using the same design system, design a Comments screen.
App bar titled "Comments". Body: a scrolling list of comments — each row has a
small circular avatar, the commenter's name in semibold with a small muted
timestamp beside it, and the comment text below. Pinned at the bottom: a comment
input bar with an outlined rounded text field ("Add a comment…") and a circular
indigo send button to its right.
Also design the empty state: centered muted text "No comments yet. Start the
conversation."
```

## Prompt 9 — My Profile

```
Using the same design system, design a user's own Profile screen.
App bar titled "Profile" with an edit (pencil) icon button in the top-right.
Body, centered: a large circular avatar, the user's name in a bold headline, the
email in muted text below. Then a left-aligned "About" section title and the
user's bio text beneath it. Calm, spacious layout.
```

## Prompt 10 — Edit Profile

```
Using the same design system, design an Edit Profile screen.
App bar titled "Edit Profile". Centered at top: a large circular avatar with a
small circular indigo camera button overlapping its bottom-right corner (to
change the photo). Below: an outlined "Name" field, then a multiline outlined
"Bio" field with a character counter. A full-width filled indigo "Save" button.
```

## Prompt 11 — Other User's Profile

```
Using the same design system, design a public profile screen for viewing another
user.
App bar titled with the user's name. Top: a centered large circular avatar, the
user's name in bold, and their bio text below. A divider, then a left-aligned
"Posts" section title, followed by a vertical list of that user's post cards
(same Post Card component).
```

## Prompt 12 — Settings

```
Using the same design system, design a Settings screen.
App bar titled "Settings". Body: a list. First a non-tappable account row with a
person icon, the user's display name as the title and their email as the
subtitle. A divider. Then a tappable "Sign out" row with a logout icon.
Also design a "Sign out?" confirmation dialog with the message "You can log back
in any time." and two actions: a "Cancel" text button and a filled "Sign out"
button.
```

---

## Consistency checklist for the generated UI
- Same indigo primary (#5B5BD6) and red like-accent everywhere.
- Same button shapes (full-width, 12px radius, ~52px tall).
- Same circular avatars with initial fallback.
- Same rounded 16px cards and outlined text fields.
- Same 3-tab bottom nav (Feed / Profile / Settings).
- Generate a light and a dark variant of each screen.

## Screen → code map (so the new UI drops into the build)
| Screen | File |
| --- | --- |
| Welcome | `lib/features/welcome/presentation/welcome_screen.dart` |
| Log In | `lib/features/auth/presentation/login_screen.dart` |
| Sign Up | `lib/features/auth/presentation/signup_screen.dart` |
| Reset Password | `lib/features/auth/presentation/forgot_password_screen.dart` |
| Feed + bottom nav | `lib/features/feed/presentation/feed_screen.dart`, `lib/features/home/presentation/home_shell.dart` |
| Post Card | `lib/features/feed/presentation/widgets/post_card.dart`, `like_button.dart` |
| Create Post | `lib/features/feed/presentation/create_post_screen.dart` |
| Comments | `lib/features/feed/presentation/comments_screen.dart` |
| My Profile | `lib/features/profile/presentation/profile_screen.dart` |
| Edit Profile | `lib/features/profile/presentation/edit_profile_screen.dart` |
| Other Profile | `lib/features/profile/presentation/user_profile_screen.dart` |
| Settings | `lib/features/settings/presentation/settings_screen.dart` |
| Theme tokens | `lib/core/theme/app_theme.dart` |
| Avatar component | `lib/core/widgets/user_avatar.dart` |
```
