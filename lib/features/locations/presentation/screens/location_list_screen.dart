import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/last_updated_banner.dart';
import '../providers/location_providers.dart';
import '../widgets/location_card.dart';
import '../widgets/search_filter_bar.dart';

/// Paginated list of Rick & Morty locations with infinite scroll,
/// search by name, and filter by type.
class LocationListScreen extends ConsumerStatefulWidget {
  const LocationListScreen({super.key});

  @override
  ConsumerState<LocationListScreen> createState() =>
      _LocationListScreenState();
}

class _LocationListScreenState extends ConsumerState<LocationListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    // Trigger load-more when within 200px of the bottom
    if (currentScroll >= maxScroll - 200) {
      ref.read(locationListNotifierProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(locationListNotifierProvider);
    final lastUpdatedAsync = ref.watch(lastCachedAtProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Locations'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              Icons.public_rounded,
              color: AppColors.portalGreen.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Last updated banner ───────────────────────────────────
          LastUpdatedBanner(
            timestamp: lastUpdatedAsync.valueOrNull,
          ),

          // ── Search & filter bar ──────────────────────────────────
          const SearchFilterBar(),

          const SizedBox(height: 4),

          // ── Location list ────────────────────────────────────────
          Expanded(
            child: asyncState.when(
              loading: () => const Center(
                child:
                    CircularProgressIndicator(color: AppColors.portalGreen),
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
                        style:
                            const TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () =>
                            ref.refresh(locationListNotifierProvider),
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (state) {
                if (state.locations.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 56,
                          color: AppColors.textMuted.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No locations found',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Try a different search or filter',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  color: AppColors.portalGreen,
                  onRefresh: () async {
                    ref.invalidate(locationListNotifierProvider);
                    ref.invalidate(lastCachedAtProvider);
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(top: 4, bottom: 80),
                    itemCount: state.locations.length +
                        (state.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Loading indicator at the bottom
                      if (index == state.locations.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.portalGreen,
                              strokeWidth: 2.5,
                            ),
                          ),
                        );
                      }

                      final location = state.locations[index];
                      return LocationCard(
                        location: location,
                        onTap: () =>
                            context.go('/location/${location.id}'),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
