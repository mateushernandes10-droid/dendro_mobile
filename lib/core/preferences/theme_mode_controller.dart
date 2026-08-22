import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

final appThemeControllerProvider =
    StateNotifierProvider<AppThemeController, ThemeMode>((ref) {
      return AppThemeController(FileThemeModeStorage());
    });

final appDarkModeProvider = Provider<bool>((ref) {
  return ref.watch(appThemeControllerProvider) == ThemeMode.dark;
});

abstract interface class ThemeModeStorage {
  Future<bool?> loadDarkMode();

  Future<void> saveDarkMode(bool enabled);
}

class FileThemeModeStorage implements ThemeModeStorage {
  static const _fileName = 'dendro_preferences.json';
  static const _darkModeKey = 'darkMode';

  @override
  Future<bool?> loadDarkMode() async {
    try {
      final file = await _preferencesFile();
      if (!await file.exists()) return null;

      final content = await file.readAsString();
      final decoded = jsonDecode(content);
      if (decoded is! Map<String, Object?>) return null;

      final value = decoded[_darkModeKey];
      return value is bool ? value : null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveDarkMode(bool enabled) async {
    final file = await _preferencesFile();
    final preferences = await _loadPreferences(file);

    preferences[_darkModeKey] = enabled;

    await file.parent.create(recursive: true);
    await file.writeAsString(jsonEncode(preferences));
  }

  Future<File> _preferencesFile() async {
    final directory = await getApplicationSupportDirectory();
    return File('${directory.path}/$_fileName');
  }

  Future<Map<String, Object?>> _loadPreferences(File file) async {
    try {
      if (!await file.exists()) return {};

      final decoded = jsonDecode(await file.readAsString());
      if (decoded is! Map<String, Object?>) return {};

      return Map<String, Object?>.from(decoded);
    } catch (_) {
      return {};
    }
  }
}

class AppThemeController extends StateNotifier<ThemeMode> {
  AppThemeController(this._storage) : super(ThemeMode.light) {
    initialized = _loadPreference();
  }

  final ThemeModeStorage _storage;
  late final Future<void> initialized;

  Future<void> setDarkMode(bool enabled) async {
    final previous = state;
    state = enabled ? ThemeMode.dark : ThemeMode.light;

    try {
      await _storage.saveDarkMode(enabled);
    } catch (_) {
      state = previous;
      rethrow;
    }
  }

  Future<void> _loadPreference() async {
    final enabled = await _storage.loadDarkMode();
    if (!mounted || enabled == null) return;

    state = enabled ? ThemeMode.dark : ThemeMode.light;
  }
}
