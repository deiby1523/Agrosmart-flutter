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
    color: Color.fromARGB(255, 49, 49, 49),
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    margin: EdgeInsets.all(8),
  );
}
