import 'package:flutter/material.dart';

class DDividerTheme {
  DDividerTheme._();

  static DividerThemeData lightDividerTheme = DividerThemeData(
    color: Colors.grey.shade300,
    thickness: 1,
    space: 1,
  );

  static DividerThemeData darkDividerTheme = DividerThemeData(
    color: Colors.grey.shade700,
    thickness: 1,
    space: 1,
  );
}
