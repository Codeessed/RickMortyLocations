import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// A banner showing when the cached data was last updated.
///
/// Displays "Updated X min ago" or "Updated just now" based on
/// the provided [timestamp].
class LastUpdatedBanner extends StatelessWidget {
  final DateTime? timestamp;

  const LastUpdatedBanner({super.key, this.timestamp});

  @override
  Widget build(BuildContext context) {
    if (timestamp == null) return const SizedBox.shrink();

    final ago = DateTime.now().difference(timestamp!);
    final label = _formatDuration(ago);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: AppColors.darkSurface,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.access_time_rounded,
            size: 14,
            color: AppColors.portalGreen.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 6),
          Text(
            'Updated $label',
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inSeconds < 60) return 'just now';
    if (duration.inMinutes < 60) {
      final m = duration.inMinutes;
      return '$m min${m > 1 ? 's' : ''} ago';
    }
    if (duration.inHours < 24) {
      final h = duration.inHours;
      return '$h hour${h > 1 ? 's' : ''} ago';
    }
    final d = duration.inDays;
    return '$d day${d > 1 ? 's' : ''} ago';
  }
}
