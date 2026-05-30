import 'package:dio/dio.dart';

import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/character.dart';
import '../../domain/entities/location.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_remote_datasource.dart';
import '../mappers/model_mappers.dart';

/// Concrete implementation of [LocationRepository].
///
/// Currently network-only. Local caching will be layered in (Task 4)
/// without changing the interface the presentation layer depends on.
class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource _remote;

  LocationRepositoryImpl({required LocationRemoteDataSource remote})
      : _remote = remote;

  @override
  Future<LocationPage> getLocations({
    required int page,
    String? name,
    String? type,
  }) async {
    try {
      final response = await _remote.getLocations(
        page: page,
        name: name,
        type: type,
      );

      return LocationPage(
        locations: response.results.map((m) => m.toEntity()).toList(),
        hasNextPage: response.info.next != null,
        currentPage: page,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  @override
  Future<Location> getLocationById(int id) async {
    try {
      final model = await _remote.getLocationById(id);
      return model.toEntity();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  @override
  Future<Character> getCharacterById(int id) async {
    try {
      final model = await _remote.getCharacterById(id);
      return model.toEntity();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  @override
  Future<List<Character>> getCharactersByIds(List<int> ids) async {
    try {
      final futures = ids.map((id) => _remote.getCharacterById(id));
      final models = await Future.wait(futures);
      return models.map((m) => m.toEntity()).toList();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// Extracts the typed [AppException] that [ApiInterceptor] attached
  /// to the [DioException], or wraps it as [UnknownException].
  AppException _mapDioError(DioException e) {
    if (e.error is AppException) {
      return e.error as AppException;
    }
    return UnknownException(cause: e);
  }
}
