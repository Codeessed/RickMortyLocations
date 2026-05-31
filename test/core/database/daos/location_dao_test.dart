import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rick_morty_flutter/core/database/app_database.dart';

/// Integration tests for [LocationDao] using a real in-memory SQLite database.
///
/// Why not mock? Because we want to verify that the actual SQL queries
/// (LIKE, equals, ORDER BY, DISTINCT) work correctly. A mock would just
/// test that we call mock methods, not that the SQL is valid.
void main() {
  late AppDatabase db;

  setUp(() {
    // Creates a fresh in-memory SQLite database for every test.
    // No file IO, no cleanup needed, runs in milliseconds.
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  // Shared seed data — 3 locations of different types
  Future<void> seedLocations() async {
    await db.locationDao.upsertLocations([
      CachedLocationsCompanion(
        id: const Value(1),
        name: const Value('Earth (C-137)'),
        type: const Value('Planet'),
        dimension: const Value('Dimension C-137'),
        residentUrls: const Value('url1,url2'),
        url: const Value('https://rickandmortyapi.com/api/location/1'),
        created: Value(DateTime(2017, 11, 10)),
        cachedAt: Value(DateTime.now()),
        page: const Value(1),
      ),
      CachedLocationsCompanion(
        id: const Value(2),
        name: const Value('Abadango'),
        type: const Value('Cluster'),
        dimension: const Value('unknown'),
        residentUrls: const Value('url3'),
        url: const Value('https://rickandmortyapi.com/api/location/2'),
        created: Value(DateTime(2017, 11, 10)),
        cachedAt: Value(DateTime.now()),
        page: const Value(1),
      ),
      CachedLocationsCompanion(
        id: const Value(3),
        name: const Value('Citadel of Ricks'),
        type: const Value('Space station'),
        dimension: const Value('unknown'),
        residentUrls: const Value(''),
        url: const Value('https://rickandmortyapi.com/api/location/3'),
        created: Value(DateTime(2017, 11, 10)),
        cachedAt: Value(DateTime.now()),
        page: const Value(2),
      ),
    ]);
  }

  // ── Test 1: Upsert + retrieve by page ─────────────────────────────
  // Verifies that upsertLocations writes rows and getLocationsForPage
  // retrieves only the rows for the specified page number. This is
  // the foundation of the pagination cache.
  test('upsertLocations inserts and getLocationsForPage retrieves', () async {
    await seedLocations();

    final page1 = await db.locationDao.getLocationsForPage(1);
    final page2 = await db.locationDao.getLocationsForPage(2);

    expect(page1.length, 2); // Earth + Abadango
    expect(page2.length, 1); // Citadel of Ricks
    expect(page1.first.name, 'Earth (C-137)'); // ordered by id ascending
  });

  // ── Test 2: Filter by name (SQL LIKE) ─────────────────────────────
  // The search bar sends a name query. The DAO uses `LIKE '%name%'`
  // which is case-sensitive in SQLite by default. We verify that
  // partial matches work (e.g., "Earth" matches "Earth (C-137)").
  test('watchLocations filters by name with LIKE', () async {
    await seedLocations();

    final results = await db.locationDao
        .watchLocations(name: 'Earth')
        .first;

    expect(results.length, 1);
    expect(results.first.name, 'Earth (C-137)');
  });

  // ── Test 3: Filter by type (exact match) ──────────────────────────
  // The type filter uses SQL `equals` (not LIKE) because types are
  // selected from a dropdown of known values — no partial matching.
  test('watchLocations filters by exact type', () async {
    await seedLocations();

    final results = await db.locationDao
        .watchLocations(type: 'Planet')
        .first;

    expect(results.length, 1);
    expect(results.first.type, 'Planet');
  });

  // ── Test 4: Combined name + type filter ───────────────────────────
  // Both filters must work together in a single query (AND logic).
  // If name matches but type doesn't, the row should be excluded.
  test('watchLocations applies both name and type together', () async {
    await seedLocations();

    // "Earth" + "Cluster" → no match (Earth is Planet, not Cluster)
    final noResults = await db.locationDao
        .watchLocations(name: 'Earth', type: 'Cluster')
        .first;
    expect(noResults, isEmpty);

    // "Earth" + "Planet" → match
    final results = await db.locationDao
        .watchLocations(name: 'Earth', type: 'Planet')
        .first;
    expect(results.length, 1);
  });

  // ── Test 5: Unfiltered returns all, ordered by page → id ──────────
  // With no filters, all rows should be returned in the correct display
  // order: first by page number, then by id within each page.
  test('watchLocations with no filters returns all ordered', () async {
    await seedLocations();

    final results = await db.locationDao.watchLocations().first;

    expect(results.length, 3);
    // Page 1 first (id 1, 2), then page 2 (id 3)
    expect(results[0].id, 1);
    expect(results[1].id, 2);
    expect(results[2].id, 3);
  });

  // ── Test 6: getLastCachedAt returns most recent timestamp ─────────
  // The LastUpdatedBanner displays this value. It should be the MAX
  // cachedAt across all rows, not just the first one.
  test('getLastCachedAt returns the most recent timestamp', () async {
    final earlier = DateTime(2024, 1, 1);
    final later = DateTime(2024, 6, 15);

    await db.locationDao.upsertLocations([
      CachedLocationsCompanion(
        id: const Value(1),
        name: const Value('Old'),
        type: const Value('Planet'),
        dimension: const Value('C-137'),
        residentUrls: const Value(''),
        url: const Value('url1'),
        created: Value(DateTime(2017)),
        cachedAt: Value(earlier),
        page: const Value(1),
      ),
      CachedLocationsCompanion(
        id: const Value(2),
        name: const Value('New'),
        type: const Value('Planet'),
        dimension: const Value('C-137'),
        residentUrls: const Value(''),
        url: const Value('url2'),
        created: Value(DateTime(2017)),
        cachedAt: Value(later),
        page: const Value(1),
      ),
    ]);

    final result = await db.locationDao.getLastCachedAt();

    expect(result, later);
  });

  // ── Test 7: getLastCachedAt returns null for empty cache ───────────
  // On first launch with no cache, the banner should hide itself.
  test('getLastCachedAt returns null when cache is empty', () async {
    final result = await db.locationDao.getLastCachedAt();
    expect(result, isNull);
  });

  // ── Test 8: watchDistinctTypes returns deduplicated sorted types ───
  // The type filter dropdown is populated from this. Duplicate types
  // must be collapsed and results sorted alphabetically.
  test('watchDistinctTypes returns unique types sorted', () async {
    await seedLocations();

    final types = await db.locationDao.watchDistinctTypes().first;

    expect(types, ['Cluster', 'Planet', 'Space station']);
    // No duplicates, alphabetical order
  });

  // ── Test 9: Upsert is idempotent (ON CONFLICT UPDATE) ────────────
  // If the same location ID is cached again (e.g., background refresh),
  // the existing row should be updated, not duplicated.
  test('upsertLocations updates existing rows on conflict', () async {
    await seedLocations();

    // Update Earth's name
    await db.locationDao.upsertLocations([
      CachedLocationsCompanion(
        id: const Value(1),
        name: const Value('Earth (Replacement Dimension)'),
        type: const Value('Planet'),
        dimension: const Value('Replacement Dimension'),
        residentUrls: const Value(''),
        url: const Value('url1'),
        created: Value(DateTime(2017)),
        cachedAt: Value(DateTime.now()),
        page: const Value(1),
      ),
    ]);

    final page1 = await db.locationDao.getLocationsForPage(1);
    // Still 2 rows (not 3), and the name was updated
    expect(page1.length, 2);
    final earth = page1.firstWhere((l) => l.id == 1);
    expect(earth.name, 'Earth (Replacement Dimension)');
  });

  // ── Test 10: getLocationById returns a single cached location ──────
  // The detail screen uses this to check if a location is already
  // cached before hitting the API.
  test('getLocationById returns cached location by id', () async {
    await seedLocations();

    final result = await db.locationDao.getLocationById(1);

    expect(result, isNotNull);
    expect(result!.name, 'Earth (C-137)');
    expect(result.type, 'Planet');
    expect(result.dimension, 'Dimension C-137');
  });

  // ── Test 11: getLocationById returns null for missing id ───────────
  // If the location has never been viewed, the DAO should return null
  // so the repository knows to fetch from the network.
  test('getLocationById returns null for non-existent id', () async {
    await seedLocations();

    final result = await db.locationDao.getLocationById(999);

    expect(result, isNull);
  });
}
