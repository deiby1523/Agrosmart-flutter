import 'package:flutter/material.dart';
import '../app_color_schemes.dart';

class DChipTheme {
  DChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    backgroundColor: Colors.grey.shade100,
    selectedColor: AppColorSchemes.lightScheme.primary.withValues(alpha: 20),
    labelStyle: const TextStyle(color: Colors.black87),
    secondaryLabelStyle: const TextStyle(color: Colors.white),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );

  static ChipThemeData darkChipTheme = ChipThemeData(
    backgroundColor: Colors.grey.shade800,
    selectedColor: AppColorSchemes.darkScheme.primary.withAlpha(20),
    labelStyle: const TextStyle(color: Colors.white),
    secondaryLabelStyle: const TextStyle(color: Colors.black),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );
}
