import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/location_remote_datasource.dart';
import '../../data/repositories/location_repository_impl.dart';
import '../../domain/entities/location.dart';
import '../../domain/repositories/location_repository.dart';

part 'location_providers.g.dart';

// ── Infrastructure Providers ───────────────────────────────────────────

/// Provides the Retrofit-based remote data source.
@Riverpod(keepAlive: true)
LocationRemoteDataSource locationRemoteDataSource(Ref ref) {
  return LocationRemoteDataSource(ref.watch(dioProvider));
}

/// Provides the repository implementation.
@Riverpod(keepAlive: true)
LocationRepository locationRepository(Ref ref) {
  return LocationRepositoryImpl(
    remote: ref.watch(locationRemoteDataSourceProvider),
  );
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
@riverpod
class LocationListNotifier extends _$LocationListNotifier {
  @override
  Future<LocationListState> build() async {
    return _fetchPage(1);
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
      final nextPage = currentState.currentPage + 1;
      final page = await ref
          .read(locationRepositoryProvider)
          .getLocations(page: nextPage);

      state = AsyncData(
        currentState.copyWith(
          locations: [...currentState.locations, ...page.locations],
          currentPage: nextPage,
          hasNextPage: page.hasNextPage,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      // Pagination error: keep existing data, just stop loading indicator
      state = AsyncData(currentState.copyWith(isLoadingMore: false));
      // Re-throw so the UI can show a snackbar
      rethrow;
    }
  }

  Future<LocationListState> _fetchPage(int page) async {
    final result = await ref
        .read(locationRepositoryProvider)
        .getLocations(page: page);

    return LocationListState(
      locations: result.locations,
      currentPage: page,
      hasNextPage: result.hasNextPage,
    );
  }
}
