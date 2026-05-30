<div align="center">

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/b/b1/Rick_and_Morty.svg/1280px-Rick_and_Morty.svg.png" alt="Rick and Morty Logo" width="320"/>

# Rick & Morty — Locations Explorer

> A production-grade Flutter application showcasing **Clean Architecture**, **MVI / MVVM** patterns, **Riverpod** state management, and **Drift** (SQLite) local caching — running natively on **Android**, **iOS**, and **macOS Desktop**.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20macOS-lightgrey)](#platform-support)

</div>

---

## 📱 Screenshots

> _Screenshots will be added here after Task 8 (Desktop Support) is complete._

| Android | iOS | macOS |
|---------|-----|-------|
| _Coming soon_ | _Coming soon_ | _Coming soon_ |

---

## ✨ Features

- **Paginated Location List** — infinite scroll through all Rick & Morty locations
- **Location Detail** — full details + a grid of the first 6 residents with avatar, name, and status badge
- **Offline-First Caching** — Drift (SQLite) stores data locally; stale-while-revalidate keeps it fresh in the background
- **Last Updated Timestamp** — visible on the list screen so you always know how fresh the data is
- **Search & Filter** — combined name search + type filter in a single API call; also queries local cache instantly
- **Graceful State Handling** — every screen handles loading, success, empty, and error states with retry support
- **Adaptive Desktop Layout** — two-pane master/detail layout on macOS with `NavigationRail`
- **Unit & Widget Tests** — full test coverage for the state management layer and key widgets

---

## 🏗 Architecture

This project follows **Clean Architecture** with a **Feature-First** folder structure and an **MVI** (Model–View–Intent) unidirectional data-flow pattern within the presentation layer.

### Layer Diagram

```
┌──────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                    │
│  ┌─────────┐   Intent    ┌──────────────────────────┐   │
│  │  View   │ ──────────▶ │   ViewModel / Notifier   │   │
│  │ (Widget)│ ◀────────── │  (AsyncNotifier/Riverpod)│   │
│  └─────────┘   State     └──────────────────────────┘   │
│                                    │ calls                │
├────────────────────────────────────┼─────────────────────┤
│                  DOMAIN LAYER      │                      │
│           ┌────────────────────────▼──────────────┐      │
│           │           Use Cases / Interactors      │      │
│           │    (pure Dart, zero Flutter deps)      │      │
│           └────────────────────────┬──────────────┘      │
│                                    │ uses abstract        │
│           ┌────────────────────────▼──────────────┐      │
│           │      Repository Interfaces             │      │
│           └────────────────────────┬──────────────┘      │
├────────────────────────────────────┼─────────────────────┤
│                   DATA LAYER       │                      │
│           ┌────────────────────────▼──────────────┐      │
│           │    Repository Implementations          │      │
│           │  (Stale-While-Revalidate strategy)    │      │
│           └──────────┬─────────────────┬──────────┘      │
│                      │                 │                  │
│         ┌────────────▼──┐    ┌─────────▼──────────┐      │
│         │  Remote DS    │    │    Local DS (Drift) │      │
│         │  (Dio+Retrofit│    │   SQLite via Drift  │      │
│         └───────────────┘    └────────────────────┘      │
└──────────────────────────────────────────────────────────┘
```

### Why Clean Architecture?

| Principle | How It Applies |
|-----------|----------------|
| **Single Responsibility** | Each class has one reason to change — `LocationDao` only touches the database, `LocationRemoteDataSource` only speaks HTTP |
| **Open/Closed** | New data sources (GraphQL, WebSocket) can be plugged in by implementing `LocationRepository` without touching existing code |
| **Liskov Substitution** | `LocationRepositoryImpl` is fully substitutable with any mock in tests |
| **Interface Segregation** | `LocationDao` and `CharacterDao` are separate — callers only depend on what they need |
| **Dependency Inversion** | Presentation depends on the abstract `LocationRepository` interface, never on concrete network or DB classes |

### Why MVI (Unidirectional Data Flow)?

```
User Action (Intent)
       │
       ▼
  Notifier processes intent
       │
       ▼
  New State emitted (AsyncValue<T>)
       │
       ▼
  View re-renders deterministically
```

MVI gives us:
- **Predictable state** — no hidden mutations; state transitions are explicit
- **Testability** — given an intent, assert the resulting state
- **Time-travel debugging** — every state change is traceable

### Why Riverpod?

- `AsyncValue<T>` is a first-class union of `loading | data | error` — Task 6 error handling comes for free
- Providers are compile-safe, globally scoped, and override-able in tests without any DI container ceremony
- `AsyncNotifierProvider` + `ref.watch` gives reactive updates without `BuildContext` dependency
- Code-gen (`riverpod_annotation`) removes boilerplate while keeping full type safety

### Why Drift (SQLite)?

| Feature | Drift | Hive |
|---------|-------|------|
| Maintenance | ✅ Actively maintained | ⚠️ Original abandoned (`hive_ce` needed) |
| Reactive streams | ✅ Built-in `Stream<List<T>>` | ❌ Manual polling |
| Relational queries | ✅ SQL + type-safe Dart API | ❌ Key-value only |
| Local search/filter | ✅ `WHERE name LIKE ?` | ❌ Must load all then filter in Dart |
| Desktop support | ✅ SQLite works everywhere | ✅ Pure Dart |
| Test isolation | ✅ `NativeDatabase.memory()` | Requires full setup |

---

## 🛠 Tech Stack

| Concern | Library | Version |
|---------|---------|---------|
| State Management | `flutter_riverpod` + `riverpod_annotation` | ^2.6.1 |
| Navigation | `go_router` | ^14.0.0 |
| Networking | `dio` + `retrofit` | ^5.7.0 / ^4.4.0 |
| Local DB | `drift` + `sqlite3_flutter_libs` | ^2.21.0 |
| Models | `freezed` + `json_serializable` | ^2.5.7 / ^6.9.0 |
| Image Loading | `cached_network_image` | ^3.4.1 |
| Testing | `mocktail` | ^1.0.4 |
| Code Gen | `build_runner`, `drift_dev`, `riverpod_generator` | latest |

---

## 📁 Project Structure

```
lib/
├── main.dart                          # Entry point; Drift init, ProviderScope
├── app/
│   ├── app.dart                       # MaterialApp.router + theme
│   └── router.dart                    # GoRouter route definitions
│
├── core/
│   ├── constants/
│   │   └── app_constants.dart         # Base URL, page size, cache TTL, breakpoints
│   ├── errors/
│   │   └── app_exception.dart         # Sealed exception hierarchy
│   ├── network/
│   │   ├── dio_client.dart            # Dio factory (timeouts, interceptors)
│   │   └── api_interceptor.dart       # Error mapping, logging
│   ├── database/
│   │   ├── app_database.dart          # @DriftDatabase entry point
│   │   ├── tables/
│   │   │   ├── locations_table.dart   # Drift Table: locations
│   │   │   └── characters_table.dart  # Drift Table: characters (FK → locations)
│   │   └── daos/
│   │       ├── location_dao.dart      # upsertLocations, watchLocations, getLastCachedAt
│   │       └── character_dao.dart     # upsertCharacters, getByLocationId
│   └── theme/
│       ├── app_theme.dart             # Dark theme, Rick & Morty palette
│       └── app_text_styles.dart       # Typography tokens
│
├── features/
│   └── locations/
│       ├── data/
│       │   ├── models/
│       │   │   ├── location_model.dart         # Freezed DTO + JSON mapping
│       │   │   ├── character_model.dart         # Freezed DTO
│       │   │   └── location_response_model.dart # Paginated wrapper
│       │   ├── datasources/
│       │   │   ├── location_remote_datasource.dart  # Retrofit interface
│       │   │   └── location_local_datasource.dart   # Drift DAO wrappers
│       │   └── repositories/
│       │       └── location_repository_impl.dart    # Stale-while-revalidate
│       │
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── location.dart       # Pure Dart entity
│       │   │   └── character.dart      # Pure Dart entity
│       │   └── repositories/
│       │       └── location_repository.dart  # Abstract interface
│       │
│       └── presentation/
│           ├── providers/
│           │   ├── location_list_provider.dart    # AsyncNotifier (paginated + filter)
│           │   ├── location_detail_provider.dart  # FutureProvider.family
│           │   └── search_filter_provider.dart    # StateNotifier (name + type)
│           ├── screens/
│           │   ├── location_list_screen.dart
│           │   └── location_detail_screen.dart
│           └── widgets/
│               ├── location_card.dart      # Name, type, dimension
│               ├── resident_grid.dart      # 2–6 column grid (adaptive)
│               ├── resident_chip.dart      # Avatar + name + status
│               ├── search_filter_bar.dart  # Debounced search + type dropdown
│               ├── loading_view.dart       # Shimmer skeleton
│               ├── error_view.dart         # Error + retry button
│               └── empty_view.dart         # Illustration + message
│
└── shared/
    └── widgets/
        ├── last_updated_banner.dart  # "Updated X min ago" strip
        └── status_badge.dart         # Alive / Dead / Unknown pill

test/
├── unit/
│   ├── location_list_notifier_test.dart  # Provider state transitions
│   ├── search_filter_provider_test.dart  # Filter + reset logic
│   └── location_dao_test.dart            # Drift DAO (NativeDatabase.memory)
└── widget/
    └── location_card_test.dart           # Widget rendering test
```

---

## 🚀 Getting Started

### Prerequisites

| Tool | Minimum Version |
|------|----------------|
| Flutter SDK | 3.10.x |
| Dart SDK | 3.x |
| Xcode (iOS/macOS) | 15.x |
| Android Studio | Hedgehog or later |
| CocoaPods | 1.14.x |

### 1. Clone the repository

```bash
git clone https://github.com/<your-username>/rick_morty_flutter.git
cd rick_morty_flutter
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run code generation

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

> **Note:** Run this command whenever you modify any file annotated with `@freezed`, `@riverpod`, `@DriftDatabase`, or `@RestApi`.

### 4. Run the app

```bash
# Android
flutter run -d android

# iOS (requires macOS with Xcode)
flutter run -d ios

# macOS Desktop
flutter run -d macos
```

---

## 🔧 Configuration

All environment constants live in [`lib/core/constants/app_constants.dart`](lib/core/constants/app_constants.dart):

```dart
class AppConstants {
  static const String baseUrl = 'https://rickandmortyapi.com/api';
  static const int pageSize = 20;
  static const Duration cacheTtl = Duration(minutes: 5);
  static const double mobileBreakpoint = 600;
  static const double desktopBreakpoint = 900;
}
```

---

## 🌐 API Reference

This app consumes the public [Rick and Morty API](https://rickandmortyapi.com/documentation).

| Endpoint | Description |
|----------|-------------|
| `GET /location?page=1` | Paginated list of locations |
| `GET /location?name=earth&type=planet` | Filtered locations |
| `GET /location/{id}` | Single location details |
| `GET /character/{id}` | Single character details |

---

## 🧪 Running Tests

```bash
# All tests
flutter test

# With coverage report
flutter test --coverage

# Single test file
flutter test test/unit/location_list_notifier_test.dart

# Static analysis
flutter analyze
```

---

## 📐 Desktop Support

The app is fully functional on **macOS** with an adaptive layout:

| Screen width | Layout |
|-------------|--------|
| < 600px | Single column list |
| 600–899px | 2-column grid |
| ≥ 900px | Two-pane: `NavigationRail` + master–detail |

> Screenshots of the macOS build will be added to this section after Task 8 is complete.

---

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/my-feature`
3. Follow the [coding standards](CODING_STANDARDS.md) — this is mandatory
4. Run `flutter analyze` and `flutter test` before pushing
5. Submit a pull request with a clear description

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

<div align="center">
  Built with ❤️ using Flutter · Powered by the <a href="https://rickandmortyapi.com">Rick and Morty API</a>
</div>
