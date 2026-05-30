import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/empty_view.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/last_updated_banner.dart';
import '../../../../shared/widgets/loading_view.dart';
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

    // Listen for pagination errors and show a SnackBar
    ref.listen(locationListNotifierProvider, (prev, next) {
      final wasLoadingMore = prev?.valueOrNull?.isLoadingMore ?? false;
      final stoppedLoadingMore =
          !(next.valueOrNull?.isLoadingMore ?? false);
      // If we were loading more and suddenly stopped without adding items,
      // a pagination error likely occurred
      if (wasLoadingMore &&
          stoppedLoadingMore &&
          (prev?.valueOrNull?.locations.length ==
              next.valueOrNull?.locations.length)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to load more locations'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () {
                ref.read(locationListNotifierProvider.notifier).loadMore();
              },
            ),
          ),
        );
      }
    });

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
              loading: () => const LoadingView(),
              error: (error, _) => ErrorView(
                message: error.toString(),
                onRetry: () =>
                    ref.invalidate(locationListNotifierProvider),
              ),
              data: (state) {
                if (state.locations.isEmpty) {
                  return const EmptyView(
                    icon: Icons.search_off_rounded,
                    title: 'No locations found',
                    subtitle: 'Try a different search or filter',
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
