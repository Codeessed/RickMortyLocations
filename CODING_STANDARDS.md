# Coding Standards & Architecture Guidelines

> **This document is mandatory.** Every contributor — human or AI — must follow these rules without exception.  
> When in doubt, ask. When in conflict, this document wins.

---

## Table of Contents

1. [Architecture Overview](#1-architecture-overview)
2. [Layer Rules](#2-layer-rules)
3. [MVI / MVVM Pattern](#3-mvi--mvvm-pattern)
4. [SOLID Principles — Applied](#4-solid-principles--applied)
5. [Project Structure](#5-project-structure)
6. [State Management (Riverpod)](#6-state-management-riverpod)
7. [Database Layer (Drift)](#7-database-layer-drift)
8. [Networking Layer (Dio + Retrofit)](#8-networking-layer-dio--retrofit)
9. [Error Handling](#9-error-handling)
10. [Naming Conventions](#10-naming-conventions)
11. [File Organisation Rules](#11-file-organisation-rules)
12. [Testing Standards](#12-testing-standards)
13. [Code Quality Gates](#13-code-quality-gates)
14. [Git Workflow](#14-git-workflow)
15. [Platform-Specific Rules (Desktop)](#15-platform-specific-rules-desktop)

---

## 1. Architecture Overview

This project uses **Clean Architecture** with a **Feature-First** folder structure. The three layers are:

```
Presentation  ──depends on──▶  Domain  ◀──depends on──  Data
    (UI)                    (pure Dart)               (network/db)
```

**The Dependency Rule is absolute:**
> Source code dependencies must always point **inward** toward Domain.  
> Domain knows nothing about Flutter, Dio, Drift, or any external framework.

```
✅  Presentation → Domain
✅  Data         → Domain
❌  Domain       → Presentation  (NEVER)
❌  Domain       → Data          (NEVER)
❌  Presentation → Data          (NEVER — always go through Domain)
```

---

## 2. Layer Rules

### 2.1 Domain Layer (`features/<name>/domain/`)

- **Pure Dart only.** No `import 'package:flutter/...` allowed here.
- Contains:
  - **Entities** — immutable plain Dart classes (use `freezed` or manual `const` constructors)
  - **Repository interfaces** — abstract classes that define the contract
  - **Use Cases / Interactors** — optional for this project; add only when business logic is non-trivial
- Entities **must not** contain JSON serialization (`fromJson`, `toJson`). That belongs in the Data layer models.

```dart
// ✅ CORRECT — Domain entity
@freezed
class Location with _$Location {
  const factory Location({
    required int id,
    required String name,
    required String type,
    required String dimension,
    required List<String> residentUrls,
    required DateTime created,
  }) = _Location;
}

// ❌ WRONG — JSON in domain entity
class Location {
  factory Location.fromJson(Map<String, dynamic> json) { ... } // belongs in Data layer
}
```

### 2.2 Data Layer (`features/<name>/data/`)

- Implements domain repository interfaces
- Contains:
  - **DTOs / Models** — data transfer objects with JSON serialization (`freezed` + `json_serializable`)
  - **Data Sources** — one remote (`Retrofit`), one local (`Drift DAO` wrappers)
  - **Mappers** — convert between DTOs and domain entities (can be extension methods or top-level functions)
  - **Repository implementations** — implement the domain interface; apply caching strategy here

```dart
// ✅ CORRECT — Data model with mapper
@freezed
class LocationModel with _$LocationModel {
  const factory LocationModel({
    required int id,
    @JsonKey(name: 'name') required String name,
    // ...
  }) = _LocationModel;

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);
}

extension LocationModelMapper on LocationModel {
  Location toEntity() => Location(id: id, name: name, ...);
}
```

### 2.3 Presentation Layer (`features/<name>/presentation/`)

- Contains:
  - **Providers** — Riverpod `AsyncNotifier` or `Notifier` classes
  - **Screens** — full-page widgets; each screen corresponds to a route
  - **Widgets** — reusable UI components; should be as stateless as possible
- Screens must **only** interact with Domain via Riverpod providers — never call Data layer directly.

---

## 3. MVI / MVVM Pattern

### Pattern Choice

We use **MVI (Model–View–Intent)** with Riverpod as the intent processor:

```
 ┌──────────┐  Intent (method call)  ┌──────────────────────────┐
 │   View   │ ─────────────────────▶ │  Notifier (ViewModel)    │
 │ (Widget) │ ◀───────────────────── │  AsyncValue<State>        │
 └──────────┘    State (rebuild)     └──────────────────────────┘
                                              │
                                    calls Repository (Domain)
```

### Rules

1. **Views are dumb.** Widgets only render state and emit intents. No business logic in `build()`.
2. **Notifiers process intents.** All `onTap`, `onSearchChanged`, `onLoadMore` etc. are delegated to the Notifier.
3. **State is immutable.** Use `freezed` states. Never mutate state in place — always emit a new state.
4. **One source of truth.** A piece of state lives in exactly one provider — never duplicated.

```dart
// ✅ CORRECT — thin View
ref.watch(locationListProvider).when(
  loading: () => const LoadingView(),
  error: (e, _) => ErrorView(
    message: e.toString(),
    onRetry: () => ref.refresh(locationListProvider),
  ),
  data: (locations) => LocationList(locations: locations),
);

// ❌ WRONG — logic in widget
if (locations.isNotEmpty && !isLoading && page > 1) { ... } // belongs in Notifier
```

---

## 4. SOLID Principles — Applied

### S — Single Responsibility

- Each class/file has **one reason to change**.
- `LocationDao` only reads/writes the database.
- `LocationRemoteDataSource` only makes HTTP calls.
- `LocationListNotifier` only manages list state and pagination.
- `LocationCard` only renders one location card.

**Checklist before merging:** Can you describe this class's purpose in one sentence without using "and"?

### O — Open / Closed

- Extend behaviour via new implementations of existing interfaces, not by modifying existing classes.
- Adding a new data source (GraphQL, WebSocket) = create a new class that implements `LocationRepository`. **Do not touch** `LocationRepositoryImpl`.

### L — Liskov Substitution

- Every implementation of an abstract class must be a perfect substitute.
- If `LocationRepositoryImpl` is replaced by `MockLocationRepository` in a test, the app should behave correctly.
- **Never** narrow the contract in an override (e.g., throwing exceptions the interface didn't declare).

### I — Interface Segregation

- Keep interfaces small and focused.
- `LocationRepository` should not expose database-specific methods.
- If only some callers need `getLastCachedAt()`, it belongs in `LocationDao`, not in `LocationRepository`.

### D — Dependency Inversion

- High-level modules (`LocationListNotifier`) depend on abstractions (`LocationRepository`), not concretions (`LocationRepositoryImpl`).
- Inject dependencies via constructor parameters or Riverpod provider overrides — **never** instantiate inside a class.

```dart
// ✅ CORRECT
class LocationListNotifier extends AsyncNotifier<List<Location>> {
  @override
  Future<List<Location>> build() async {
    final repo = ref.read(locationRepositoryProvider); // injected via Riverpod
    return repo.getLocations(page: 1);
  }
}

// ❌ WRONG
class LocationListNotifier extends AsyncNotifier<List<Location>> {
  final _repo = LocationRepositoryImpl(dio: Dio()); // direct instantiation
}
```

---

## 5. Project Structure

```
lib/
├── main.dart
├── app/
│   ├── app.dart                        # App root widget
│   └── router.dart                     # GoRouter configuration
│
├── core/                               # Shared infrastructure (no feature-specific code here)
│   ├── constants/app_constants.dart
│   ├── errors/app_exception.dart
│   ├── network/
│   │   ├── dio_client.dart
│   │   └── api_interceptor.dart
│   ├── database/
│   │   ├── app_database.dart
│   │   ├── tables/
│   │   │   ├── locations_table.dart
│   │   │   └── characters_table.dart
│   │   └── daos/
│   │       ├── location_dao.dart
│   │       └── character_dao.dart
│   └── theme/
│       ├── app_theme.dart
│       └── app_text_styles.dart
│
├── features/
│   └── <feature_name>/                 # One directory per feature
│       ├── data/
│       │   ├── models/                 # DTOs (freezed + json_serializable)
│       │   ├── datasources/            # remote + local data sources
│       │   └── repositories/           # Repository implementations
│       ├── domain/
│       │   ├── entities/               # Pure Dart entities
│       │   └── repositories/           # Abstract interfaces
│       └── presentation/
│           ├── providers/              # Riverpod providers + notifiers
│           ├── screens/                # One file = one screen
│           └── widgets/                # Reusable feature widgets
│
└── shared/
    └── widgets/                        # Widgets used across multiple features
```

### Rules

- **No cross-feature imports.** `features/locations/` must never import from `features/profile/`.
- **Shared code** goes in `shared/` or `core/` — never in a feature folder.
- **One screen per file.** Never put two screens in the same file.
- **Barrel files** (`index.dart`) are allowed per-layer to clean up imports.

---

## 6. State Management (Riverpod)

### Provider Types

| Use case | Provider type |
|----------|--------------|
| Async data (fetch + load) | `AsyncNotifierProvider` |
| Derived/computed values | `Provider` or `FutureProvider` |
| Simple state (search query, filter) | `NotifierProvider` |
| Per-item detail | `FutureProvider.family` |
| Global singleton (DB, Dio) | `Provider` |

### Rules

1. **Always use code-gen** (`@riverpod` annotation). Do not write manual `Provider(...)` declarations.
2. **Never use `ref.read` inside `build()`** — use `ref.watch` for reactive dependencies.
3. **Use `ref.read` only in callbacks** (button taps, timer callbacks).
4. **Expose `AsyncValue<T>`** from `AsyncNotifierProvider` — never manually create loading/error booleans.
5. **Keep providers lean** — move business logic to the Domain layer (Use Cases / Repository).

```dart
// ✅ CORRECT
@riverpod
class LocationListNotifier extends _$LocationListNotifier {
  @override
  Future<List<Location>> build() async => _fetch(page: 1);

  Future<void> loadMore() async { ... }
  void applyFilter(String name, String type) { ... }
}

// ❌ WRONG — manual loading state
class LocationListNotifier extends ChangeNotifier {
  bool isLoading = false;
  List<Location> locations = [];
  String? error;
  // ... manual state machine
}
```

---

## 7. Database Layer (Drift)

### Table Design

- Every table class extends `Table` and lives in `core/database/tables/`.
- Always define a `primaryKey` override.
- Use `DateTimeColumn` (not `TextColumn`) for timestamps — Drift handles serialization.
- Soft deletes: add a `deletedAt` column if rows need to be recoverable.

### DAO Rules

- Every DAO is annotated with `@DriftAccessor(tables: [...])`.
- DAOs live in `core/database/daos/`.
- **Reactive queries must return `Stream<T>`** — use `watch()` variants, not `get()`, when the UI needs live updates.
- Batch inserts must use `insertOrReplace` (`InsertMode.insertOrReplace`) — never insert then update separately.
- **Never write raw SQL strings** unless there is no Drift API equivalent.

```dart
// ✅ CORRECT — reactive watch
Stream<List<LocationData>> watchLocations({String? name, String? type}) {
  final query = select(locations);
  if (name != null && name.isNotEmpty) {
    query.where((t) => t.name.like('%$name%'));
  }
  if (type != null && type.isNotEmpty) {
    query.where((t) => t.type.equals(type));
  }
  return query.watch();
}

// ❌ WRONG — polling
Future<List<LocationData>> getLocations() => select(locations).get();
// then Timer.periodic(() => refetch()) in the widget
```

### Caching Strategy: Stale-While-Revalidate

```
Repository.getLocations(page):
  1. Immediately emit cached rows from Drift stream
  2. Check cachedAt: if older than TTL (5 min):
       → fetch from network in background
       → upsert into Drift
       → stream auto-emits updated data to UI
  3. On network error with valid cache: show cache, show error snack bar
  4. On network error with empty cache: emit error state
```

---

## 8. Networking Layer (Dio + Retrofit)

- All API interfaces are annotated with `@RestApi` and live in `data/datasources/`.
- Query parameters are annotated with `@Query` — never build URL strings manually.
- Dio instance is created once in `core/network/dio_client.dart` and injected via a Riverpod `Provider`.
- `ApiInterceptor` handles:
  - Request/response logging (debug only)
  - `DioException` → `AppException` mapping
  - Timeout configuration

```dart
// ✅ CORRECT
@RestApi()
abstract class LocationRemoteDataSource {
  @GET('/location')
  Future<LocationResponseModel> getLocations({
    @Query('page') required int page,
    @Query('name') String? name,
    @Query('type') String? type,
  });
}

// ❌ WRONG
final response = await dio.get(
  'https://rickandmortyapi.com/api/location?page=$page&name=$name',
);
```

---

## 9. Error Handling

### Exception Hierarchy

All exceptions in this app are typed using a sealed class:

```dart
sealed class AppException implements Exception {
  const AppException();
}

final class NetworkException extends AppException {
  final String message;
  final int? statusCode;
  const NetworkException({required this.message, this.statusCode});
}

final class NotFoundException extends AppException {
  const NotFoundException();
}

final class CacheException extends AppException {
  final String message;
  const CacheException({required this.message});
}

final class UnknownException extends AppException {
  final Object cause;
  const UnknownException({required this.cause});
}
```

### Rules

1. **Never throw raw `Exception` or `String`** — always throw a typed `AppException`.
2. **Catch at the repository boundary** — data sources throw, repositories catch and re-throw as `AppException`.
3. **Never catch in widgets** — `AsyncValue.error` handles this automatically.
4. **Pagination errors** must not erase already-loaded data — show a `SnackBar` with retry instead.

```dart
// ✅ CORRECT — catch at repository, not widget
try {
  final data = await remoteDataSource.getLocations(page: page);
  return data.results.map((m) => m.toEntity()).toList();
} on DioException catch (e) {
  throw NetworkException(message: e.message ?? 'Network error', statusCode: e.response?.statusCode);
}

// ❌ WRONG — catching in widget
try {
  await ref.read(locationListProvider.notifier).loadMore();
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(...);
}
```

---

## 10. Naming Conventions

### Files

| Type | Convention | Example |
|------|-----------|---------|
| Screen | `snake_case_screen.dart` | `location_list_screen.dart` |
| Widget | `snake_case.dart` | `location_card.dart` |
| Provider | `snake_case_provider.dart` | `location_list_provider.dart` |
| Entity | `snake_case.dart` | `location.dart` |
| Model (DTO) | `snake_case_model.dart` | `location_model.dart` |
| Repository | `snake_case_repository.dart` | `location_repository.dart` |
| DAO | `snake_case_dao.dart` | `location_dao.dart` |
| Test | mirror the source file + `_test` | `location_list_provider_test.dart` |

### Classes & Types

| Type | Convention | Example |
|------|-----------|---------|
| Class | `PascalCase` | `LocationListNotifier` |
| Enum | `PascalCase` | `LocationStatus` |
| Enum value | `camelCase` | `LocationStatus.alive` |
| Extension | `PascalCaseExtension` | `LocationModelMapper` |
| Mixin | `PascalCase` | `PaginationMixin` |

### Variables & Methods

| Type | Convention | Example |
|------|-----------|---------|
| Variable | `camelCase` | `currentPage` |
| Private | `_camelCase` | `_hasNextPage` |
| Constant | `camelCase` (in class) | `AppConstants.pageSize` |
| Method | `camelCase` | `loadMore()` |
| Boolean | starts with `is`, `has`, `can` | `isLoading`, `hasNextPage` |

### Providers (Riverpod code-gen)

- Provider functions use `camelCase`.
- The generated provider is `camelCaseProvider`.
- Notifier classes use `PascalCaseNotifier`.

```dart
@riverpod
class LocationListNotifier extends _$LocationListNotifier { ... }
// ↓ generates: locationListNotifierProvider
```

---

## 11. File Organisation Rules

1. **Imports order** (enforced by `flutter_lints`):
   ```dart
   // 1. Dart SDK
   import 'dart:async';
   // 2. Flutter
   import 'package:flutter/material.dart';
   // 3. Third-party packages (alphabetical)
   import 'package:dio/dio.dart';
   import 'package:riverpod_annotation/riverpod_annotation.dart';
   // 4. Local packages (relative paths)
   import '../domain/entities/location.dart';
   ```

2. **One public class per file.** Private helpers are allowed in the same file.
3. **Generated files** (`.g.dart`, `.freezed.dart`) must **never** be manually edited.
4. **No magic numbers.** Use `AppConstants` or named constants:
   ```dart
   // ❌ WRONG
   if (residents.length > 6) { ... }
   // ✅ CORRECT
   if (residents.length > AppConstants.maxResidentsOnDetail) { ... }
   ```

---

## 12. Testing Standards

### Coverage Requirements

| Layer | Minimum Coverage |
|-------|-----------------|
| Domain Entities | 100% (simple, always test) |
| Riverpod Notifiers | 80% |
| Repository logic | 80% |
| Drift DAOs | 80% |
| Widgets | ≥ 1 widget test per screen |

### Unit Test Rules

1. **Use `mocktail`** for mocking — no `mockito` code-gen.
2. **Use `ProviderContainer`** with `overrides` to test Riverpod providers in isolation.
3. **Use `NativeDatabase.memory()`** for Drift DAO tests — never mock the DAO itself in DAO tests.
4. Every test file mirrors the source file structure: `test/unit/features/locations/...`

```dart
// ✅ CORRECT — Notifier test
test('loadMore appends results and increments page', () async {
  final container = ProviderContainer(overrides: [
    locationRepositoryProvider.overrideWithValue(MockLocationRepository()),
  ]);
  // arrange
  when(() => mockRepo.getLocations(page: 1)).thenAnswer(...);
  // act
  await container.read(locationListNotifierProvider.future);
  // assert
  expect(container.read(locationListNotifierProvider).value?.length, equals(20));
});
```

### Widget Test Rules

1. Wrap the widget under test in `ProviderScope` with overridden providers.
2. Use `find.byType` and `find.text` — avoid `find.byKey` unless necessary.
3. Test user interactions with `tester.tap` + `tester.pumpAndSettle`.

---

## 13. Code Quality Gates

Every PR must pass all of these before merging:

```bash
# 1. Static analysis — zero warnings, zero errors
flutter analyze

# 2. All tests pass
flutter test

# 3. Code formatting
dart format . --set-exit-if-changed

# 4. Build runner is clean (no stale generated files)
flutter pub run build_runner build --delete-conflicting-outputs
flutter analyze  # run again after generation
```

**Do not bypass these gates.** If a lint warning is intentional, add a targeted `// ignore:` comment with a justification.

---

## 14. Git Workflow

### Branch Naming

```
feature/<task-n>-<short-description>
chore/<description>
fix/<short-description>
refactor/<short-description>
test/<short-description>
```

Examples:
- `feature/task-2-location-list`
- `chore/project_setup`
- `fix/pagination-crash-on-empty-response`

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <short summary>

[optional body]
[optional footer]
```

| Type | When to use |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `chore` | Build/tooling/dependency updates |
| `refactor` | Code change that neither fixes a bug nor adds a feature |
| `test` | Adding or updating tests |
| `docs` | Documentation changes only |
| `style` | Formatting, missing semicolons — no logic changes |

Examples:
```
feat(locations): add paginated location list with infinite scroll
fix(cache): return null from DAO when cachedAt exceeds TTL
chore(deps): update drift to 2.21.0
test(providers): add unit tests for locationListNotifier loadMore
```

### PR Rules

1. PRs are **small and focused** — one task = one PR.
2. Every PR must include a description of **what changed** and **why**.
3. All CI checks must pass before merging.
4. Squash commits on merge to keep history clean.

---

## 15. Platform-Specific Rules (Desktop)

### Adaptive Breakpoints

```dart
// Defined in AppConstants
static const double mobileBreakpoint  = 600;   // < 600: single column
static const double tabletBreakpoint  = 900;   // 600–899: 2-column grid
// ≥ 900: two-pane master–detail
```

### Layout Rules

- Use `LayoutBuilder` or `MediaQuery.sizeOf(context)` — never hardcode sizes.
- Desktop navigation uses `NavigationRail`, not `BottomNavigationBar`.
- Touch targets on desktop can be smaller (40×40 dp vs 48×48 dp on mobile) — use `MouseRegion` for hover states.
- Scrollbars must be visible on desktop: wrap scrollable content in `Scrollbar(...)`.
- Right-click context menus and keyboard shortcuts are a bonus — not required.

```dart
// ✅ CORRECT — adaptive layout
Widget build(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width >= AppConstants.desktopBreakpoint) {
    return _DesktopLayout();
  } else if (width >= AppConstants.mobileBreakpoint) {
    return _TabletLayout();
  }
  return _MobileLayout();
}
```

---

## Quick Reference Checklist

Before opening a PR, verify:

- [ ] No Flutter imports in the Domain layer
- [ ] No direct instantiation of concrete classes (use Riverpod DI)
- [ ] All exceptions are typed `AppException` subclasses
- [ ] All Drift queries use `watch()` for reactive data
- [ ] All API endpoints use Retrofit annotations, not raw Dio calls
- [ ] All states exposed via `AsyncValue<T>`, not manual `isLoading` booleans
- [ ] `flutter analyze` passes with zero issues
- [ ] `flutter test` passes with zero failures
- [ ] Commit message follows Conventional Commits format
- [ ] Branch name follows the naming convention

---

> _"Clean code always looks like it was written by someone who cares."_ — Robert C. Martin
