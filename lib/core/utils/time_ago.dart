import 'package:intl/intl.dart';

/// Compact relative timestamp for the feed, e.g. "just now", "5m", "3h", "2d",
/// then an absolute date for anything older than a week.
String timeAgo(DateTime date) {
  final diff = DateTime.now().difference(date);

  if (diff.inSeconds < 60) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m';
  if (diff.inHours < 24) return '${diff.inHours}h';
  if (diff.inDays < 7) return '${diff.inDays}d';

  final now = DateTime.now();
  final pattern = date.year == now.year ? 'MMM d' : 'MMM d, yyyy';
  return DateFormat(pattern).format(date);
}
