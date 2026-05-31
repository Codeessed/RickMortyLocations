// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_filter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchFilterNotifierHash() =>
    r'578347203767f385bb12b1560d21b5f66b19ef09';

/// Manages the search name + type filter state.
///
/// Both filters work together — the list provider reacts to changes
/// and re-fetches with both parameters in a single API request.
///
/// Copied from [SearchFilterNotifier].
@ProviderFor(SearchFilterNotifier)
final searchFilterNotifierProvider =
    NotifierProvider<SearchFilterNotifier, SearchFilterState>.internal(
      SearchFilterNotifier.new,
      name: r'searchFilterNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$searchFilterNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SearchFilterNotifier = Notifier<SearchFilterState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
