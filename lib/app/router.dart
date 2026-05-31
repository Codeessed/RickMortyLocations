import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/locations/presentation/screens/location_detail_screen.dart';
import '../features/locations/presentation/screens/location_list_screen.dart';
import 'app_shell.dart';

part 'router.g.dart';

/// Provides the [GoRouter] instance used by [MaterialApp.router].
///
/// Routes (all wrapped by [AppShell] via [ShellRoute]):
///   - `/`              → Location list screen
///   - `/location/:id`  → Location detail screen
///
/// The [ShellRoute] renders [AppShell] as a persistent parent so that
/// the desktop [NavigationRail] survives route transitions without
/// being rebuilt.
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        // AppShell wraps all child routes — injects NavigationRail on desktop
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'locationList',
            builder: (context, state) => const LocationListScreen(),
          ),
          GoRoute(
            path: '/location/:id',
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
