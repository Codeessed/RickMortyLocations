import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_database.g.dart';

// ── Tables ─────────────────────────────────────────────────────────────
// Tables will be added here as features are built (Task 4).
// For now, this file scaffolds the Drift database so code-gen is verified.

/// The central Drift database for the Rick & Morty app.
///
/// Tables and DAOs will be registered here as features are implemented.
/// Currently scaffolded as an empty database to validate the code-gen pipeline.
@DriftDatabase(tables: [])
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
