import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/character.dart';
import '../../domain/entities/location.dart';
import 'location_providers.dart';

part 'location_detail_provider.g.dart';

/// Holds the full detail state for a single location and its residents.
class LocationDetailState {
  final Location location;
  final List<Character> residents;

  const LocationDetailState({
    required this.location,
    required this.residents,
  });
}

/// Fetches a single location and its first N residents in parallel.
@riverpod
Future<LocationDetailState> locationDetail(Ref ref, int locationId) async {
  final repo = ref.read(locationRepositoryProvider);

  // Fetch the location
  final location = await repo.getLocationById(locationId);

  // Extract character IDs from resident URLs and take first N
  final characterIds = location.residentUrls
      .take(AppConstants.maxResidentsOnDetail)
      .map(_extractIdFromUrl)
      .whereType<int>()
      .toList();

  // Fetch characters in parallel
  final residents = characterIds.isEmpty
      ? <Character>[]
      : await repo.getCharactersByIds(characterIds);

  return LocationDetailState(
    location: location,
    residents: residents,
  );
}

/// Extracts the numeric ID from a Rick & Morty API URL.
/// e.g. "https://rickandmortyapi.com/api/character/38" → 38
int? _extractIdFromUrl(String url) {
  final segments = Uri.parse(url).pathSegments;
  if (segments.isEmpty) return null;
  return int.tryParse(segments.last);
}
