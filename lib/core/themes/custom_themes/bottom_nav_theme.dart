import 'package:flutter/material.dart';
import '../app_colors.dart';

class DBottomNavTheme {
  DBottomNavTheme._();

  static BottomNavigationBarThemeData lightBottomNavTheme =
      BottomNavigationBarThemeData(
        backgroundColor: AppColorSchemes.lightScheme.surface,
        selectedItemColor: AppColorSchemes.lightScheme.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
      );

  static BottomNavigationBarThemeData darkBottomNavTheme =
      BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1F1F1F),
        selectedItemColor: AppColorSchemes.darkScheme.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
      );
}
