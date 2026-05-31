import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/adaptive_layout.dart';
import '../../../../shared/widgets/empty_view.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/last_updated_banner.dart';
import '../../../../shared/widgets/loading_view.dart';
import '../providers/location_providers.dart';
import '../providers/search_filter_provider.dart';
import '../widgets/location_card.dart';
import '../widgets/search_filter_bar.dart';

/// Paginated list of Rick & Morty locations.
///
/// Layout:
/// - Mobile (< 600px)   → single-column [ListView]
/// - Tablet (≥ 600px)   → 2-column [GridView]
/// - Desktop (≥ 900px)  → 3-column [GridView], no AppBar (shell owns it)
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

  @override
  void deactivate() {
    ScaffoldMessenger.maybeOf(context)?.clearSnackBars();
    super.deactivate();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll - 200) {
      ref.read(locationListNotifierProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(locationListNotifierProvider);
    final lastUpdatedAsync = ref.watch(lastCachedAtProvider);
    final filters = ref.watch(searchFilterNotifierProvider);
    final desktop = isDesktop(context);
    final scrollKey = PageStorageKey('locations_scroll_${filters.name}_${filters.type}');

    // Listen for pagination errors
    ref.listen(locationListNotifierProvider, (prev, next) {
      final wasLoadingMore = prev?.valueOrNull?.isLoadingMore ?? false;
      final isNowLoadingMore = next.valueOrNull?.isLoadingMore ?? false;

      // Clear any existing snackbar when we start loading again
      if (!wasLoadingMore && isNowLoadingMore) {
        ScaffoldMessenger.of(context).clearSnackBars();
      }

      final stoppedLoadingMore = !isNowLoadingMore;
      if (wasLoadingMore &&
          stoppedLoadingMore &&
          (prev?.valueOrNull?.locations.length ==
              next.valueOrNull?.locations.length) &&
          (next.valueOrNull?.hasNextPage ?? false)) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            SnackBar(
              content: const Text('Failed to load more locations'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: () =>
                    ref.read(locationListNotifierProvider.notifier).loadMore(),
              ),
            ),
          );
      }
    });

    return Scaffold(
      // On desktop the NavigationRail header serves as branding — keep AppBar
      // but remove the redundant globe icon it showed before.
      appBar: AppBar(
        title: const Text('Locations'),
        // Hide the app bar on desktop — shell provides the persistent chrome
        toolbarHeight: desktop ? 0 : kToolbarHeight,
        actions: desktop
            ? null
            : [
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
          // Desktop gets a proper page heading inside the content area
          if (desktop)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                children: [
                  const Text(
                    'Locations',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  // Last updated inline on desktop — no banner strip
                  if (lastUpdatedAsync.valueOrNull != null)
                    LastUpdatedBanner(
                      timestamp: lastUpdatedAsync.valueOrNull,
                    ),
                ],
              ),
            ),

          // On mobile, show the banner as a full-width strip
          if (!desktop)
            SizedBox(
              width: double.infinity,
              child: LastUpdatedBanner(timestamp: lastUpdatedAsync.valueOrNull),
            ),

          const SearchFilterBar(),
          const SizedBox(height: 4),

          Expanded(
            child: asyncState.when(
              loading: () => const LoadingView(),
              error: (error, _) => SingleChildScrollView(
                child: ErrorView(
                  message: error.toString(),
                  onRetry: () => ref.invalidate(locationListNotifierProvider),
                ),
              ),
              data: (state) {
                if (state.locations.isEmpty) {
                  return SingleChildScrollView(
                    child: EmptyView(
                      icon: Icons.search_off_rounded,
                      title: 'No locations found',
                      subtitle: 'Try a different search or filter',
                    ),
                  );
                }

                return RefreshIndicator(
                  color: AppColors.portalGreen,
                  onRefresh: () async {
                    ref.invalidate(locationListNotifierProvider);
                    ref.invalidate(lastCachedAtProvider);
                  },
                  child: AdaptiveLayout(
                    // ── Mobile: single-column list ─────────────────
                    mobile: (_) => ListView.builder(
                      key: scrollKey,
                      controller: _scrollController,
                      padding: const EdgeInsets.only(top: 4, bottom: 80),
                      itemCount: state.locations.length +
                          (state.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) =>
                          _buildListItem(context, state, index),
                    ),
                    // ── Tablet: 2-column grid ──────────────────────
                    tablet: (_) => _AdaptiveGrid(
                      key: scrollKey,
                      crossAxisCount: 2,
                      scrollController: _scrollController,
                      state: state,
                      onTap: (loc) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        context.push('/location/${loc.id}');
                      },
                    ),
                    // ── Desktop: 3-column grid ─────────────────────
                    desktop: (_) => _AdaptiveGrid(
                      key: scrollKey,
                      crossAxisCount: 3,
                      scrollController: _scrollController,
                      state: state,
                      onTap: (loc) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        context.push('/location/${loc.id}');
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, LocationListState state,
      int index) {
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
      onTap: () {
        ScaffoldMessenger.of(context).clearSnackBars();
        context.push('/location/${location.id}');
      },
    );
  }
}

/// A [GridView] layout used for tablet and desktop widths.
///
/// Renders [LocationCard] tiles in a grid with [crossAxisCount] columns.
/// Shows a [CircularProgressIndicator] as the last item while loading more.
class _AdaptiveGrid extends StatelessWidget {
  final int crossAxisCount;
  final ScrollController scrollController;
  final LocationListState state;
  final void Function(dynamic) onTap;

  const _AdaptiveGrid({
    super.key,
    required this.crossAxisCount,
    required this.scrollController,
    required this.state,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final padding = crossAxisCount == 3
        ? const EdgeInsets.fromLTRB(24, 8, 24, 80)
        : const EdgeInsets.fromLTRB(16, 8, 16, 80);

    return GridView.builder(
      key: key,
      controller: scrollController,
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        // Cards are wider than tall on desktop — adjust aspect ratio
        childAspectRatio: crossAxisCount == 3 ? 2.2 : 2.0,
      ),
      itemCount:
          state.locations.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.locations.length) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.portalGreen,
              strokeWidth: 2.5,
            ),
          );
        }
        final location = state.locations[index];
        return LocationCard(
          location: location,
          onTap: () => onTap(location),
        );
      },
    );
  }
}
