import 'package:flutter/material.dart';
import '../app_color_schemes.dart';

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
    iconTheme: IconThemeData(color: Color.fromARGB(255, 51, 51, 51)),
  );

  static const AppBarTheme darkAppBarTheme = AppBarTheme(
    backgroundColor: Color(0xFF1B5E20),
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
