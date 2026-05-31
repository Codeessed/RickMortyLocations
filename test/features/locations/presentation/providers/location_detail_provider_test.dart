import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_morty_flutter/features/locations/data/repositories/location_repository_impl.dart';
import 'package:rick_morty_flutter/features/locations/domain/entities/character.dart';
import 'package:rick_morty_flutter/features/locations/domain/entities/location.dart';
import 'package:rick_morty_flutter/features/locations/presentation/providers/location_detail_provider.dart';
import 'package:rick_morty_flutter/features/locations/presentation/providers/location_providers.dart';

// ── Mock ───────────────────────────────────────────────────────────────
class MockLocationRepository extends Mock implements LocationRepositoryImpl {}

void main() {
  late MockLocationRepository mockRepo;

  // A location with 3 resident URLs — each URL encodes a character ID
  // in the last path segment (e.g., /character/38 → id 38).
  final testLocation = Location(
    id: 1,
    name: 'Earth (C-137)',
    type: 'Planet',
    dimension: 'Dimension C-137',
    residentUrls: [
      'https://rickandmortyapi.com/api/character/38',
      'https://rickandmortyapi.com/api/character/45',
      'https://rickandmortyapi.com/api/character/71',
    ],
    url: 'https://rickandmortyapi.com/api/location/1',
    created: DateTime(2017, 11, 10),
  );

  final testCharacters = [
    Character(id: 38, name: 'Beth Smith', status: 'Alive', species: 'Human', image: 'img1'),
    Character(id: 45, name: 'Rick Sanchez', status: 'Alive', species: 'Human', image: 'img2'),
    Character(id: 71, name: 'Morty Smith', status: 'Alive', species: 'Human', image: 'img3'),
  ];

  setUp(() {
    mockRepo = MockLocationRepository();
    // Default stubs for methods the provider doesn't call directly
    // but that locationRepositoryProvider may trigger.
    when(() => mockRepo.getLastCachedAt()).thenAnswer((_) async => null);
    when(() => mockRepo.watchDistinctTypes())
        .thenAnswer((_) => Stream.value([]));
  });

  /// Helper: creates a [ProviderContainer] with the mock repository
  /// injected. This lets us test the provider's orchestration logic
  /// (URL parsing, character cap, combining into state) in isolation
  /// from real network/database calls.
  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        locationRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  }

  // ── Test 1: Fetches location + residents and combines them ────────
  // This is the happy path. The provider should:
  //   1. Call getLocationById(1)
  //   2. Parse [38, 45, 71] from the resident URLs
  //   3. Call getCharactersByIds([38, 45, 71])
  //   4. Return a LocationDetailState with both
  test('fetches location and residents, returns combined state', () async {
    when(() => mockRepo.getLocationById(1))
        .thenAnswer((_) async => testLocation);
    when(() => mockRepo.getCharactersByIds([38, 45, 71]))
        .thenAnswer((_) async => testCharacters);

    final container = createContainer();
    addTearDown(container.dispose);

    final state = await container.read(locationDetailProvider(1).future);

    expect(state.location.name, 'Earth (C-137)');
    expect(state.residents.length, 3);
    expect(state.residents[0].name, 'Beth Smith');
    expect(state.residents[1].name, 'Rick Sanchez');
    expect(state.residents[2].name, 'Morty Smith');

    // Verify the repo was called with the correct extracted IDs
    verify(() => mockRepo.getCharactersByIds([38, 45, 71])).called(1);
  });

  // ── Test 2: Empty resident URLs → empty character list ────────────
  // Some locations (e.g., "Purge Planet") have 0 residents.
  // The provider should skip the getCharactersByIds call entirely
  // and return an empty list.
  test('returns empty residents when location has no resident URLs', () async {
    final emptyResidentLocation = Location(
      id: 5,
      name: 'Purge Planet',
      type: 'Planet',
      dimension: 'Dimension C-137',
      residentUrls: [],
      url: 'url',
      created: DateTime(2017),
    );

    when(() => mockRepo.getLocationById(5))
        .thenAnswer((_) async => emptyResidentLocation);

    final container = createContainer();
    addTearDown(container.dispose);

    final state = await container.read(locationDetailProvider(5).future);

    expect(state.location.name, 'Purge Planet');
    expect(state.residents, isEmpty);
    // getCharactersByIds should NOT have been called
    verifyNever(() => mockRepo.getCharactersByIds(any()));
  });

  // ── Test 3: Caps residents at maxResidentsOnDetail (6) ────────────
  // Locations like "Earth" have 100+ residents. The provider must
  // only fetch the first 6 to avoid hammering the API and to keep
  // the UI grid manageable.
  test('caps character fetches at maxResidentsOnDetail', () async {
    // 10 resident URLs — more than the cap of 6
    final manyResidentsLocation = Location(
      id: 20,
      name: 'Earth (Replacement Dimension)',
      type: 'Planet',
      dimension: 'Replacement Dimension',
      residentUrls: List.generate(
        10,
        (i) => 'https://rickandmortyapi.com/api/character/${i + 1}',
      ),
      url: 'url',
      created: DateTime(2017),
    );

    // Only the first 6 IDs should be requested
    final first6Characters = List.generate(
      6,
      (i) => Character(
        id: i + 1,
        name: 'Character ${i + 1}',
        status: 'Alive',
        species: 'Human',
        image: 'img',
      ),
    );

    when(() => mockRepo.getLocationById(20))
        .thenAnswer((_) async => manyResidentsLocation);
    when(() => mockRepo.getCharactersByIds([1, 2, 3, 4, 5, 6]))
        .thenAnswer((_) async => first6Characters);

    final container = createContainer();
    addTearDown(container.dispose);

    final state = await container.read(locationDetailProvider(20).future);

    expect(state.residents.length, 6);
    // Characters 7–10 should NOT have been fetched
    verify(() => mockRepo.getCharactersByIds([1, 2, 3, 4, 5, 6])).called(1);
  });

  // ── Test 4: Malformed URLs are safely skipped ─────────────────────
  // _extractIdFromUrl uses Uri.parse + int.tryParse. If a resident
  // URL doesn't end in a numeric segment (e.g., corrupted data),
  // it should be silently dropped via whereType<int>().
  test('skips malformed resident URLs without crashing', () async {
    final badUrlsLocation = Location(
      id: 7,
      name: 'Glitch Dimension',
      type: 'Unknown',
      dimension: 'Unknown',
      residentUrls: [
        'https://rickandmortyapi.com/api/character/38',
        'not-a-url',
        'https://rickandmortyapi.com/api/character/abc', // non-numeric
        'https://rickandmortyapi.com/api/character/45',
      ],
      url: 'url',
      created: DateTime(2017),
    );

    when(() => mockRepo.getLocationById(7))
        .thenAnswer((_) async => badUrlsLocation);
    // Only 38 and 45 are valid IDs
    when(() => mockRepo.getCharactersByIds([38, 45]))
        .thenAnswer((_) async => [
              Character(id: 38, name: 'Beth', status: 'Alive', species: 'Human', image: 'img'),
              Character(id: 45, name: 'Rick', status: 'Alive', species: 'Human', image: 'img'),
            ]);

    final container = createContainer();
    addTearDown(container.dispose);

    final state = await container.read(locationDetailProvider(7).future);

    // 2 valid characters, 2 bad URLs silently dropped
    expect(state.residents.length, 2);
    expect(state.residents[0].name, 'Beth');
    expect(state.residents[1].name, 'Rick');
  });

  // ── Test 5: Repository error propagates as AsyncError ─────────────
  // If getLocationById throws (network error + no cache), the provider
  // should NOT catch it — Riverpod wraps it in AsyncError so the UI
  // can show the ErrorView with a retry button.
  test('propagates repository errors as AsyncError', () async {
    when(() => mockRepo.getLocationById(99))
        .thenThrow(Exception('Server error'));

    final container = createContainer();
    addTearDown(container.dispose);

    expect(
      () => container.read(locationDetailProvider(99).future),
      throwsA(isA<Exception>()),
    );
  });
}
