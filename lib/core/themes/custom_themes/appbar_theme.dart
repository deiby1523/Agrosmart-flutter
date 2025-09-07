import 'package:flutter/material.dart';
import '../app_colors.dart';

class DAppBarTheme {
  DAppBarTheme._();

  static AppBarTheme lightAppBarTheme = AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: AppColorSchemes.lightScheme.primary,
    surfaceTintColor: Colors.white,
    elevation: 2,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Colors.black87,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    iconTheme: IconThemeData(color: Color.fromARGB(255, 88, 88, 88)),
  );

  static const AppBarTheme darkAppBarTheme = AppBarTheme(
    backgroundColor: Color.fromARGB(255, 21, 53, 23),
    foregroundColor: Colors.white,
    elevation: 2,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  );
}
