import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/character_model.dart';
import '../models/location_model.dart';
import '../models/location_response_model.dart';

part 'location_remote_datasource.g.dart';

/// Retrofit interface for the Rick & Morty REST API.
///
/// All endpoints return typed DTOs — no raw `Map` parsing in calling code.
@RestApi()
abstract class LocationRemoteDataSource {
  factory LocationRemoteDataSource(Dio dio) = _LocationRemoteDataSource;

  /// Fetches a paginated list of locations with optional name/type filters.
  @GET('/location')
  Future<LocationResponseModel> getLocations({
    @Query('page') required int page,
    @Query('name') String? name,
    @Query('type') String? type,
  });

  /// Fetches a single location by its ID.
  @GET('/location/{id}')
  Future<LocationModel> getLocationById(@Path('id') int id);

  /// Fetches a single character by its ID.
  @GET('/character/{id}')
  Future<CharacterModel> getCharacterById(@Path('id') int id);
}
