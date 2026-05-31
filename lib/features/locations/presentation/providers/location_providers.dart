import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/location_remote_datasource.dart';
import '../../data/repositories/location_repository_impl.dart';
import '../../domain/entities/location.dart';
import 'search_filter_provider.dart';

part 'location_providers.g.dart';

// ── Infrastructure Providers ───────────────────────────────────────────

/// Provides the Retrofit-based remote data source.
@Riverpod(keepAlive: true)
LocationRemoteDataSource locationRemoteDataSource(Ref ref) {
  return LocationRemoteDataSource(ref.watch(dioProvider));
}

/// Provides the repository implementation with caching.
@Riverpod(keepAlive: true)
LocationRepositoryImpl locationRepository(Ref ref) {
  return LocationRepositoryImpl(
    remote: ref.watch(locationRemoteDataSourceProvider),
    locationDao: ref.watch(locationDaoProvider),
    characterDao: ref.watch(characterDaoProvider),
  );
}

/// Provides the last-cached-at timestamp as a reactive stream.
@riverpod
Stream<DateTime?> lastCachedAt(Ref ref) {
  // Re-emit when the repository changes cache
  final repo = ref.watch(locationRepositoryProvider);
  return Stream.fromFuture(repo.getLastCachedAt());
}

/// Provides distinct location types for the filter dropdown.
@Riverpod(keepAlive: true)
Stream<List<String>> locationTypes(Ref ref) {
  final repo = ref.watch(locationRepositoryProvider);
  return repo.watchDistinctTypes();
}

// ── Location List State ────────────────────────────────────────────────

/// Holds the full state for the paginated location list.
class LocationListState {
  final List<Location> locations;
  final int currentPage;
  final bool hasNextPage;
  final bool isLoadingMore;

  const LocationListState({
    this.locations = const [],
    this.currentPage = 0,
    this.hasNextPage = true,
    this.isLoadingMore = false,
  });

  LocationListState copyWith({
    List<Location>? locations,
    int? currentPage,
    bool? hasNextPage,
    bool? isLoadingMore,
  }) {
    return LocationListState(
      locations: locations ?? this.locations,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

/// Manages the paginated location list with infinite scroll support.
///
/// Reacts to [SearchFilterNotifier] changes — when filters change,
/// the list is re-fetched from page 1 with both name and type params.
@Riverpod(keepAlive: true)
class LocationListNotifier extends _$LocationListNotifier {
  @override
  Future<LocationListState> build() async {
    // Watch the filter state — whenever it changes, this provider rebuilds
    final filters = ref.watch(searchFilterNotifierProvider);
    return _fetchPage(
      1,
      name: filters.name,
      type: filters.type,
    );
  }

  /// Loads the next page of locations. No-op if already loading or
  /// there are no more pages.
  Future<void> loadMore() async {
    final currentState = state.valueOrNull;
    if (currentState == null ||
        currentState.isLoadingMore ||
        !currentState.hasNextPage) {
      return;
    }

    // Signal "loading more" without erasing existing data
    state = AsyncData(currentState.copyWith(isLoadingMore: true));

    try {
      final filters = ref.read(searchFilterNotifierProvider);
      final nextPage = currentState.currentPage + 1;
      final page = await ref.read(locationRepositoryProvider).getLocations(
            page: nextPage,
            name: filters.name.isNotEmpty ? filters.name : null,
            type: filters.type.isNotEmpty ? filters.type : null,
          );

      state = AsyncData(
        currentState.copyWith(
          locations: [...currentState.locations, ...page.locations],
          currentPage: nextPage,
          hasNextPage: page.hasNextPage,
          isLoadingMore: false,
        ),
      );
    } catch (_) {
      // Pagination error: keep existing data, just stop loading indicator
      state = AsyncData(currentState.copyWith(isLoadingMore: false));
    }
  }

  Future<LocationListState> _fetchPage(
    int page, {
    String? name,
    String? type,
  }) async {
    final result = await ref.read(locationRepositoryProvider).getLocations(
          page: page,
          name: name?.isNotEmpty == true ? name : null,
          type: type?.isNotEmpty == true ? type : null,
        );

    return LocationListState(
      locations: result.locations,
      currentPage: page,
      hasNextPage: result.hasNextPage,
    );
  }
}
