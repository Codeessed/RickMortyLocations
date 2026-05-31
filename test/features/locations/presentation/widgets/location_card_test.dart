import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rick_morty_flutter/features/locations/domain/entities/location.dart';
import 'package:rick_morty_flutter/features/locations/presentation/widgets/location_card.dart';

/// Widget tests for [LocationCard].
///
/// These run in a headless Flutter test environment — no device needed.
/// We wrap the widget in MaterialApp to provide inherited dependencies
/// (theme, media query, etc.).
void main() {
  // Shared test location used across all tests.
  final testLocation = Location(
    id: 1,
    name: 'Earth (C-137)',
    type: 'Planet',
    dimension: 'Dimension C-137',
    residentUrls: ['url1', 'url2'],
    url: 'https://rickandmortyapi.com/api/location/1',
    created: DateTime(2017, 11, 10),
  );

  // ── Test 1: Renders all three fields ──────────────────────────────
  // The card must display the location name, type (in the chip), and
  // dimension. These are the three pieces of info required by the spec.
  testWidgets('displays location name, type, and dimension', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LocationCard(location: testLocation),
        ),
      ),
    );

    expect(find.text('Earth (C-137)'), findsOneWidget);
    expect(find.text('Planet'), findsOneWidget);
    expect(find.text('Dimension C-137'), findsOneWidget);
  });

  // ── Test 2: onTap callback fires ──────────────────────────────────
  // Tapping the card navigates to the detail screen. We verify the
  // callback is invoked exactly once. In the real app this calls
  // context.go('/location/1').
  testWidgets('onTap callback is triggered when card is tapped',
      (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LocationCard(
            location: testLocation,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(LocationCard));
    expect(tapped, true);
  });

  // ── Test 3: Renders the location icon ─────────────────────────────
  // Each card has a location_on icon on the left side.
  testWidgets('shows location icon', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LocationCard(location: testLocation),
        ),
      ),
    );

    expect(find.byIcon(Icons.location_on_rounded), findsOneWidget);
  });

  // ── Test 4: Renders chevron indicator ─────────────────────────────
  // The right chevron icon tells the user the card is tappable.
  testWidgets('shows chevron right icon', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LocationCard(location: testLocation),
        ),
      ),
    );

    expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);
  });

  // ── Test 5: Long text doesn't overflow ────────────────────────────
  // Location names can be very long (e.g., "Interdimensional Cable
  // Replacement Earth"). The card uses TextOverflow.ellipsis to prevent
  // a RenderFlex overflow error. This test just checks it renders
  // without crashing.
  testWidgets('handles long location name without overflow', (tester) async {
    final longNameLocation = Location(
      id: 99,
      name: 'Very Long Location Name That Should Be Truncated With Ellipsis',
      type: 'Extremely Long Type Name',
      dimension: 'Some Super Long Dimension Name That Goes On And On',
      residentUrls: [],
      url: 'url',
      created: DateTime(2017),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LocationCard(location: longNameLocation),
        ),
      ),
    );

    // No RenderFlex overflow = pass
    expect(find.byType(LocationCard), findsOneWidget);
  });
}
