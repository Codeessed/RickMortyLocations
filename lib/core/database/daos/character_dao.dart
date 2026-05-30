import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/cached_characters_table.dart';

part 'character_dao.g.dart';

/// Data Access Object for cached characters (residents).
@DriftAccessor(tables: [CachedCharacters])
class CharacterDao extends DatabaseAccessor<AppDatabase>
    with _$CharacterDaoMixin {
  CharacterDao(super.db);

  /// Returns cached characters matching the given [ids].
  Future<List<CachedCharacter>> getByIds(List<int> ids) {
    return (select(cachedCharacters)..where((t) => t.id.isIn(ids))).get();
  }

  /// Upserts a batch of characters into the cache.
  Future<void> upsertCharacters(List<CachedCharactersCompanion> rows) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(cachedCharacters, rows);
    });
  }

  /// Deletes all cached characters.
  Future<void> clearAll() => delete(cachedCharacters).go();
}
