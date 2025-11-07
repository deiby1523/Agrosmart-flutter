import 'package:flutter/material.dart';

class AppColorSchemes {
  // =========================
  // Light colors
  // =========================
  static const Color lightPrimary = Color.fromARGB(255, 104, 190, 51);
  static const Color lightOnPrimary = Color.fromARGB(255, 255, 255, 255);

  static const Color lightSecondary = Color.fromARGB(255, 120, 235, 235);
  static const Color lightOnSecondary = Colors.white;

  static const Color lightTertiary = Color(0xFF81D4FA);
  static const Color lightOnTertiary = Colors.black;

  static const Color lightError = Color(0xFFD32F2F);
  static const Color lightOnError = Colors.white;

  static const Color lightBackground = Color(0xFFF9FBE7); // Verde muy pálido
  static const Color lightOnBackground = Color(0xFF1B5E20);

  static const Color lightSurface = Colors.white;
  static const Color lightOnSurface = Color.fromARGB(255, 33, 33, 33);

  static const Color lightCard = Color.fromARGB(255, 255, 255, 255);

  static const Color lightText = Color.fromARGB(221, 0, 0, 0);
  static const Color lightTextDisabled = Color.fromARGB(221, 76, 76, 76);

  static const Color lightInfoButton = Color.fromARGB(255, 234, 242, 255);
  static const Color lightInfoIcon = Color.fromARGB(255, 0, 145, 255);

  static const Color lightDangerButton = Color.fromARGB(255, 255, 233, 233);
  static const Color lightDangerIcon = Color.fromARGB(255, 255, 0, 0);

  static const Color lightGrayButton = Color.fromARGB(221, 76, 76, 76);

  static const Color lightIcon = Color.fromARGB(255, 147, 147, 147);

  static const Color lightSidebar = Color.fromARGB(255, 147, 147, 147);

  static const Color lightSidebarGradient1 = Color.fromARGB(255, 0, 56, 20);
  static const Color lightSidebarGradient2 = Color.fromARGB(255, 0, 41, 0);
  static const Color lightSidebarGradient3 = Color.fromARGB(255, 0, 46, 0);

  static const Color lightGreen1 = Color.fromARGB(255, 3, 28, 6);
  static const Color lightGreen2 = Color.fromARGB(255, 4, 59, 5);
  static const Color lightGreen3 = Color.fromARGB(255, 32, 123, 37);
  static const Color lightGreen4 = Color.fromARGB(255, 99, 200, 56);
  static const Color lightGreen5 = Color.fromARGB(255, 159, 227, 122);
  static const Color lightGreen6 = Color.fromARGB(255, 61, 190, 119);
  static const Color lightGreen7 = Color.fromARGB(255, 23, 200, 165);

  // =========================
  // Dark colors
  // =========================
  static const Color darkPrimary = Color.fromARGB(255, 104, 190, 51);
  static const Color darkOnPrimary = Color.fromARGB(255, 0, 0, 0);

  static const Color darkSecondary = Color.fromARGB(255, 8, 210, 150);
  static const Color darkOnSecondary = Colors.white;

  static const Color darkTertiary = Color(0xFF4FC3F7); // Azul más vivo
  static const Color darkOnTertiary = Colors.black;

  static const Color darkError = Color(0xFFEF5350);
  static const Color darkOnError = Colors.black;

  static const Color darkBackground = Color(0xFF121212);
  static const Color darkOnBackground = Colors.white;

  static const Color darkSurface = Color.fromARGB(255, 24, 35, 20);
  static const Color darkOnSurface = Colors.white;

  static const Color darkCard = Color.fromARGB(255, 32, 46, 26);

  static const Color darkText = Color.fromARGB(255, 255, 255, 255);
  static const Color darkTextDisabled = Color.fromARGB(221, 124, 124, 124);

  static const Color darkInfoButton = Color.fromARGB(255, 0, 73, 129);
  static const Color darkInfoIcon = Color.fromARGB(255, 151, 189, 255);

  static const Color darkDangerButton = Color.fromARGB(255, 131, 0, 0);
  static const Color darkDangerIcon = Color.fromRGBO(255, 151, 151, 1);

  static const Color darkGrayButton = Color.fromARGB(255, 194, 194, 194);

