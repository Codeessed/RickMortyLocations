import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/locations/presentation/screens/location_detail_screen.dart';
import '../features/locations/presentation/screens/location_list_screen.dart';

part 'router.g.dart';

/// Provides the [GoRouter] instance used by [MaterialApp.router].
///
/// Routes:
///   - `/`              → Location list screen
///   - `/location/:id`  → Location detail screen
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'locationList',
        builder: (context, state) => const LocationListScreen(),
        routes: [
          GoRoute(
            path: 'location/:id',
            name: 'locationDetail',
            builder: (context, state) {
              final id = int.parse(state.pathParameters['id']!);
              return LocationDetailScreen(locationId: id);
            },
          ),
        ],
      ),
    ],
  );
}
