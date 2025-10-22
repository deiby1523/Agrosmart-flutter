// =============================================================================
// THEME REPOSITORY IMPL - Implementación del Repositorio de Temas
// =============================================================================
// Gestiona la persistencia y recuperación del modo de tema (claro, oscuro, sistema)
// - Obtiene el tema guardado desde el almacenamiento local
// - Guarda el tema seleccionado por el usuario
// Fuente de datos: ThemeLocalDataSource (almacenamiento en caché local)

import 'package:flutter/material.dart';
import '../../domain/repositories/theme_repository.dart';
import '../datasources/theme_local_datasource.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDataSource localDataSource;

  ThemeRepositoryImpl(this.localDataSource);

  // --- GET: Retrieve Saved Theme ---
  @override
  Future<ThemeMode?> getTheme() async {
    // Obtener el tema almacenado en caché
    final savedTheme = await localDataSource.getCachedTheme();
    if (savedTheme != null) {
      // Convertir cadena almacenada a objeto ThemeMode
      return _stringToThemeMode(savedTheme);
    }
    // No hay tema guardado previamente
    return null;
  }

  // --- SET: Save Selected Theme ---
  @override
  Future<void> setTheme(ThemeMode mode) async {
    // Convertir objeto ThemeMode a cadena y guardar en caché
    await localDataSource.cacheTheme(_themeModeToString(mode));
  }

  // --- Private: Convert ThemeMode to String ---
  /// Convierte un objeto [ThemeMode] a su representación en texto
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

  // --- Private: Convert String to ThemeMode ---
  /// Convierte una cadena almacenada a su correspondiente [ThemeMode]
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
