import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// A reusable empty state widget with icon and descriptive text.
///
/// Used when a data fetch succeeds but returns zero results.
class EmptyView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  const EmptyView({
    super.key,
    this.icon = Icons.search_off_rounded,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Icon with subtle background ───────────────────────────
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.portalGreen.withValues(alpha: 0.08),
              ),
              child: Icon(
                icon,
                size: 44,
                color: AppColors.textMuted.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 20),

            // ── Title ─────────────────────────────────────────────────
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            // ── Subtitle ──────────────────────────────────────────────
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
