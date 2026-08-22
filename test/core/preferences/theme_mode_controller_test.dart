import 'package:dendro_mobile/core/preferences/theme_mode_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('controlador carrega preferencia de modo escuro', () async {
    final storage = _MemoryThemeModeStorage(initialDarkMode: true);
    final controller = AppThemeController(storage);
    addTearDown(controller.dispose);

    await controller.initialized;

    expect(controller.state, ThemeMode.dark);
  });

  test('controlador salva alternancia de tema', () async {
    final storage = _MemoryThemeModeStorage(initialDarkMode: false);
    final controller = AppThemeController(storage);
    addTearDown(controller.dispose);

    await controller.initialized;
    await controller.setDarkMode(true);

    expect(controller.state, ThemeMode.dark);
    expect(storage.darkMode, isTrue);

    await controller.setDarkMode(false);

    expect(controller.state, ThemeMode.light);
    expect(storage.darkMode, isFalse);
  });
}

class _MemoryThemeModeStorage implements ThemeModeStorage {
  _MemoryThemeModeStorage({bool? initialDarkMode}) : darkMode = initialDarkMode;

  bool? darkMode;

  @override
  Future<bool?> loadDarkMode() async => darkMode;

  @override
  Future<void> saveDarkMode(bool enabled) async {
    darkMode = enabled;
  }
}
