import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/adaptive_layout.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/loading_view.dart';
import '../providers/location_detail_provider.dart';
import '../widgets/resident_grid.dart';

/// Detail screen for a single location.
///
/// Layout:
/// - Mobile / Tablet (< 900px): stacked [CustomScrollView]
///   SliverAppBar → info section → resident grid
///
/// - Desktop (≥ 900px): two-pane [Row]
///   Left pane (fixed 380px): back button + info section + scroll
///   Right pane (flex): resident grid with more columns
class LocationDetailScreen extends ConsumerWidget {
  final int locationId;

  const LocationDetailScreen({super.key, required this.locationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDetail = ref.watch(locationDetailProvider(locationId));

    return AdaptiveLayout(
      mobile: (_) => _MobileDetailView(
        asyncDetail: asyncDetail,
        locationId: locationId,
        onRetry: () => ref.invalidate(locationDetailProvider(locationId)),
      ),
      tablet: (_) => _MobileDetailView(
        asyncDetail: asyncDetail,
        locationId: locationId,
        onRetry: () => ref.invalidate(locationDetailProvider(locationId)),
      ),
      desktop: (_) => _DesktopDetailView(
        asyncDetail: asyncDetail,
        locationId: locationId,
        onRetry: () => ref.invalidate(locationDetailProvider(locationId)),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Mobile layout — SliverAppBar + stacked content
// ══════════════════════════════════════════════════════════════════════════════

class _MobileDetailView extends StatelessWidget {
  final AsyncValue<LocationDetailState> asyncDetail;
  final int locationId;
  final VoidCallback onRetry;

  const _MobileDetailView({
    required this.asyncDetail,
    required this.locationId,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: asyncDetail.when(
        loading: () => CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 160,
              pinned: true,
              backgroundColor: AppColors.darkBackground,
              flexibleSpace: FlexibleSpaceBar(
                background: _GradientHeader(expanded: true),
              ),
            ),
            const SliverFillRemaining(child: LoadingView(itemCount: 3)),
          ],
        ),
        error: (error, _) => CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: AppColors.darkBackground,
            ),
            SliverFillRemaining(
              child: ErrorView(message: error.toString(), onRetry: onRetry),
            ),
          ],
        ),
        data: (detail) {
          final location = detail.location;
          return CustomScrollView(
            slivers: [
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
                  background: _GradientHeader(expanded: true),
                ),
              ),
              SliverToBoxAdapter(
                child: _InfoSection(detail: detail),
              ),
              SliverToBoxAdapter(
                child: ResidentGrid(residents: detail.residents),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
            ],
          );
        },
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Desktop layout — two-pane Row
// ══════════════════════════════════════════════════════════════════════════════

class _DesktopDetailView extends StatelessWidget {
  final AsyncValue<LocationDetailState> asyncDetail;
  final int locationId;
  final VoidCallback onRetry;

  const _DesktopDetailView({
    required this.asyncDetail,
    required this.locationId,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: asyncDetail.when(
        loading: () => const Center(
          child: LoadingView(itemCount: 3),
        ),
        error: (error, _) => ErrorView(
          message: error.toString(),
          onRetry: onRetry,
        ),
        data: (detail) {
          final location = detail.location;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Left pane: location info (fixed width) ────────────
              SizedBox(
                width: 380,
                child: Column(
                  children: [
                    // Gradient hero with icon
                    Stack(
                      children: [
                        _GradientHeader(expanded: false, name: location.name),
                        Positioned(
                          top: 16,
                          left: 16,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                            tooltip: 'Back',
                            onPressed: () {
                              if (context.canPop()) {
                                context.pop();
                              } else {
                                context.go('/');
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    // Info section is scrollable independently
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: _InfoSection(detail: detail),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Vertical divider ──────────────────────────────────
              VerticalDivider(
                width: 1,
                thickness: 1,
                color: AppColors.divider.withValues(alpha: 0.4),
              ),

              // ── Right pane: resident grid (flexible) ──────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                      child: Row(
                        children: [
                          const Text(
                            'Residents',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (detail.residents.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.portalGreen
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${detail.residents.length}',
                                style: const TextStyle(
                                  color: AppColors.portalGreen,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                        child: detail.residents.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.only(top: 40),
                                child: Center(
                                  child: Text(
                                    'No residents recorded',
                                    style: TextStyle(
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ),
                              )
                            : ResidentGrid(residents: detail.residents),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Shared components
// ══════════════════════════════════════════════════════════════════════════════

/// Portal-green gradient header used in both mobile (SliverAppBar background)
/// and desktop (top of the left pane).
class _GradientHeader extends StatelessWidget {
  final bool expanded;
  final String? name;

  const _GradientHeader({required this.expanded, this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: expanded ? null : 160,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.portalGreen.withValues(alpha: 0.35),
            AppColors.darkBackground,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.public_rounded,
              size: 56,
              color: AppColors.portalGreen,
            ),
            if (name != null) ...[
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  name!,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Info rows (Type, Dimension, Created, Residents count).
/// Extracted so it can be embedded in both mobile sliver and desktop pane.
class _InfoSection extends StatelessWidget {
  final LocationDetailState detail;

  const _InfoSection({required this.detail});

  @override
  Widget build(BuildContext context) {
    final location = detail.location;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(label: 'Type', value: location.type),
          _InfoRow(label: 'Dimension', value: location.dimension),
          _InfoRow(
            label: 'Created',
            value: DateFormat('MMM d, yyyy').format(location.created),
          ),
          _InfoRow(
            label: 'Residents',
            value: '${location.residentUrls.length} total',
          ),
          const SizedBox(height: 24),
          // On mobile the residents heading lives here, just before the grid.
          // On desktop the heading is in the right-pane header.
          if (detail.residents.isNotEmpty)
            const Text(
              'Residents',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}

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
