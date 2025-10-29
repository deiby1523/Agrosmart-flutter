import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class DCardTheme {
  DCardTheme._();
  static const CardThemeData lightCardTheme = CardThemeData(
    color: AppColorSchemes.lightCard,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    margin: EdgeInsets.all(8),
  );

  static const CardThemeData darkCardTheme = CardThemeData(
    color: AppColorSchemes.darkCard,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    margin: EdgeInsets.all(8),
  );
}
