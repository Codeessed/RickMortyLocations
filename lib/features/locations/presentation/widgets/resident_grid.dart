import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../domain/entities/character.dart';

/// A grid of resident character avatars with name and status badge.
///
/// Adapts columns based on available width:
/// - < 600px → 3 columns
/// - ≥ 600px → 6 columns
class ResidentGrid extends StatelessWidget {
  final List<Character> residents;

  const ResidentGrid({super.key, required this.residents});

  @override
  Widget build(BuildContext context) {
    if (residents.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: Text(
            'No residents found',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 600 ? 6 : 3;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemCount: residents.length,
          itemBuilder: (context, index) =>
              _ResidentChip(character: residents[index]),
        );
      },
    );
  }
}

/// A single resident chip: circular avatar, name, and status badge.
class _ResidentChip extends StatelessWidget {
  final Character character;

  const _ResidentChip({required this.character});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Avatar ─────────────────────────────────────────────────
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: CachedNetworkImage(
            imageUrl: character.image,
            width: 64,
            height: 64,
            fit: BoxFit.cover,
            placeholder: (_, _) => Container(
              width: 64,
              height: 64,
              color: AppColors.darkSurface,
              child: const Icon(
                Icons.person,
                color: AppColors.textMuted,
                size: 28,
              ),
            ),
            errorWidget: (_, _, _) => Container(
              width: 64,
              height: 64,
              color: AppColors.darkSurface,
              child: const Icon(
                Icons.broken_image_rounded,
                color: AppColors.textMuted,
                size: 28,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),

        // ── Name ───────────────────────────────────────────────────
        Text(
          character.name,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 3),

        // ── Status ─────────────────────────────────────────────────
        StatusBadge(status: character.status),
      ],
    );
  }
}
