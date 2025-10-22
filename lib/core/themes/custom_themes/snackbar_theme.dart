import 'package:flutter/material.dart';
import '../app_colors.dart';

class DSnackbarTheme {
  DSnackbarTheme._();

  static SnackBarThemeData lightSnackBarTheme = SnackBarThemeData(
    backgroundColor: const Color.fromARGB(255, 234, 255, 240),
    contentTextStyle: TextStyle(color: AppColorSchemes.lightText),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    insetPadding: EdgeInsets.only(bottom: 16, right: 16, left: 16),
    // margin: const EdgeInsets.only(bottom: 16, right: 16, left: 16),
  );

  static SnackBarThemeData darkSnackBarTheme = SnackBarThemeData(
    backgroundColor: const Color.fromARGB(255, 7, 64, 23),
    contentTextStyle: TextStyle(color: AppColorSchemes.darkText),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    insetPadding: EdgeInsets.only(bottom: 16, right: 16, left: 16),
    // margin: const EdgeInsets.only(bottom: 16, right: 16, left: 16),
  );
}
