import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../core/theme/app_colors.dart';
import '../providers/location_detail_provider.dart';
import '../widgets/resident_grid.dart';

/// Detail screen showing all location fields and a grid of residents.
class LocationDetailScreen extends ConsumerWidget {
  final int locationId;

  const LocationDetailScreen({super.key, required this.locationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDetail = ref.watch(locationDetailProvider(locationId));

    return Scaffold(
      body: asyncDetail.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.portalGreen),
        ),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.error,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () =>
                      ref.refresh(locationDetailProvider(locationId)),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (detail) {
          final location = detail.location;
          return CustomScrollView(
            slivers: [
              // ── App Bar ──────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 160,
                pinned: true,
                backgroundColor: AppColors.darkBackground,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    location.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.portalGreen.withValues(alpha: 0.3),
                          AppColors.darkBackground,
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.public_rounded,
                        size: 64,
                        color: AppColors.portalGreen,
                      ),
                    ),
                  ),
                ),
              ),

              // ── Info section ─────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoRow(label: 'Type', value: location.type),
                      _InfoRow(label: 'Dimension', value: location.dimension),
                      _InfoRow(
                        label: 'Created',
                        value: _formatDate(location.created),
                      ),
                      _InfoRow(
                        label: 'Residents',
                        value: '${location.residentUrls.length} total',
                      ),
                      const SizedBox(height: 24),

                      // ── Residents heading ────────────────────────
                      if (detail.residents.isNotEmpty) ...[
                        const Text(
                          'Residents',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ],
                  ),
                ),
              ),

              // ── Resident grid ────────────────────────────────────
              SliverToBoxAdapter(
                child: ResidentGrid(residents: detail.residents),
              ),

              // Bottom padding
              const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }
}

/// A label–value row used in the location info section.
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
