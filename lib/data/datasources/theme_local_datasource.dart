// =============================================================================
// THEME LOCAL DATASOURCE - Persistencia de Preferencias de Tema
// =============================================================================
// Guarda y recupera el modo de tema seleccionado por el usuario
// - Valores posibles: 'light', 'dark', 'system'
// - Storage: SharedPreferences (no requiere encriptación)

import 'package:shared_preferences/shared_preferences.dart';

// --- Abstract Contract ---
abstract class ThemeLocalDataSource {
  Future<void> cacheTheme(String themeMode);
  Future<String?> getCachedTheme();
}

// =============================================================================
// IMPLEMENTATION
// =============================================================================

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  // --- Storage Key ---
  static const _key = 'theme_mode';

  // --- Save: Theme Mode ---
  /// Guarda la preferencia de tema del usuario
  /// themeMode: 'light' | 'dark' | 'system'
  @override
  Future<void> cacheTheme(String themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, themeMode);
  }

  // --- Read: Theme Mode ---
  /// Obtiene el tema guardado
  /// Returns: String del tema o null si no hay preferencia guardada
  @override
  Future<String?> getCachedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }
}