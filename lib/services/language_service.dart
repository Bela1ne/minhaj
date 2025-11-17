import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService with ChangeNotifier {
  static const String _langKey = 'app_language';
  Locale _locale = const Locale('fr'); // langue par défaut

  Locale get locale => _locale;

  /// Charge la langue sauvegardée
  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString(_langKey);

    if (savedLang != null) {
      _locale = Locale(savedLang);
    }

    notifyListeners();
  }

  /// Définit une nouvelle langue
  Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    _locale = Locale(languageCode);
    await prefs.setString(_langKey, languageCode);
    notifyListeners();
  }
}
