// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$locationDetailHash() => r'5eeccd6cad9a3ddc349764c5e952887c5bbcf17a';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Fetches a single location and its first N residents in parallel.
///
/// Copied from [locationDetail].
@ProviderFor(locationDetail)
const locationDetailProvider = LocationDetailFamily();

/// Fetches a single location and its first N residents in parallel.
///
/// Copied from [locationDetail].
class LocationDetailFamily extends Family<AsyncValue<LocationDetailState>> {
  /// Fetches a single location and its first N residents in parallel.
  ///
  /// Copied from [locationDetail].
  const LocationDetailFamily();

  /// Fetches a single location and its first N residents in parallel.
  ///
  /// Copied from [locationDetail].
  LocationDetailProvider call(int locationId) {
    return LocationDetailProvider(locationId);
  }

  @override
  LocationDetailProvider getProviderOverride(
    covariant LocationDetailProvider provider,
  ) {
    return call(provider.locationId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'locationDetailProvider';
}

/// Fetches a single location and its first N residents in parallel.
///
/// Copied from [locationDetail].
class LocationDetailProvider
    extends AutoDisposeFutureProvider<LocationDetailState> {
  /// Fetches a single location and its first N residents in parallel.
  ///
  /// Copied from [locationDetail].
  LocationDetailProvider(int locationId)
    : this._internal(
        (ref) => locationDetail(ref as LocationDetailRef, locationId),
        from: locationDetailProvider,
        name: r'locationDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$locationDetailHash,
        dependencies: LocationDetailFamily._dependencies,
        allTransitiveDependencies:
            LocationDetailFamily._allTransitiveDependencies,
        locationId: locationId,
      );

  LocationDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.locationId,
  }) : super.internal();

  final int locationId;

  @override
  Override overrideWith(
    FutureOr<LocationDetailState> Function(LocationDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LocationDetailProvider._internal(
        (ref) => create(ref as LocationDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        locationId: locationId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<LocationDetailState> createElement() {
    return _LocationDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LocationDetailProvider && other.locationId == locationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, locationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LocationDetailRef on AutoDisposeFutureProviderRef<LocationDetailState> {
  /// The parameter `locationId` of this provider.
  int get locationId;
}

class _LocationDetailProviderElement
    extends AutoDisposeFutureProviderElement<LocationDetailState>
    with LocationDetailRef {
  _LocationDetailProviderElement(super.provider);

  @override
  int get locationId => (origin as LocationDetailProvider).locationId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
