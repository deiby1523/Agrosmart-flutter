import 'package:flutter/material.dart';

class AppColorSchemes {
  static const ColorScheme lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromARGB(255, 104, 190, 51), // Verde principal
    onPrimary: Colors.white,
    secondary: Color(0xFF8D6E63), // Marrón tierra
    onSecondary: Colors.white,
    tertiary: Color(0xFF81D4FA), // Azul cielo suave
    onTertiary: Colors.black,
    error: Color(0xFFD32F2F),
    onError: Colors.white,
    background: Color(0xFFF9FBE7), // Verde muy pálido
    onBackground: Color(0xFF1B5E20),
    surface: Colors.white,
    onSurface: Color(0xFF212121),
    
  );

  static const ColorScheme darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF81C784), // Verde más suave
    onPrimary: Colors.black,
    secondary: Color(0xFF6D4C41), // Marrón oscuro
    onSecondary: Colors.white,
    tertiary: Color(0xFF4FC3F7), // Azul más vivo
    onTertiary: Colors.black,
    error: Color(0xFFEF5350),
    onError: Colors.black,
    background: Color(0xFF121212),
    onBackground: Colors.white,
    surface: Color(0xFF1E1E1E),
    onSurface: Colors.white,
  );
}
