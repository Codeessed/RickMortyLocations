import 'package:drift/drift.dart';

/// Drift table storing cached locations from the Rick & Morty API.
class CachedLocations extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  TextColumn get dimension => text()();
  /// Comma-separated list of resident URLs.
  TextColumn get residentUrls => text().withDefault(const Constant(''))();
  TextColumn get url => text()();
  DateTimeColumn get created => dateTime()();
  /// Tracks when this row was last fetched from the API.
  DateTimeColumn get cachedAt => dateTime()();
  /// The page number this location was fetched from (for pagination cache).
  IntColumn get page => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}
