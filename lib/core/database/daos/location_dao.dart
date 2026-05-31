import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/cached_locations_table.dart';

part 'location_dao.g.dart';

/// Data Access Object for cached locations.
///
/// All queries use reactive [Stream] returns via [watch()] so the UI
/// auto-updates when the cache is refreshed in the background.
@DriftAccessor(tables: [CachedLocations])
class LocationDao extends DatabaseAccessor<AppDatabase>
    with _$LocationDaoMixin {
  LocationDao(super.db);

  /// Watches all cached locations, optionally filtered by [name] and [type].
  ///
  /// Results are ordered by page then ID for consistent display order.
  Stream<List<CachedLocation>> watchLocations({
    String? name,
    String? type,
  }) {
    final query = select(cachedLocations);

    if (name != null && name.isNotEmpty) {
      query.where((t) => t.name.like('%$name%'));
    }
    if (type != null && type.isNotEmpty) {
      query.where((t) => t.type.equals(type));
    }

    query.orderBy([
      (t) => OrderingTerm.asc(t.page),
      (t) => OrderingTerm.asc(t.id),
    ]);

    return query.watch();
  }

  /// Returns all cached locations for a given [page].
  Future<List<CachedLocation>> getLocationsForPage(int page) {
    return (select(cachedLocations)..where((t) => t.page.equals(page))).get();
  }

  /// Returns a single cached location by [id], or `null` if not cached.
  Future<CachedLocation?> getLocationById(int id) {
    return (select(cachedLocations)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Upserts a batch of locations into the cache.
  Future<void> upsertLocations(List<CachedLocationsCompanion> rows) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(cachedLocations, rows);
    });
  }

  /// Returns the most recent [cachedAt] timestamp across all rows,
  /// or `null` if the cache is empty.
  Future<DateTime?> getLastCachedAt() async {
    final query = selectOnly(cachedLocations)
      ..addColumns([cachedLocations.cachedAt.max()]);
    final result = await query.getSingleOrNull();
    return result?.read(cachedLocations.cachedAt.max());
  }

  /// Returns a stream of distinct location types for the filter dropdown.
  Stream<List<String>> watchDistinctTypes() {
    final query = selectOnly(cachedLocations, distinct: true)
      ..addColumns([cachedLocations.type])
      ..where(cachedLocations.type.length.isBiggerThanValue(0))
      ..orderBy([OrderingTerm.asc(cachedLocations.type)]);
    return query
        .map((row) => row.read(cachedLocations.type)!)
        .watch();
  }

  /// Deletes all cached locations.
  Future<void> clearAll() => delete(cachedLocations).go();
}
