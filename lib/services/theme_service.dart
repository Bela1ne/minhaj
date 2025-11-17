import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService with ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  /// Chargement du thème sauvegardé
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_themeKey);

    if (saved == 'dark') {
      _themeMode = ThemeMode.dark;
    } else if (saved == 'light') {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.system;
    }

    notifyListeners();
  }

  /// Changer et sauvegarder le thème
  Future<void> setTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = mode;

    if (mode == ThemeMode.dark) {
      await prefs.setString(_themeKey, 'dark');
    } else if (mode == ThemeMode.light) {
      await prefs.setString(_themeKey, 'light');
    } else {
      await prefs.setString(_themeKey, 'system');
    }

    notifyListeners();
  }
}
