import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class ResponsiveUnit {
  // Mantenemos los mismos breakpoints de tu diseño
  static const mobileWidth = 600;
  static const tabletWidth = 1150;

  /// Retorna un valor double dependiendo del ancho de la pantalla
  static double get(
    BuildContext context, {
    required double mobile,
    double? tablet,
    required double desktop,
  }) {
    final width = MediaQuery.of(context).size.width;

    // Desktop
    if (width >= tabletWidth) {
      return desktop;
    }

    // Tablet (si no se especifica un valor para tablet, usa el de mobile por defecto)
    if (width >= mobileWidth) {
      return tablet ?? mobile;
    }

    // Mobile
    return mobile;
  }
}