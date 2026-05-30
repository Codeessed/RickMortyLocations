import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

/// Provides the [GoRouter] instance used by [MaterialApp.router].
///
/// Routes:
///   - `/`              → Location list screen  (placeholder for now)
///   - `/location/:id`  → Location detail screen (placeholder for now)
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'locationList',
        builder: (context, state) => const _PlaceholderScreen(
          title: 'Locations',
        ),
        routes: [
          GoRoute(
            path: 'location/:id',
            name: 'locationDetail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return _PlaceholderScreen(title: 'Location #$id');
            },
          ),
        ],
      ),
    ],
  );
}

/// Temporary placeholder screen — replaced in Task 2 and Task 3.
class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
