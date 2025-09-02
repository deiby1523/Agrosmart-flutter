// features/theme/presentation/providers/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/theme_local_datasource.dart';
import '../../data/repositories/theme_repository_impl.dart';
import '../../domain/repositories/theme_repository.dart';

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  final repository =
      ThemeRepositoryImpl(ThemeLocalDataSourceImpl());
  return ThemeNotifier(repository);
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final ThemeRepository repository;

  ThemeNotifier(this.repository) : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final savedTheme = await repository.getTheme();
    if (savedTheme != null) {
      state = savedTheme;
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    await repository.setTheme(mode);
  }
}
