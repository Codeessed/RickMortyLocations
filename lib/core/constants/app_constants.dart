/// Central configuration constants for the Rick & Morty app.
///
/// All magic numbers and environment-specific values live here.
/// No other file should hardcode these values.
abstract final class AppConstants {
  // ── API ──────────────────────────────────────────────────────────────
  static const String baseUrl = 'https://rickandmortyapi.com/api';
  static const int pageSize = 20;

  // ── Cache ────────────────────────────────────────────────────────────
  static const Duration cacheTtl = Duration(minutes: 5);

  // ── Responsive Breakpoints ───────────────────────────────────────────
  /// Below this width → single-column mobile layout
  static const double mobileBreakpoint = 600;

  /// At or above this width → two-pane master–detail desktop layout
  static const double desktopBreakpoint = 900;

  // ── Residents ────────────────────────────────────────────────────────
  /// Maximum number of resident avatars shown on the detail screen
  static const int maxResidentsOnDetail = 6;
}
