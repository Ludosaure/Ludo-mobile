import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  static const int mobileBreakpoint = 650;
  static const int tabletBreakpoint = 1200;
  
  final Widget mobile;
  final Widget tablet;
  final Widget computer;

  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    required this.tablet,
    required this.computer,
  }) : super(key: key);

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= mobileBreakpoint &&
        MediaQuery.of(context).size.width < tabletBreakpoint;
  }

  static bool isComputer(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < mobileBreakpoint) {
          return mobile;
        } else if (constraints.maxWidth >= mobileBreakpoint && constraints.maxWidth < tabletBreakpoint) {
          return tablet;
        } else {
          return computer;
        }
      },
    );
  }
}
