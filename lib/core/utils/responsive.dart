// =============================================================================
// RESPONSIVE - Widget para Diseño Adaptativo
// =============================================================================
// Widget que renderiza diferentes interfaces basado en el tamaño de pantalla.
//
// Breakpoints:
// - Mobile: < 600px
// - Tablet: 600px - 1023px
// - Desktop: >= 1024px
// =============================================================================

import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  // Breakpoints para dispositivos
  static const mobileWidth = 600;
  static const tabletWidth = 1150;

  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  // Métodos estáticos para verificar el tipo de dispositivo
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileWidth;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileWidth && width < tabletWidth;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletWidth;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Desktop
    if (width >= tabletWidth) {
      return desktop;
    }

    // Tablet (si existe)
    if (width >= mobileWidth && tablet != null) {
      return tablet!;
    }

    // Mobile
    return mobile;
  }
}
