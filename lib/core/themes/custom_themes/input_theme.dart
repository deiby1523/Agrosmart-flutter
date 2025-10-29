import 'package:flutter/material.dart';
import '../app_colors.dart';

class DInputTheme {
  DInputTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    // Texto de ayuda y sugerencia
    hintStyle: const TextStyle(
      color: Color(0xFF9E9E9E),
      fontFamily: 'Inter',
      fontWeight: FontWeight.w300,
    ),

    // Bordes más sutiles, minimalistas
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none, // sin borde predeterminado
    ),

    // Relleno suave y limpio
    filled: true,
    fillColor: Colors.grey.shade100,

    // Espaciado interno elegante
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

    // Íconos suaves y consistentes
    prefixIconColor: Colors.grey.shade500,
    suffixIconColor: Colors.grey.shade500,

    // Bordes activos más elegantes (solo cuando se enfoca)
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: AppColorSchemes.lightScheme.primary,
        width: 1.8,
      ),
    ),
    // Bordes cuando está habilitado pero sin enfoque
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColorSchemes.lightError, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColorSchemes.lightError, width: 1),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    hintStyle: const TextStyle(
      color: Color(0xFFB0B0B0),
      fontFamily: 'Inter',
      fontWeight: FontWeight.w300,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    filled: true,
    fillColor: AppColorSchemes.darkBackground.withAlpha(130),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    prefixIconColor: Colors.grey.shade400,
    suffixIconColor: Colors.grey.shade400,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: AppColorSchemes.darkScheme.primary,
        width: 1.8,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade700, width: 1),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColorSchemes.darkError, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColorSchemes.darkError, width: 1),
    ),
  );
}
