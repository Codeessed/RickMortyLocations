import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rick_morty_flutter/features/locations/presentation/providers/search_filter_provider.dart';

/// Tests for [SearchFilterNotifier].
///
/// This is pure state management — no mocks needed. We create a
/// [ProviderContainer] and interact with the notifier directly.
void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  // ── Test 1: Initial state ─────────────────────────────────────────
  // Verifies the provider starts with empty name and type,
  // meaning no filters are active on first load.
  test('initial state has empty name and type', () {
    final state = container.read(searchFilterNotifierProvider);
    expect(state.name, '');
    expect(state.type, '');
    expect(state.hasActiveFilters, false);
  });

  // ── Test 2: setName ───────────────────────────────────────────────
  // Verifies that calling setName('Earth') updates only the name field
  // and leaves type untouched. This is critical because both filters
  // must work independently.
  test('setName updates name and marks filters as active', () {
    container
        .read(searchFilterNotifierProvider.notifier)
        .setName('Earth');

    final state = container.read(searchFilterNotifierProvider);
    expect(state.name, 'Earth');
    expect(state.type, '');           // type unchanged
    expect(state.hasActiveFilters, true);
  });

  // ── Test 3: setType ───────────────────────────────────────────────
  // Same as above but for type. Verifies independence of the two fields.
  test('setType updates type and marks filters as active', () {
    container
        .read(searchFilterNotifierProvider.notifier)
        .setType('Planet');

    final state = container.read(searchFilterNotifierProvider);
    expect(state.name, '');           // name unchanged
    expect(state.type, 'Planet');
    expect(state.hasActiveFilters, true);
  });

  // ── Test 4: Both filters together ─────────────────────────────────
  // The API supports both ?name=X&type=Y in a single request.
  // This test ensures both fields can be set simultaneously.
  test('setName and setType work together', () {
    final notifier = container.read(searchFilterNotifierProvider.notifier);
    notifier.setName('Citadel');
    notifier.setType('Space station');

    final state = container.read(searchFilterNotifierProvider);
    expect(state.name, 'Citadel');
    expect(state.type, 'Space station');
    expect(state.hasActiveFilters, true);
  });

  // ── Test 5: reset ─────────────────────────────────────────────────
  // After setting both filters, reset() must clear everything back to
  // the initial state. The list screen calls this when the user taps
  // the clear (X) button.
  test('reset clears both name and type', () {
    final notifier = container.read(searchFilterNotifierProvider.notifier);
    notifier.setName('Earth');
    notifier.setType('Planet');
    notifier.reset();

    final state = container.read(searchFilterNotifierProvider);
    expect(state.name, '');
    expect(state.type, '');
    expect(state.hasActiveFilters, false);
  });

  // ── Test 6: Equality ──────────────────────────────────────────────
  // SearchFilterState overrides == so that Riverpod can skip redundant
  // rebuilds when the same filter values are set again. This test
  // verifies that two states with identical values are considered equal.
  test('states with same values are equal', () {
    const a = SearchFilterState(name: 'Earth', type: 'Planet');
    const b = SearchFilterState(name: 'Earth', type: 'Planet');
    expect(a, equals(b));
    expect(a.hashCode, equals(b.hashCode));
  });

  // ── Test 7: Inequality ────────────────────────────────────────────
  // The flip side: different values must NOT be equal, otherwise
  // Riverpod would skip necessary rebuilds.
  test('states with different values are not equal', () {
    const a = SearchFilterState(name: 'Earth', type: 'Planet');
    const b = SearchFilterState(name: 'Mars', type: 'Planet');
    expect(a, isNot(equals(b)));
  });
}
