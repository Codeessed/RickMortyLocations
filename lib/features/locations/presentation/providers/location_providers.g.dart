// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$locationRemoteDataSourceHash() =>
    r'1fbbccaa487f85520102544a4b95a0eb92e7fa06';

/// Provides the Retrofit-based remote data source.
///
/// Copied from [locationRemoteDataSource].
@ProviderFor(locationRemoteDataSource)
final locationRemoteDataSourceProvider =
    Provider<LocationRemoteDataSource>.internal(
      locationRemoteDataSource,
      name: r'locationRemoteDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$locationRemoteDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LocationRemoteDataSourceRef = ProviderRef<LocationRemoteDataSource>;
String _$locationRepositoryHash() =>
    r'b24d20bdf776b8a91405b7b81d3faf28fbcdd184';

/// Provides the repository implementation with caching.
///
/// Copied from [locationRepository].
@ProviderFor(locationRepository)
final locationRepositoryProvider = Provider<LocationRepositoryImpl>.internal(
  locationRepository,
  name: r'locationRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$locationRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LocationRepositoryRef = ProviderRef<LocationRepositoryImpl>;
String _$lastCachedAtHash() => r'473490e365e1bbeb8a1fd4b394ff6c615148d1f0';

/// Provides the last-cached-at timestamp as a reactive stream.
///
/// Copied from [lastCachedAt].
@ProviderFor(lastCachedAt)
final lastCachedAtProvider = AutoDisposeStreamProvider<DateTime?>.internal(
  lastCachedAt,
  name: r'lastCachedAtProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$lastCachedAtHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LastCachedAtRef = AutoDisposeStreamProviderRef<DateTime?>;
String _$locationTypesHash() => r'18107eeb7f9b892d37972c467a9755aef3b66f99';

/// Provides distinct location types for the filter dropdown.
///
/// Copied from [locationTypes].
@ProviderFor(locationTypes)
final locationTypesProvider = AutoDisposeStreamProvider<List<String>>.internal(
  locationTypes,
  name: r'locationTypesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$locationTypesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LocationTypesRef = AutoDisposeStreamProviderRef<List<String>>;
String _$locationListNotifierHash() =>
    r'6cc04b5e86c0b52c8897bdafbd67a5d5fd197bf3';

/// Manages the paginated location list with infinite scroll support.
///
/// Reacts to [SearchFilterNotifier] changes — when filters change,
/// the list is re-fetched from page 1 with both name and type params.
///
/// Copied from [LocationListNotifier].
@ProviderFor(LocationListNotifier)
final locationListNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      LocationListNotifier,
      LocationListState
    >.internal(
      LocationListNotifier.new,
      name: r'locationListNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$locationListNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LocationListNotifier = AutoDisposeAsyncNotifier<LocationListState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
