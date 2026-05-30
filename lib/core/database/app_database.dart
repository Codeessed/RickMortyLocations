import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'daos/character_dao.dart';
import 'daos/location_dao.dart';
import 'tables/cached_characters_table.dart';
import 'tables/cached_locations_table.dart';

part 'app_database.g.dart';

/// The central Drift database for the Rick & Morty app.
@DriftDatabase(
  tables: [CachedLocations, CachedCharacters],
  daos: [LocationDao, CharacterDao],
)
class AppDatabase extends _$AppDatabase {
  /// Production constructor — uses a file-backed SQLite database.
  AppDatabase() : super(_openConnection());

  /// Test constructor — accepts any [QueryExecutor] (e.g. [NativeDatabase.memory]).
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;
}

/// Opens a native SQLite connection at the app's documents directory.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'rick_morty.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

/// Riverpod provider that exposes the singleton [AppDatabase] instance.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) => AppDatabase();

/// Provides the [LocationDao] from the database.
@Riverpod(keepAlive: true)
LocationDao locationDao(Ref ref) => ref.watch(appDatabaseProvider).locationDao;

/// Provides the [CharacterDao] from the database.
@Riverpod(keepAlive: true)
CharacterDao characterDao(Ref ref) =>
    ref.watch(appDatabaseProvider).characterDao;
