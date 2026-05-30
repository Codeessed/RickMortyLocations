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
    r'1e3b95c73d2c4b95049547e62fdbfc0723650c46';

/// Provides the repository implementation.
///
/// Copied from [locationRepository].
@ProviderFor(locationRepository)
final locationRepositoryProvider = Provider<LocationRepository>.internal(
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
typedef LocationRepositoryRef = ProviderRef<LocationRepository>;
String _$locationListNotifierHash() =>
    r'1bc25a37baa980c4603316085eea06bd87ed027d';

/// Manages the paginated location list with infinite scroll support.
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
