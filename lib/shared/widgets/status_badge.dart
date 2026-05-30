import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// A colored badge indicating a character's status (Alive, Dead, Unknown).
class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: _color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            status,
            style: TextStyle(
              color: _color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color get _color {
    switch (status.toLowerCase()) {
      case 'alive':
        return AppColors.statusAlive;
      case 'dead':
        return AppColors.statusDead;
      default:
        return AppColors.statusUnknown;
    }
  }
}
