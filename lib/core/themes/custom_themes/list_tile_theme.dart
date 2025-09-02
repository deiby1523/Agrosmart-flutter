import 'package:flutter/material.dart';

class DListTileTheme {
  DListTileTheme._();

  static const ListTileThemeData lightListTileTheme = ListTileThemeData(
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    dense: false,
    selectedColor: Colors.red,
    tileColor: Colors.red,
    selectedTileColor: Colors.red
  );

  static const ListTileThemeData darkListTileTheme = ListTileThemeData(
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    dense: false,
  );
}
