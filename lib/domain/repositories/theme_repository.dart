// features/theme/domain/repositories/theme_repository.dart
import 'package:flutter/material.dart';

abstract class ThemeRepository {
  Future<void> setTheme(ThemeMode mode);
  Future<ThemeMode?> getTheme();
}
