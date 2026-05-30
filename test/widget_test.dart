import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rick_morty_flutter/features/locations/domain/entities/location.dart';
import 'package:rick_morty_flutter/features/locations/domain/repositories/location_repository.dart';
import 'package:rick_morty_flutter/features/locations/presentation/providers/location_providers.dart';
import 'package:rick_morty_flutter/features/locations/presentation/widgets/location_card.dart';

void main() {
  testWidgets('LocationCard displays name, type, and dimension', (tester) async {
    final location = Location(
      id: 1,
      name: 'Earth (C-137)',
      type: 'Planet',
      dimension: 'Dimension C-137',
      residentUrls: [],
      url: 'https://rickandmortyapi.com/api/location/1',
      created: DateTime(2017, 11, 10),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LocationCard(location: location),
        ),
      ),
    );

    expect(find.text('Earth (C-137)'), findsOneWidget);
    expect(find.text('Planet'), findsOneWidget);
    expect(find.text('Dimension C-137'), findsOneWidget);
  });
}
