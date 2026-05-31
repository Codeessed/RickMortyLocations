import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../shared/widgets/adaptive_layout.dart';

/// Persistent app shell that wraps all routes.
///
/// On mobile (< 900px):
///   - No navigation rail — screens own their AppBar.
///
/// On desktop (≥ 900px):
///   - A [NavigationRail] is pinned to the left edge.
///   - The current route's content fills the remaining space.
///   - The rail collapses to icons-only when width < 1200px, and
///     expands to icons + labels when width ≥ 1200px.
///
/// The shell is injected via a GoRouter [ShellRoute] so the
/// NavigationRail persists across push/pop navigation.
class AppShell extends StatelessWidget {
  /// The current routed child (provided by [ShellRoute]).
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      mobile: (_) => child,
      tablet: (_) => child,
      desktop: (_) => _DesktopShell(child: child),
    );
  }
}

/// The actual two-column desktop scaffold:
/// [NavigationRail] | [child content]
class _DesktopShell extends StatelessWidget {
  final Widget child;

  const _DesktopShell({required this.child});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    // Show labels when there is enough room
    final extended = width >= 1200;

    // Determine which nav item is active based on current route
    final location = GoRouterState.of(context).uri.toString();
    final selectedIndex = _indexForLocation(location);

    return Scaffold(
      body: Row(
        children: [
          // ── Navigation Rail ────────────────────────────────────────
          NavigationRail(
            extended: extended,
            backgroundColor: AppColors.darkSurface,
            selectedIndex: selectedIndex,
            onDestinationSelected: (i) => _navigate(context, i),
            // Portal-green indicator for selected item
            indicatorColor: AppColors.portalGreen.withValues(alpha: 0.2),
            selectedIconTheme: const IconThemeData(
              color: AppColors.portalGreen,
              size: 24,
            ),
            unselectedIconTheme: IconThemeData(
              color: AppColors.textMuted.withValues(alpha: 0.7),
              size: 24,
            ),
            selectedLabelTextStyle: const TextStyle(
              color: AppColors.portalGreen,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            unselectedLabelTextStyle: TextStyle(
              color: AppColors.textMuted.withValues(alpha: 0.7),
              fontSize: 13,
            ),
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: _RailLogo(extended: extended),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.public_outlined),
                selectedIcon: Icon(Icons.public_rounded),
                label: Text('Locations'),
              ),
            ],
          ),

          // ── Divider ───────────────────────────────────────────────
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: AppColors.divider.withValues(alpha: 0.5),
          ),

          // ── Page content ──────────────────────────────────────────
          Expanded(child: child),
        ],
      ),
    );
  }

  int _indexForLocation(String location) {
    // Only one destination for now; expand when more features are added
    return 0;
  }

  void _navigate(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
    }
  }
}

/// The app logo / brand mark shown at the top of the rail.
///
/// Collapses to an icon-only mark when the rail is not extended.
class _RailLogo extends StatelessWidget {
  final bool extended;

  const _RailLogo({required this.extended});

  @override
  Widget build(BuildContext context) {
    if (extended) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.portalGreen,
                    AppColors.portalGreen.withValues(alpha: 0.3),
                  ],
                ),
              ),
              child: const Icon(
                Icons.blur_circular_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Flexible(
              child: Text(
                'Rick & Morty',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppColors.portalGreen,
            AppColors.portalGreen.withValues(alpha: 0.3),
          ],
        ),
      ),
      child: const Icon(
        Icons.blur_circular_rounded,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}
