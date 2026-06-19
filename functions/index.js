/**
 * Social Connect — Cloud Functions
 *
 * Sends a push notification to a post's author when someone likes or comments
 * on their post. The Flutter app stores each user's FCM token on their
 * users/{uid} document; these triggers read it and send via FCM.
 */
const {
  onDocumentUpdated,
  onDocumentCreated,
} = require("firebase-functions/v2/firestore");
const {initializeApp} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");
const {getMessaging} = require("firebase-admin/messaging");

initializeApp();
const db = getFirestore();

/** Sends a notification to a single user if they have a saved FCM token. */
async function notifyUser(uid, title, body) {
  if (!uid) return;
  const userSnap = await db.collection("users").doc(uid).get();
  const token = userSnap.get("fcmToken");
  if (!token) return;
  await getMessaging().send({token, notification: {title, body}});
}

/** Notify the author when a new like is added to their post. */
exports.onPostLiked = onDocumentUpdated("posts/{postId}", async (event) => {
  const before = event.data.before.data() || {};
  const after = event.data.after.data() || {};
  const beforeLikes = before.likedBy || [];
  const afterLikes = after.likedBy || [];
  if (afterLikes.length <= beforeLikes.length) return; // not a new like

  const likerId = afterLikes.find((uid) => !beforeLikes.includes(uid));
  if (!likerId || likerId === after.authorId) return; // ignore self-likes

  const likerSnap = await db.collection("users").doc(likerId).get();
  const likerName = likerSnap.get("name") || "Someone";
  await notifyUser(after.authorId, "New like", `${likerName} liked your post`);
});

/** Notify the post author when someone comments. */
exports.onPostCommented = onDocumentCreated(
    "posts/{postId}/comments/{commentId}",
    async (event) => {
      const comment = event.data.data() || {};
      const postSnap = await db
          .collection("posts")
          .doc(event.params.postId)
          .get();
      const authorId = postSnap.get("authorId");
      if (!authorId || authorId === comment.authorId) return; // ignore self

      const name = comment.authorName || "Someone";
      await notifyUser(authorId, "New comment", `${name} commented on your post`);
    },
);
