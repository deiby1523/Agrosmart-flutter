// features/theme/data/datasources/theme_local_datasource.dart
import 'package:shared_preferences/shared_preferences.dart';

abstract class ThemeLocalDataSource {
  Future<void> cacheTheme(String themeMode);
  Future<String?> getCachedTheme();
}

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  static const _key = 'theme_mode';

  @override
  Future<void> cacheTheme(String themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, themeMode);
  }

  @override
  Future<String?> getCachedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }
}
