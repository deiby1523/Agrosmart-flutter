import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  static const mobileWidth = 600;
  static const tabletWidth = 1024;

  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileWidth;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < tabletWidth &&
      MediaQuery.of(context).size.width >= mobileWidth;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletWidth;

  @override
  Widget build(BuildContext context) {
    Widget widget;
    final Size size = MediaQuery.of(context).size;
    if (size.width >= tabletWidth) {
      widget = desktop;
    } else if (size.width >= mobileWidth && tablet != null) {
      widget = tablet!;
    } else {
      widget = mobile;
    }
    return widget;
  }
}
