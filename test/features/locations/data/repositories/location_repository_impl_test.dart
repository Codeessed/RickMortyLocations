import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_morty_flutter/core/database/app_database.dart';
import 'package:rick_morty_flutter/core/database/daos/character_dao.dart';
import 'package:rick_morty_flutter/core/database/daos/location_dao.dart';
import 'package:rick_morty_flutter/core/errors/app_exception.dart';
import 'package:rick_morty_flutter/features/locations/data/datasources/location_remote_datasource.dart';
import 'package:rick_morty_flutter/features/locations/data/models/character_model.dart';
import 'package:rick_morty_flutter/features/locations/data/models/location_model.dart';
import 'package:rick_morty_flutter/features/locations/data/models/location_response_model.dart';
import 'package:rick_morty_flutter/features/locations/data/repositories/location_repository_impl.dart';

// ── Mocks ──────────────────────────────────────────────────────────────
// mocktail generates these at runtime — no build_runner needed.
class MockRemoteDataSource extends Mock implements LocationRemoteDataSource {}

class MockLocationDao extends Mock implements LocationDao {}

class MockCharacterDao extends Mock implements CharacterDao {}

void main() {
  late MockRemoteDataSource mockRemote;
  late MockLocationDao mockLocationDao;
  late MockCharacterDao mockCharacterDao;
  late LocationRepositoryImpl repository;

  // Shared test data
  final testLocationModel = LocationModel(
    id: 1,
    name: 'Earth (C-137)',
    type: 'Planet',
    dimension: 'Dimension C-137',
    residents: ['https://rickandmortyapi.com/api/character/38'],
    url: 'https://rickandmortyapi.com/api/location/1',
    created: DateTime(2017, 11, 10),
  );

  final testResponse = LocationResponseModel(
    info: const PaginationInfo(count: 1, pages: 1, next: null, prev: null),
    results: [testLocationModel],
  );

  // A CachedLocation row as Drift would return it from the DB.
  final freshCachedRow = CachedLocation(
    id: 1,
    name: 'Earth (C-137)',
    type: 'Planet',
    dimension: 'Dimension C-137',
    residentUrls: 'https://rickandmortyapi.com/api/character/38',
    url: 'https://rickandmortyapi.com/api/location/1',
    created: DateTime(2017, 11, 10),
    cachedAt: DateTime.now(), // Fresh — just cached
    page: 1,
  );

  setUp(() {
    mockRemote = MockRemoteDataSource();
    mockLocationDao = MockLocationDao();
    mockCharacterDao = MockCharacterDao();
    repository = LocationRepositoryImpl(
      remote: mockRemote,
      locationDao: mockLocationDao,
      characterDao: mockCharacterDao,
    );

    // Register fallback values for mocktail's any() matchers.
    // These are needed when using `any()` with typed parameters.
    registerFallbackValue(<CachedLocationsCompanion>[]);
    registerFallbackValue(<CachedCharactersCompanion>[]);
  });

  group('getLocations', () {
    // ── Test 1: Fresh cache hit ─────────────────────────────────────
    // When the DAO has cached data for the requested page AND the
    // cachedAt timestamp is within AppConstants.cacheTtl (5 minutes),
    // the repo should return the cached data WITHOUT calling the API.
    // This is the "instant launch" behavior.
    test('returns cached data when cache is fresh', () async {
      when(() => mockLocationDao.getLocationsForPage(1))
          .thenAnswer((_) async => [freshCachedRow]);
      when(() => mockLocationDao.getLastCachedAt())
          .thenAnswer((_) async => DateTime.now()); // just now = fresh

      final result = await repository.getLocations(page: 1);

      expect(result.locations.length, 1);
      expect(result.locations.first.name, 'Earth (C-137)');
      // API should NOT have been called
      verifyNever(
        () => mockRemote.getLocations(
          page: any(named: 'page'),
          name: any(named: 'name'),
          type: any(named: 'type'),
        ),
      );
    });

    // ── Test 2: Stale cache → network fetch ─────────────────────────
    // When the cache exists but cachedAt is older than 5 minutes,
    // the repo must fetch from the API and upsert the new data.
    test('fetches from network when cache is stale', () async {
      final staleCachedRow = CachedLocation(
        id: 1,
        name: 'Earth (C-137)',
        type: 'Planet',
        dimension: 'Dimension C-137',
        residentUrls: '',
        url: 'https://rickandmortyapi.com/api/location/1',
        created: DateTime(2017, 11, 10),
        cachedAt: DateTime.now()
            .subtract(const Duration(minutes: 10)), // 10 min ago = stale
        page: 1,
      );

      when(() => mockLocationDao.getLocationsForPage(1))
          .thenAnswer((_) async => [staleCachedRow]);
      when(() => mockLocationDao.getLastCachedAt())
          .thenAnswer((_) async =>
              DateTime.now().subtract(const Duration(minutes: 10)));
      when(() => mockRemote.getLocations(
            page: 1,
            name: null,
            type: null,
          )).thenAnswer((_) async => testResponse);
      when(() => mockLocationDao.upsertLocations(any()))
          .thenAnswer((_) async {});

      final result = await repository.getLocations(page: 1);

      expect(result.locations.length, 1);
      expect(result.hasNextPage, false); // response.info.next is null
      // API should have been called
      verify(() => mockRemote.getLocations(
            page: 1,
            name: null,
            type: null,
          )).called(1);
      // Cache should have been updated
      verify(() => mockLocationDao.upsertLocations(any())).called(1);
    });

    // ── Test 3: Network error with cache → graceful degradation ─────
    // If the API call throws but we have stale cache, the repo should
    // return the stale data rather than crashing. This is the key
    // offline-resilience behavior.
    test('returns stale cache when network fails', () async {
      when(() => mockLocationDao.getLocationsForPage(1))
          .thenAnswer((_) async => [freshCachedRow]);
      when(() => mockLocationDao.getLastCachedAt())
          .thenAnswer((_) async =>
              DateTime.now().subtract(const Duration(minutes: 10)));
      when(() => mockRemote.getLocations(
            page: 1,
            name: null,
            type: null,
          )).thenThrow(const NetworkException(message: 'No internet'));

      final result = await repository.getLocations(page: 1);

      // Should return cached data, not throw
      expect(result.locations.length, 1);
      expect(result.locations.first.name, 'Earth (C-137)');
    });

    // ── Test 4: Network error without cache → throw ─────────────────
    // If there's no cache at all AND the network fails, the repo must
    // throw so the UI can show the ErrorView with a retry button.
    test('throws when network fails and cache is empty', () async {
      when(() => mockLocationDao.getLocationsForPage(1))
          .thenAnswer((_) async => []);
      when(() => mockRemote.getLocations(
            page: 1,
            name: null,
            type: null,
          )).thenThrow(const NetworkException(message: 'No internet'));

      expect(
        () => repository.getLocations(page: 1),
        throwsA(isA<AppException>()),
      );
    });

    // ── Test 5: Filtered requests bypass cache ──────────────────────
    // When the user searches by name or filters by type, we always
    // hit the API because the cache only stores unfiltered results.
    // We don't want to return stale unfiltered cache for a filtered
    // query — that would show wrong results.
    test('always fetches from network for filtered requests', () async {
      when(() => mockLocationDao.getLocationsForPage(1))
          .thenAnswer((_) async => [freshCachedRow]);
      when(() => mockLocationDao.getLastCachedAt())
          .thenAnswer((_) async => DateTime.now());
      when(() => mockRemote.getLocations(
            page: 1,
            name: 'Earth',
            type: null,
          )).thenAnswer((_) async => testResponse);

      final result = await repository.getLocations(
        page: 1,
        name: 'Earth',
      );

      expect(result.locations.length, 1);
      // API SHOULD be called even though cache is fresh
      verify(() => mockRemote.getLocations(
            page: 1,
            name: 'Earth',
            type: null,
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getLocationById — Detail screen caching
  // ═══════════════════════════════════════════════════════════════════════
  group('getLocationById', () {
    // ── Test 1: Fresh cache returns without API call ─────────────────
    // When the user taps a location they already visited recently,
    // the detail screen should render instantly from cache.
    test('returns cached location when cache is fresh', () async {
      when(() => mockLocationDao.getLocationById(1))
          .thenAnswer((_) async => freshCachedRow);

      final result = await repository.getLocationById(1);

      expect(result.name, 'Earth (C-137)');
      expect(result.type, 'Planet');
      // API should NOT be called
      verifyNever(() => mockRemote.getLocationById(any()));
    });

    // ── Test 2: Stale cache fetches from network ────────────────────
    // If the cached location is older than 5 minutes, fetch fresh data
    // from the API and update the cache.
    test('fetches from network when cache is stale', () async {
      final staleRow = CachedLocation(
        id: 1,
        name: 'Earth (C-137)',
        type: 'Planet',
        dimension: 'Dimension C-137',
        residentUrls: '',
        url: 'url1',
        created: DateTime(2017, 11, 10),
        cachedAt: DateTime.now().subtract(const Duration(minutes: 10)),
        page: 0,
      );

      when(() => mockLocationDao.getLocationById(1))
          .thenAnswer((_) async => staleRow);
      when(() => mockRemote.getLocationById(1))
          .thenAnswer((_) async => testLocationModel);
      when(() => mockLocationDao.upsertLocations(any()))
          .thenAnswer((_) async {});

      final result = await repository.getLocationById(1);

      expect(result.name, 'Earth (C-137)');
      verify(() => mockRemote.getLocationById(1)).called(1);
      verify(() => mockLocationDao.upsertLocations(any())).called(1);
    });

    // ── Test 3: Network error falls back to stale cache ─────────────
    // Offline on the detail screen should still show the last cached
    // version of the location, not crash.
    test('returns stale cache when network fails', () async {
      final staleRow = CachedLocation(
        id: 1,
        name: 'Earth (C-137)',
        type: 'Planet',
        dimension: 'Dimension C-137',
        residentUrls: 'url1,url2',
        url: 'url1',
        created: DateTime(2017, 11, 10),
        cachedAt: DateTime.now().subtract(const Duration(minutes: 10)),
        page: 0,
      );

      when(() => mockLocationDao.getLocationById(1))
          .thenAnswer((_) async => staleRow);
      when(() => mockRemote.getLocationById(1))
          .thenThrow(const NetworkException(message: 'No internet'));

      final result = await repository.getLocationById(1);

      expect(result.name, 'Earth (C-137)');
      expect(result.residentUrls, ['url1', 'url2']);
    });

    // ── Test 4: No cache + network error → throw ────────────────────
    // First visit to a location while offline should show ErrorView.
    test('throws when network fails and no cache exists', () async {
      when(() => mockLocationDao.getLocationById(1))
          .thenAnswer((_) async => null);
      when(() => mockRemote.getLocationById(1))
          .thenThrow(const NetworkException(message: 'No internet'));

      expect(
        () => repository.getLocationById(1),
        throwsA(isA<AppException>()),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getCharactersByIds — Resident caching
  // ═══════════════════════════════════════════════════════════════════════
  group('getCharactersByIds', () {
    final freshCharacterRow = CachedCharacter(
      id: 38,
      name: 'Beth Smith',
      status: 'Alive',
      species: 'Human',
      image: 'https://rickandmortyapi.com/api/character/avatar/38.jpeg',
      cachedAt: DateTime.now(),
    );

    final characterModel = CharacterModel(
      id: 38,
      name: 'Beth Smith',
      status: 'Alive',
      species: 'Human',
      image: 'https://rickandmortyapi.com/api/character/avatar/38.jpeg',
    );

    // ── Test 1: Fresh cache returns all characters ───────────────────
    // If all requested character IDs are in cache and fresh,
    // skip the network entirely. This avoids N parallel HTTP requests.
    test('returns cached characters when all are fresh', () async {
      when(() => mockCharacterDao.getByIds([38]))
          .thenAnswer((_) async => [freshCharacterRow]);

      final result = await repository.getCharactersByIds([38]);

      expect(result.length, 1);
      expect(result.first.name, 'Beth Smith');
      verifyNever(() => mockRemote.getCharacterById(any()));
    });

    // ── Test 2: Stale/missing cache fetches from network ────────────
    // If any character is missing or stale, fetch ALL from network
    // and update the cache. We don't do partial fetches because
    // the overhead isn't worth the complexity.
    test('fetches from network when cache is stale', () async {
      final staleCharRow = CachedCharacter(
        id: 38,
        name: 'Beth Smith',
        status: 'Alive',
        species: 'Human',
        image: 'img',
        cachedAt: DateTime.now().subtract(const Duration(minutes: 10)),
      );

      when(() => mockCharacterDao.getByIds([38]))
          .thenAnswer((_) async => [staleCharRow]);
      when(() => mockRemote.getCharacterById(38))
          .thenAnswer((_) async => characterModel);
      when(() => mockCharacterDao.upsertCharacters(any()))
          .thenAnswer((_) async {});

      final result = await repository.getCharactersByIds([38]);

      expect(result.length, 1);
      verify(() => mockRemote.getCharacterById(38)).called(1);
      verify(() => mockCharacterDao.upsertCharacters(any())).called(1);
    });

    // ── Test 3: Network error falls back to stale character cache ────
    // If the character API is down but we have stale data, show it.
    test('returns stale cache when network fails', () async {
      final staleCharRow = CachedCharacter(
        id: 38,
        name: 'Beth Smith',
        status: 'Alive',
        species: 'Human',
        image: 'img',
        cachedAt: DateTime.now().subtract(const Duration(minutes: 10)),
      );

      when(() => mockCharacterDao.getByIds([38]))
          .thenAnswer((_) async => [staleCharRow]);
      when(() => mockRemote.getCharacterById(38))
          .thenThrow(const NetworkException(message: 'No internet'));

      final result = await repository.getCharactersByIds([38]);

      expect(result.length, 1);
      expect(result.first.name, 'Beth Smith');
    });

    // ── Test 4: Empty IDs returns empty list ────────────────────────
    // Locations with no residents should return immediately.
    test('returns empty list for empty IDs', () async {
      final result = await repository.getCharactersByIds([]);
      expect(result, isEmpty);
    });
  });
}
