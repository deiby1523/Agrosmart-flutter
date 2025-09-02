// features/theme/data/repositories/theme_repository_impl.dart
import 'package:flutter/material.dart';
import '../../domain/repositories/theme_repository.dart';
import '../datasources/theme_local_datasource.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDataSource localDataSource;

  ThemeRepositoryImpl(this.localDataSource);

  @override
  Future<ThemeMode?> getTheme() async {
    final savedTheme = await localDataSource.getCachedTheme();
    if (savedTheme != null) {
      return _stringToThemeMode(savedTheme);
    }
    return null; // No hay tema guardado
  }

  @override
  Future<void> setTheme(ThemeMode mode) async {
    await localDataSource.cacheTheme(_themeModeToString(mode));
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      default:
        return 'system';
    }
  }

  ThemeMode _stringToThemeMode(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
