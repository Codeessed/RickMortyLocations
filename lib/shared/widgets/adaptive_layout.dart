import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

/// Returns `true` when the layout should switch to the desktop/tablet variant.
///
/// Used by all screens via [LayoutBuilder] or [MediaQuery] width checks.
bool isDesktop(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= AppConstants.desktopBreakpoint;

bool isTablet(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= AppConstants.mobileBreakpoint;

/// A widget that builds different layouts based on screen width.
///
/// Eliminates repetitive [LayoutBuilder] boilerplate across screens.
/// Uses [AppConstants.desktopBreakpoint] (900px) as the threshold.
///
/// Example:
/// ```dart
/// AdaptiveLayout(
///   mobile: (ctx) => MobileView(),
///   desktop: (ctx) => DesktopView(),
/// )
/// ```
class AdaptiveLayout extends StatelessWidget {
  /// Widget tree for widths < [AppConstants.mobileBreakpoint] (600px).
  final WidgetBuilder mobile;

  /// Widget tree for widths ≥ [AppConstants.desktopBreakpoint] (900px).
  final WidgetBuilder desktop;

  /// Optional mid-range layout for tablet-width windows.
  /// Falls back to [desktop] if omitted.
  final WidgetBuilder? tablet;

  const AdaptiveLayout({
    super.key,
    required this.mobile,
    required this.desktop,
    this.tablet,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppConstants.desktopBreakpoint) {
          return desktop(context);
        }
        if (constraints.maxWidth >= AppConstants.mobileBreakpoint) {
          return (tablet ?? desktop)(context);
        }
        return mobile(context);
      },
    );
  }
}