  static const Color darkIcon = Color.fromARGB(255, 194, 194, 194);

  static const Color darkSidebar = Color.fromARGB(255, 147, 147, 147);

  static const Color darkSidebarGradient1 = Color.fromARGB(255, 0, 56, 20);
  static const Color darkSidebarGradient2 = Color.fromARGB(255, 0, 41, 0);
  static const Color darkSidebarGradient3 = Color.fromARGB(255, 0, 46, 0);

  static const Color darkGreen1 = Color.fromARGB(255, 3, 28, 6);
  static const Color darkGreen2 = Color.fromARGB(255, 4, 59, 5);
  static const Color darkGreen3 = Color.fromARGB(255, 32, 123, 37);
  static const Color darkGreen4 = Color.fromARGB(255, 99, 200, 56);
  static const Color darkGreen5 = Color.fromARGB(255, 159, 227, 122);
  static const Color darkGreen6 = Color.fromARGB(255, 61, 190, 119);
  static const Color darkGreen7 = Color.fromARGB(255, 23, 200, 165);

  // =========================
  // Schemes
  // =========================
  static const ColorScheme lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: lightPrimary,
    onPrimary: lightOnPrimary,
    secondary: lightSecondary,
    onSecondary: lightOnSecondary,
    tertiary: lightTertiary,
    onTertiary: lightOnTertiary,
    error: lightError,
    onError: lightOnError,
    surface: lightSurface,
    onSurface: lightOnSurface,
  );

  static const ColorScheme darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: darkPrimary,
    onPrimary: darkOnPrimary,
    secondary: darkSecondary,
    onSecondary: darkOnSecondary,
    tertiary: darkTertiary,
    onTertiary: darkOnTertiary,
    error: darkError,
    onError: darkOnError,
    surface: darkSurface,
    onSurface: darkOnSurface,
  );
}

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color button;
  final Color card;
  final Color icon;
  final Color editButton;
  final Color editIcon;
  final Color deleteButton;
  final Color deleteIcon;
  final Color textDefault;
  final Color textDisabled;
  final Color cancelTextButton;
  final Color sidebarGradient1;
  final Color sidebarGradient2;
  final Color sidebarGradient3;
  final Color green1;
  final Color green2;
  final Color green3;
  final Color green4;
  final Color green5;
  final Color green6;
  final Color green7;
  

  const AppColors({
    required this.button,
    required this.card,
    required this.icon,
    required this.editButton,
    required this.editIcon,
    required this.deleteButton,
    required this.deleteIcon,
    required this.textDefault,
    required this.textDisabled,
    required this.cancelTextButton,
    required this.sidebarGradient1,
    required this.sidebarGradient2,
    required this.sidebarGradient3,
    required this.green1,
    required this.green2,
    required this.green3,
    required this.green4,
    required this.green5,
    required this.green6,
    required this.green7,
  });

  // =========================
  // Light theme
  // =========================
  static const AppColors light = AppColors(
    button: AppColorSchemes.lightPrimary,
    card: AppColorSchemes.lightCard,
    icon: AppColorSchemes.lightIcon,
    editButton: AppColorSchemes.lightInfoButton,
    editIcon: AppColorSchemes.lightInfoIcon,
    deleteButton: AppColorSchemes.lightDangerButton,
    deleteIcon: AppColorSchemes.lightDangerIcon,
    textDefault: AppColorSchemes.lightText,
    textDisabled: AppColorSchemes.lightTextDisabled,
    cancelTextButton: AppColorSchemes.lightGrayButton,
    sidebarGradient1: AppColorSchemes.lightSidebarGradient1,
    sidebarGradient2: AppColorSchemes.lightSidebarGradient2,
    sidebarGradient3: AppColorSchemes.lightSidebarGradient3,
    green1: AppColorSchemes.lightGreen1,
    green2: AppColorSchemes.lightGreen2,
    green3: AppColorSchemes.lightGreen3,
    green4: AppColorSchemes.lightGreen4,
    green5: AppColorSchemes.lightGreen5,
    green6: AppColorSchemes.lightGreen6,
    green7: AppColorSchemes.lightGreen7,
  );

  // =========================
  // Dark theme
  // =========================
  static const AppColors dark = AppColors(
    button: AppColorSchemes.darkPrimary,
    card: AppColorSchemes.darkCard,
    icon: AppColorSchemes.darkIcon,
    editButton: AppColorSchemes.darkInfoButton,
    editIcon: AppColorSchemes.darkInfoIcon,
    deleteButton: AppColorSchemes.darkDangerButton,
    deleteIcon: AppColorSchemes.darkDangerIcon,
    textDefault: AppColorSchemes.darkText,
    textDisabled: AppColorSchemes.darkTextDisabled,
    cancelTextButton: AppColorSchemes.darkGrayButton,
    sidebarGradient1: AppColorSchemes.darkSidebarGradient1,
    sidebarGradient2: AppColorSchemes.darkSidebarGradient2,
    sidebarGradient3: AppColorSchemes.darkSidebarGradient3,
    green1: AppColorSchemes.darkGreen1,
    green2: AppColorSchemes.darkGreen2,
    green3: AppColorSchemes.darkGreen3,
    green4: AppColorSchemes.darkGreen4,
    green5: AppColorSchemes.darkGreen5,
    green6: AppColorSchemes.darkGreen6,
    green7: AppColorSchemes.darkGreen7,
  );

  @override
  AppColors copyWith({
    Color? button,
    Color? card,
    Color? icon,
    Color? editButton,
    Color? editIcon,
    Color? deleteButton,
    Color? deleteIcon,
    Color? textDefault,
    Color? textDisabled,
    Color? cancelTextButton,
    Color? sidebarGradient1,
    Color? sidebarGradient2,
    Color? sidebarGradient3,
    Color? green1,
    Color? green2,
    Color? green3,
    Color? green4,
    Color? green5,
    Color? green6,
    Color? green7,
  }) {
    return AppColors(
      button: button ?? this.button,
      card: card ?? this.card,
      icon: icon ?? this.icon,
      editButton: editButton ?? this.editButton,
      editIcon: editIcon ?? this.editIcon,
      deleteButton: deleteButton ?? this.deleteButton,
      deleteIcon: deleteIcon ?? this.deleteIcon,
      textDefault: textDefault ?? this.textDefault,
      textDisabled: textDisabled ?? this.textDisabled,
      cancelTextButton: cancelTextButton ?? this.cancelTextButton,
      sidebarGradient1: sidebarGradient1 ?? this.sidebarGradient1,
      sidebarGradient2: sidebarGradient2 ?? this.sidebarGradient2,
      sidebarGradient3: sidebarGradient3 ?? this.sidebarGradient3,
      green1: green1 ?? this.green1,
      green2: green2 ?? this.green2,
      green3: green3 ?? this.green3,
      green4: green4 ?? this.green4,
      green5: green5 ?? this.green5,
      green6: green6 ?? this.green6,
      green7: green7 ?? this.green7,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      button: Color.lerp(button, other.button, t)!,
      card: Color.lerp(card, other.card, t)!,
      icon: Color.lerp(icon, other.icon, t)!,
      editButton: Color.lerp(editButton, other.editButton, t)!,
      editIcon: Color.lerp(editIcon, other.editIcon, t)!,
      deleteButton: Color.lerp(deleteButton, other.deleteButton, t)!,
      deleteIcon: Color.lerp(deleteIcon, other.deleteIcon, t)!,
      textDefault: Color.lerp(textDefault, other.textDefault, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      cancelTextButton: Color.lerp(
        cancelTextButton,
        other.cancelTextButton,
        t,
      )!,
      sidebarGradient1: Color.lerp(
        sidebarGradient1,
        other.sidebarGradient1,
        t,
      )!,
      sidebarGradient2: Color.lerp(
        sidebarGradient2,
        other.sidebarGradient2,
        t,
      )!,
      sidebarGradient3: Color.lerp(
        sidebarGradient3,
        other.sidebarGradient3,
        t,
      )!,
      green1: Color.lerp(green1, other.green1, t)!,
      green2: Color.lerp(green2, other.green2, t)!,
      green3: Color.lerp(green3, other.green3, t)!,
      green4: Color.lerp(green4, other.green4, t)!,
      green5: Color.lerp(green5, other.green5, t)!,
      green6: Color.lerp(green6, other.green6, t)!,
      green7: Color.lerp(green7, other.green7, t)!,
    );
  }
}
