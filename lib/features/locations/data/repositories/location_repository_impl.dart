import 'package:dio/dio.dart';
import 'package:drift/drift.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/character_dao.dart';
import '../../../../core/database/daos/location_dao.dart';
import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/character.dart';
import '../../domain/entities/location.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_remote_datasource.dart';
import '../mappers/model_mappers.dart';

/// Concrete implementation of [LocationRepository] with
/// stale-while-revalidate caching via Drift.
///
/// Strategy:
/// 1. Immediately return cached data if available.
/// 2. If cache is stale (older than [AppConstants.cacheTtl]),
///    fetch fresh data from the network in the background.
/// 3. On network error with valid cache: return cache.
/// 4. On network error with empty cache: throw.
class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource _remote;
  final LocationDao _locationDao;
  final CharacterDao _characterDao;

  LocationRepositoryImpl({
    required LocationRemoteDataSource remote,
    required LocationDao locationDao,
    required CharacterDao characterDao,
  })  : _remote = remote,
        _locationDao = locationDao,
        _characterDao = characterDao;

  @override
  Future<LocationPage> getLocations({
    required int page,
    String? name,
    String? type,
  }) async {
    // 1. Check cache for this page
    final cached = await _locationDao.getLocationsForPage(page);
    final hasCachedData = cached.isNotEmpty;

    // 2. Determine staleness
    bool isStale = true;
    if (hasCachedData) {
      final lastCachedAt = await _locationDao.getLastCachedAt();
      if (lastCachedAt != null) {
        isStale = DateTime.now().difference(lastCachedAt) >
            AppConstants.cacheTtl;
      }
    }

    // 3. If cache is fresh and we have data, return it
    if (hasCachedData && !isStale && _isUnfilteredRequest(name, type)) {
      return LocationPage(
        locations: cached.map(_cachedLocationToEntity).toList(),
        hasNextPage: true, // conservative; network will correct this
        currentPage: page,
      );
    }

    // 4. Fetch from network
    try {
      final response = await _remote.getLocations(
        page: page,
        name: name,
        type: type,
      );

      final entities = response.results.map((m) => m.toEntity()).toList();

      // Only cache unfiltered requests
      if (_isUnfilteredRequest(name, type)) {
        final now = DateTime.now();
        final companions = response.results.map((m) {
          return CachedLocationsCompanion(
            id: Value(m.id),
            name: Value(m.name),
            type: Value(m.type),
            dimension: Value(m.dimension),
            residentUrls: Value(m.residents.join(',')),
            url: Value(m.url),
            created: Value(m.created),
            cachedAt: Value(now),
            page: Value(page),
          );
        }).toList();
        await _locationDao.upsertLocations(companions);
      }

      return LocationPage(
        locations: entities,
        hasNextPage: response.info.next != null,
        currentPage: page,
      );
    } catch (e) {
      // The Rick & Morty API returns 404 when no results match
      // a search/filter query. Treat this as an empty result set.
      if (_isNotFoundException(e)) {
        return LocationPage(
          locations: [],
          hasNextPage: false,
          currentPage: page,
        );
      }

      // 5. On error with cache: return stale cache
      if (hasCachedData && _isUnfilteredRequest(name, type)) {
        return LocationPage(
          locations: cached.map(_cachedLocationToEntity).toList(),
          hasNextPage: true,
          currentPage: page,
        );
      }
      // 6. On error with empty cache: rethrow
      if (e is AppException) rethrow;
      throw UnknownException(cause: e);
    }
  }

  @override
  Future<Location> getLocationById(int id) async {
    // 1. Check cache
    final cached = await _locationDao.getLocationById(id);
    final hasCachedData = cached != null;

    // 2. Determine staleness
    bool isStale = true;
    if (hasCachedData) {
      isStale = DateTime.now().difference(cached.cachedAt) >
          AppConstants.cacheTtl;
    }

    // 3. If cache is fresh, return it immediately
    if (hasCachedData && !isStale) {
      return _cachedLocationToEntity(cached);
    }

    // 4. Fetch from network
    try {
      final model = await _remote.getLocationById(id);

      // Cache this location
      final now = DateTime.now();
      await _locationDao.upsertLocations([
        CachedLocationsCompanion(
          id: Value(model.id),
          name: Value(model.name),
          type: Value(model.type),
          dimension: Value(model.dimension),
          residentUrls: Value(model.residents.join(',')),
          url: Value(model.url),
          created: Value(model.created),
          cachedAt: Value(now),
          page: const Value(0), // detail-fetched, not part of pagination
        ),
      ]);

      return model.toEntity();
    } catch (e) {
      // 5. On error with cache: return stale data
      if (hasCachedData) {
        return _cachedLocationToEntity(cached);
      }
      // 6. On error without cache: throw
      if (e is AppException) rethrow;
      throw UnknownException(cause: e);
    }
  }

  @override
  Future<Character> getCharacterById(int id) async {
    // Check cache first
    final cached = await _characterDao.getByIds([id]);
    if (cached.isNotEmpty) {
      final c = cached.first;
      final age = DateTime.now().difference(c.cachedAt);
      if (age <= AppConstants.cacheTtl) {
        return _cachedCharacterToEntity(c);
      }
    }

    try {
      final model = await _remote.getCharacterById(id);

      // Cache
      await _characterDao.upsertCharacters([
        CachedCharactersCompanion(
          id: Value(model.id),
          name: Value(model.name),
          status: Value(model.status),
          species: Value(model.species),
          image: Value(model.image),
          cachedAt: Value(DateTime.now()),
        ),
      ]);

      return model.toEntity();
    } catch (e) {
      // Fallback to stale cache
      if (cached.isNotEmpty) {
        return _cachedCharacterToEntity(cached.first);
      }
      if (e is AppException) rethrow;
      throw UnknownException(cause: e);
    }
  }

  @override
  Future<List<Character>> getCharactersByIds(List<int> ids) async {
    if (ids.isEmpty) return [];

    // Check cache
    final cached = await _characterDao.getByIds(ids);
    final allFresh = cached.length == ids.length &&
        cached.every((c) =>
            DateTime.now().difference(c.cachedAt) <= AppConstants.cacheTtl);

    if (allFresh) {
      return cached.map(_cachedCharacterToEntity).toList();
    }

    try {
      final futures = ids.map((id) => _remote.getCharacterById(id));
      final models = await Future.wait(futures);

      // Cache all
      await _characterDao.upsertCharacters(
        models
            .map((m) => CachedCharactersCompanion(
                  id: Value(m.id),
                  name: Value(m.name),
                  status: Value(m.status),
                  species: Value(m.species),
                  image: Value(m.image),
                  cachedAt: Value(DateTime.now()),
                ))
            .toList(),
      );

      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      // Fallback to stale cache
      if (cached.isNotEmpty) {
        return cached.map(_cachedCharacterToEntity).toList();
      }
      if (e is AppException) rethrow;
      throw UnknownException(cause: e);
    }
  }

  /// Returns the most recent cache timestamp, or `null` if empty.
  Future<DateTime?> getLastCachedAt() => _locationDao.getLastCachedAt();

  /// Reactive stream of distinct location types for the filter dropdown.
  Stream<List<String>> watchDistinctTypes() => _locationDao.watchDistinctTypes();

  // ── Helpers ──────────────────────────────────────────────────────────

  bool _isUnfilteredRequest(String? name, String? type) =>
      (name == null || name.isEmpty) && (type == null || type.isEmpty);

  /// Returns `true` if the error is a [NotFoundException], either thrown
  /// directly or wrapped inside a [DioException] by the API interceptor.
  bool _isNotFoundException(Object e) {
    if (e is NotFoundException) return true;
    if (e is DioException && e.error is NotFoundException) return true;
    return false;
  }

  Location _cachedLocationToEntity(CachedLocation row) => Location(
        id: row.id,
        name: row.name,
        type: row.type,
        dimension: row.dimension,
        residentUrls:
            row.residentUrls.isEmpty ? [] : row.residentUrls.split(','),
        url: row.url,
        created: row.created,
      );

  Character _cachedCharacterToEntity(CachedCharacter row) => Character(
        id: row.id,
        name: row.name,
        status: row.status,
        species: row.species,
        image: row.image,
      );
}
