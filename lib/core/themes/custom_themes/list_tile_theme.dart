import 'package:flutter/material.dart';

class DListTileTheme {
  DListTileTheme._();

  static ListTileThemeData lightListTileTheme = ListTileThemeData(
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    dense: true,
  );

  static const ListTileThemeData darkListTileTheme = ListTileThemeData(
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    dense: false,
  );
}
