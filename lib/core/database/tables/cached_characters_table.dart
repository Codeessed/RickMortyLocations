import 'package:drift/drift.dart';

/// Drift table storing cached characters (residents) from the Rick & Morty API.
class CachedCharacters extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get status => text()();
  TextColumn get species => text()();
  TextColumn get image => text()();
  /// Tracks when this row was last fetched from the API.
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
