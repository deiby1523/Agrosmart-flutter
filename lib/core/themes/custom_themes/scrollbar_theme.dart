import 'package:flutter/material.dart';
class DScrollbarTheme {
  DScrollbarTheme._();

  static const ScrollbarThemeData lightScrollbarTheme = ScrollbarThemeData(
    thickness: WidgetStatePropertyAll<double>(4.0),
    radius: Radius.circular(2.0),
    thumbColor: WidgetStatePropertyAll<Color>(Color(0x33000000)),
    trackColor: WidgetStatePropertyAll<Color>(Color(0x0A000000)),
    thumbVisibility: WidgetStatePropertyAll<bool>(false),
    trackVisibility: WidgetStatePropertyAll<bool>(false),
    minThumbLength: 40.0,
    crossAxisMargin: 4.0,
    mainAxisMargin: 0.0,
    interactive: true,
  );

  static const ScrollbarThemeData darkScrollbarTheme = ScrollbarThemeData(
    thickness: WidgetStatePropertyAll<double>(4.0),
    radius: Radius.circular(2.0),
    thumbColor: WidgetStatePropertyAll<Color>(Color(0x33FFFFFF)),
    trackColor: WidgetStatePropertyAll<Color>(Color(0x0AFFFFFF)),
    thumbVisibility: WidgetStatePropertyAll<bool>(false),
    trackVisibility: WidgetStatePropertyAll<bool>(false),
    minThumbLength: 40.0,
    crossAxisMargin: 4.0,
    mainAxisMargin: 0.0,
    interactive: true,
  );
}