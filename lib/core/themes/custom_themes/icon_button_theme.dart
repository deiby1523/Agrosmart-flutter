import 'package:flutter/material.dart';
import '../app_colors.dart';

class DIconButtonTheme {
  DIconButtonTheme._();

  static BoxDecoration lightContainerEditTheme = BoxDecoration(
    color: Colors.blue.shade50,
    borderRadius: BorderRadius.circular(8),
  );

  static IconThemeData lightEditIconTheme = IconThemeData(
    // color: AppColorSchemes.,
    size: 24,
  );

  static IconThemeData darkEditIconTheme = IconThemeData(
    color: AppColorSchemes.darkScheme.primary,
    size: 24,
  );
}
