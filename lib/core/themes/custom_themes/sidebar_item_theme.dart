import 'package:flutter/material.dart';

class DSidebarItemTheme {
  DSidebarItemTheme._();
  static const BoxDecoration lightItemTheme = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    color: Color.fromARGB(255, 41, 163, 41),
  );

  static const BoxDecoration darkItemTheme = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    color: Color.fromARGB(255, 14, 176, 168),
  );
}
