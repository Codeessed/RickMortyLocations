import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_filter_provider.g.dart';

/// Holds the current search name and type filter values.
class SearchFilterState {
  final String name;
  final String type;

  const SearchFilterState({this.name = '', this.type = ''});

  SearchFilterState copyWith({String? name, String? type}) {
    return SearchFilterState(
      name: name ?? this.name,
      type: type ?? this.type,
    );
  }

  bool get hasActiveFilters => name.isNotEmpty || type.isNotEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchFilterState &&
          other.name == name &&
          other.type == type;

  @override
  int get hashCode => Object.hash(name, type);
}

/// Manages the search name + type filter state.
///
/// Both filters work together — the list provider reacts to changes
/// and re-fetches with both parameters in a single API request.
@Riverpod(keepAlive: true)
class SearchFilterNotifier extends _$SearchFilterNotifier {
  @override
  SearchFilterState build() => const SearchFilterState();

  /// Updates the search name query.
  void setName(String name) {
    state = state.copyWith(name: name);
  }

  /// Updates the type filter.
  void setType(String type) {
    state = state.copyWith(type: type);
  }

  /// Resets both filters to empty.
  void reset() {
    state = const SearchFilterState();
  }
}
