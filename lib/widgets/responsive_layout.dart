import 'package:flutter/material.dart';

/// Responsive Breakpoints
class Responsive {
  static const double mobile = 640;
  static const double tablet = 1024;
  static const double desktop = 1280;
  static const double largeDesktop = 1920;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobile;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobile &&
      MediaQuery.of(context).size.width < desktop;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktop;

  static bool isLargeDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= largeDesktop;

  /// Get number of columns based on screen width
  static int getColumns(BuildContext context, {int max = 4}) {
    final width = MediaQuery.of(context).size.width;
    if (width >= largeDesktop) return max;
    if (width >= desktop) return max > 3 ? 3 : max;
    if (width >= tablet) return 2;
    return 1;
  }

  /// Get responsive padding
  static EdgeInsets getPadding(BuildContext context) {
    if (isDesktop(context)) return const EdgeInsets.all(32);
    if (isTablet(context)) return const EdgeInsets.all(24);
    return const EdgeInsets.all(16);
  }

  /// Get responsive spacing
  static double getSpacing(BuildContext context) {
    if (isDesktop(context)) return 24;
    if (isTablet(context)) return 20;
    return 16;
  }
}

/// Responsive Layout Builder
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= Responsive.desktop) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= Responsive.mobile) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}
