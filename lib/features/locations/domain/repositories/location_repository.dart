import '../entities/character.dart';
import '../entities/location.dart';

/// Abstract repository interface for locations and their residents.
///
/// The presentation layer depends only on this — never on the concrete
/// implementation in the data layer.
abstract class LocationRepository {
  /// Fetches a paginated list of locations.
  ///
  /// [page] starts at 1. [name] and [type] are optional filters
  /// forwarded as query parameters.
  Future<LocationPage> getLocations({
    required int page,
    String? name,
    String? type,
  });

  /// Fetches a single location by [id].
  Future<Location> getLocationById(int id);

  /// Fetches a single character by [id].
  Future<Character> getCharacterById(int id);

  /// Fetches multiple characters by their [ids] in parallel.
  Future<List<Character>> getCharactersByIds(List<int> ids);
}

/// A page of locations with pagination metadata.
class LocationPage {
  final List<Location> locations;
  final bool hasNextPage;
  final int currentPage;

  const LocationPage({
    required this.locations,
    required this.hasNextPage,
    required this.currentPage,
  });
}
