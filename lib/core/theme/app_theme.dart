import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  /// 🌙 Thème sombre
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primaryDark,
    cardColor: AppColors.card,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accent,
      secondary: AppColors.accent,
      background: AppColors.background,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: AppColors.textLight,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        color: AppColors.textMuted,
        fontSize: 14,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryDark,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.textLight),
      titleTextStyle: TextStyle(
        color: AppColors.textLight,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.primaryDark,
      selectedItemColor: AppColors.accent,
      unselectedItemColor: Colors.white54,
    ),
  );

  /// ☀️ Thème clair
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: AppColors.accent,
    cardColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: AppColors.accent,
      secondary: AppColors.accent,
      background: Colors.white,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Colors.black87,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        color: Colors.black54,
        fontSize: 14,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black87),
      titleTextStyle: TextStyle(
        color: Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.accent,
      unselectedItemColor: Colors.black54,
    ),
  );
}
