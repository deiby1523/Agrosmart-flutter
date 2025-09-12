import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/core/themes/custom_themes/snackbar_theme.dart';
import 'package:flutter/material.dart';
import 'custom_themes/appbar_theme.dart';
import 'custom_themes/card_theme.dart';
import 'custom_themes/button_theme.dart';
import 'custom_themes/input_theme.dart';
import 'custom_themes/text_theme.dart';
import 'custom_themes/bottom_nav_theme.dart';
import 'custom_themes/icon_theme.dart';
import 'custom_themes/chip_theme.dart';
import 'custom_themes/divider_theme.dart';
import 'custom_themes/list_tile_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: AppColorSchemes.lightScheme,
    appBarTheme: DAppBarTheme.lightAppBarTheme,
    cardTheme: DCardTheme.lightCardTheme,
    elevatedButtonTheme: DButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: DButtonTheme.lightOutlinedButtonTheme,
    textButtonTheme: DButtonTheme.lightTextButtonTheme,
    inputDecorationTheme: DInputTheme.lightInputDecorationTheme,
    textTheme: DTextTheme.lightTextTheme,
    bottomNavigationBarTheme: DBottomNavTheme.lightBottomNavTheme,
    iconTheme: DIconTheme.lightIconTheme,
    chipTheme: DChipTheme.lightChipTheme,
    dividerTheme: DDividerTheme.lightDividerTheme,
    listTileTheme: DListTileTheme.lightListTileTheme,
    snackBarTheme: DSnackbarTheme.lightSnackBarTheme,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColorSchemes.lightScheme.primary,
      selectionColor: Color.fromARGB(90, 155, 210, 36),
      selectionHandleColor: AppColorSchemes.lightScheme.primary,
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.windows: PredictiveBackPageTransitionsBuilder(),
      },
    ),
    // pageTransitionsTheme: const PageTransitionsTheme(
    //   builders: {
    //     TargetPlatform.android: NoTransitionsBuilder(),
    //     TargetPlatform.iOS: NoTransitionsBuilder(),
    //     TargetPlatform.windows: NoTransitionsBuilder(),
    //     TargetPlatform.macOS: NoTransitionsBuilder(),
    //   },
    // ),
    extensions: <ThemeExtension<dynamic>>[AppColors.light],
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: AppColorSchemes.darkScheme,
    appBarTheme: DAppBarTheme.darkAppBarTheme,
    cardTheme: DCardTheme.darkCardTheme,
    elevatedButtonTheme: DButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: DButtonTheme.darkOutlinedButtonTheme,
    textButtonTheme: DButtonTheme.darkTextButtonTheme,
    inputDecorationTheme: DInputTheme.darkInputDecorationTheme,
    textTheme: DTextTheme.darkTextTheme,
    bottomNavigationBarTheme: DBottomNavTheme.darkBottomNavTheme,
    iconTheme: DIconTheme.darkIconTheme,
    chipTheme: DChipTheme.darkChipTheme,
    dividerTheme: DDividerTheme.darkDividerTheme,
    listTileTheme: DListTileTheme.darkListTileTheme,
    snackBarTheme: DSnackbarTheme.darkSnackBarTheme,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColorSchemes.lightScheme.primary,
      selectionColor: Color.fromARGB(90, 155, 210, 36),
      selectionHandleColor: AppColorSchemes.lightScheme.primary,
    ),
    
    extensions: <ThemeExtension<dynamic>>[AppColors.dark],
  );
}
