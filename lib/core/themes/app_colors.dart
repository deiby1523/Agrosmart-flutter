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

  // =========================
  // Dark colors
  // =========================
  static const Color darkPrimary = Color.fromARGB(255, 129, 199, 132);
  static const Color darkOnPrimary = Color.fromARGB(255, 0, 0, 0);

  static const Color darkSecondary = Color(0xFF6D4C41); // Marrón oscuro
  static const Color darkOnSecondary = Colors.white;

  static const Color darkTertiary = Color(0xFF4FC3F7); // Azul más vivo
  static const Color darkOnTertiary = Colors.black;

  static const Color darkError = Color(0xFFEF5350);
  static const Color darkOnError = Colors.black;

  static const Color darkBackground = Color(0xFF121212);
  static const Color darkOnBackground = Colors.white;

  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkOnSurface = Colors.white;

  static const Color darkCard = Color(0xFF1E1E1E);

  static const Color darkText = Color.fromARGB(255, 255, 255, 255);
  static const Color darkTextDisabled = Color.fromARGB(221, 124, 124, 124);

  static const Color darkInfoButton = Color.fromARGB(255, 0, 73, 129);
  static const Color darkInfoIcon = Color.fromARGB(255, 151, 189, 255);

  static const Color darkDangerButton = Color.fromARGB(255, 131, 0, 0);
  static const Color darkDangerIcon = Color.fromRGBO(255, 151, 151, 1);

  static const Color darkGrayButton = Color.fromARGB(221, 124, 124, 124);

  static const Color darkIcon = Color.fromARGB(255, 194, 194, 194);

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
    );
  }
}
