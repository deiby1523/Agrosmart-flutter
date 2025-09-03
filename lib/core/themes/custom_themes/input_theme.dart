import 'package:flutter/material.dart';
import '../app_color_schemes.dart';

class DInputTheme {
  DInputTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    hintStyle: TextStyle(color: Color.fromARGB(255, 147, 147, 147), fontFamily: 'Inter',fontWeight: FontWeight.w300),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade400),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: AppColorSchemes.lightScheme.primary,
        width: 1.5,
      ),
    ),
    filled: true,
    fillColor: Colors.grey.shade50,
    prefixIconColor: Color.fromARGB(37, 100, 100, 100),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade600),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColorSchemes.darkScheme.primary, width: 2),
    ),
    filled: true,
    fillColor: Colors.grey.shade800,
    hintStyle: TextStyle(color: Color.fromARGB(255, 147, 147, 147), fontFamily: 'Inter',fontWeight: FontWeight.w300),
  );
}
