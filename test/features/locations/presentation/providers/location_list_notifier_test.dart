import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_morty_flutter/features/locations/data/repositories/location_repository_impl.dart';
import 'package:rick_morty_flutter/features/locations/domain/entities/location.dart';
import 'package:rick_morty_flutter/features/locations/domain/repositories/location_repository.dart';
import 'package:rick_morty_flutter/features/locations/presentation/providers/location_providers.dart';

// ── Mocks ──────────────────────────────────────────────────────────────
class MockLocationRepository extends Mock implements LocationRepositoryImpl {}

void main() {
  late MockLocationRepository mockRepo;

  // Two pages of test data — page 1 has "next", page 2 does not.
  final page1 = LocationPage(
    locations: [
      Location(
        id: 1,
        name: 'Earth (C-137)',
        type: 'Planet',
        dimension: 'Dimension C-137',
        residentUrls: [],
        url: 'url1',
        created: DateTime(2017),
      ),
    ],
    hasNextPage: true,
    currentPage: 1,
  );

  final page2 = LocationPage(
    locations: [
      Location(
        id: 2,
        name: 'Abadango',
        type: 'Cluster',
        dimension: 'unknown',
        residentUrls: [],
        url: 'url2',
        created: DateTime(2017),
      ),
    ],
    hasNextPage: false, // last page
    currentPage: 2,
  );

  setUp(() {
    mockRepo = MockLocationRepository();
    // Default: lastCachedAt returns null (no cache)
    when(() => mockRepo.getLastCachedAt()).thenAnswer((_) async => null);
    // Default: no types
    when(() => mockRepo.watchDistinctTypes())
        .thenAnswer((_) => Stream.value([]));
  });

  /// Helper: creates a [ProviderContainer] with the mock repository
  /// injected via an override. This isolates the notifier from real
  /// network calls and database queries.
  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        locationRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  }

  // ── Test 1: Initial build fetches page 1 ──────────────────────────
  // When the notifier is first read, its build() method calls
  // getLocations(page: 1). The state should transition from
  // AsyncLoading → AsyncData with the first page of locations.
  test('build() fetches page 1 and emits AsyncData', () async {
    when(() => mockRepo.getLocations(page: 1))
        .thenAnswer((_) async => page1);

    final container = createContainer();
    addTearDown(container.dispose);

    // Reading the provider triggers build()
    await container.read(locationListNotifierProvider.future);

    final state = container.read(locationListNotifierProvider).value!;
    expect(state.locations.length, 1);
    expect(state.locations.first.name, 'Earth (C-137)');
    expect(state.currentPage, 1);
    expect(state.hasNextPage, true);
    expect(state.isLoadingMore, false);
  });

  // ── Test 2: loadMore() appends page 2 ─────────────────────────────
  // After the initial load, calling loadMore() should fetch page 2
  // and APPEND the new locations to the existing list (not replace).
  // This verifies the infinite scroll behavior.
  test('loadMore() appends next page to existing list', () async {
    when(() => mockRepo.getLocations(page: 1))
        .thenAnswer((_) async => page1);
    when(() => mockRepo.getLocations(page: 2))
        .thenAnswer((_) async => page2);

    final container = createContainer();
    addTearDown(container.dispose);

    await container.read(locationListNotifierProvider.future);

    // Now load page 2
    await container
        .read(locationListNotifierProvider.notifier)
        .loadMore();

    final state = container.read(locationListNotifierProvider).value!;
    expect(state.locations.length, 2); // 1 from page1 + 1 from page2
    expect(state.locations[0].name, 'Earth (C-137)');
    expect(state.locations[1].name, 'Abadango');
    expect(state.currentPage, 2);
    expect(state.hasNextPage, false); // page2 was the last page
  });

  // ── Test 3: loadMore() is a no-op when no next page ───────────────
  // After loading the last page, loadMore() should do nothing.
  // Without this guard, the app would make pointless API calls
  // and show the loading spinner forever.
  test('loadMore() does nothing when hasNextPage is false', () async {
    when(() => mockRepo.getLocations(page: 1))
        .thenAnswer((_) async => page1);
    when(() => mockRepo.getLocations(page: 2))
        .thenAnswer((_) async => page2);

    final container = createContainer();
    addTearDown(container.dispose);

    await container.read(locationListNotifierProvider.future);
    await container
        .read(locationListNotifierProvider.notifier)
        .loadMore();

    // hasNextPage is now false. loadMore() should be a no-op.
    await container
        .read(locationListNotifierProvider.notifier)
        .loadMore();

    // Page 2 should only have been fetched ONCE
    verify(() => mockRepo.getLocations(page: 2)).called(1);
  });

  // ── Test 4: loadMore() error preserves existing data ──────────────
  // If page 2 fails to load, the locations from page 1 must stay
  // visible. The UI shows a SnackBar for the error instead of
  // replacing the whole screen with ErrorView.
  test('loadMore() error preserves loaded locations', () async {
    when(() => mockRepo.getLocations(page: 1))
        .thenAnswer((_) async => page1);
    when(() => mockRepo.getLocations(page: 2))
        .thenThrow(Exception('Network error'));

    final container = createContainer();
    addTearDown(container.dispose);

    await container.read(locationListNotifierProvider.future);

    // This should NOT throw — the notifier catches the error internally
    await container
        .read(locationListNotifierProvider.notifier)
        .loadMore();

    final state = container.read(locationListNotifierProvider).value!;
    // Page 1 data is still there
    expect(state.locations.length, 1);
    expect(state.locations.first.name, 'Earth (C-137)');
    // Loading indicator stopped
    expect(state.isLoadingMore, false);
  });
}
