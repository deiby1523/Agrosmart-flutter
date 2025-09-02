import 'package:flutter/material.dart';
import '../app_color_schemes.dart';

class DIconTheme {
  DIconTheme._();

  static IconThemeData lightIconTheme =
      IconThemeData(color: AppColorSchemes.lightScheme.primary, size: 24);

  static IconThemeData darkIconTheme =
      IconThemeData(color: AppColorSchemes.darkScheme.primary, size: 24);
}

