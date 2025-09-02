import 'package:flutter/material.dart';

class DCardTheme {
  DCardTheme._();
  static const CardThemeData lightCardTheme = CardThemeData(
    color: Colors.white,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    margin: EdgeInsets.all(8),
  );

  static const CardThemeData darkCardTheme = CardThemeData(
    color: Color(0xFF1F1F1F),
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    margin: EdgeInsets.all(8),
  );
}
