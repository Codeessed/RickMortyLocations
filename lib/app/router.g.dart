// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$routerHash() => r'0e67699a02944733020123977729e4d2ec9e9f0e';

/// Provides the [GoRouter] instance used by [MaterialApp.router].
///
/// Routes (all wrapped by [AppShell] via [ShellRoute]):
///   - `/`              → Location list screen
///   - `/location/:id`  → Location detail screen
///
/// The [ShellRoute] renders [AppShell] as a persistent parent so that
/// the desktop [NavigationRail] survives route transitions without
/// being rebuilt.
///
/// Copied from [router].
@ProviderFor(router)
final routerProvider = Provider<GoRouter>.internal(
  router,
  name: r'routerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$routerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RouterRef = ProviderRef<GoRouter>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
