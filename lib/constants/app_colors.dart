import 'package:flutter/material.dart';

class AppColors {
  static bool isDarkMode = false;

  static void updateThemeMode(bool isDark) {
    isDarkMode = isDark;
  }

  /* ---------------- Brand Colors ---------------- */

  static Color get primary => Color(0xFF9a0f1c);
  static Color get primaryTransparent =>
      primary.withValues(alpha: 0.7);

  static Color get secondary => const Color.fromARGB(255, 187, 19, 36);

  static Color get success => Colors.green;

  static List<Color> get primaryGradient => const [
        Color.fromARGB(255, 191, 18, 35),
        Color(0xFF9a0f1c),
      ];

  static List<Color> get secondaryGradient => const [
        Color(0xFFE41E3F),
        Color(0xFF680314),
      ];

  /* ---------------- Backgrounds ---------------- */

  static Color get backgroundDark =>
      const Color.fromARGB(255, 15, 15, 15);

  static Color get backgroundLight =>
      const Color(0xFFF5F5F5);

  static Color get background =>
      isDarkMode ? backgroundDark : backgroundLight;

  static Color get dimBackground =>
      isDarkMode ? const Color(0xFF191919) : Colors.white;

  /* ---------------- Surface / Cards ---------------- */

  static Color get surfaceDark =>
      const Color.fromARGB(255, 48, 48, 48);

  static Color get surfaceLight =>
      const Color(0xFFFFFFFF);

  static Color get surfaceMuted =>
      const Color(0xFFE8E8E8);

  static Color get card =>
      isDarkMode ? const Color(0xFF1C1C1E) : surfaceLight;

  static Color get castBackground =>
      isDarkMode ? surfaceDark : surfaceMuted;

  static Color get switchBackground =>
      isDarkMode ? surfaceDark : surfaceLight;

  /* ---------------- Tabs ---------------- */

  static Color get tabBackgroundDark =>
      const Color(0xFF1A1A1A);

  static Color get tabBackgroundLight =>
      const Color(0xFFFFFFFF);

  static Color get tabBackground =>
      isDarkMode ? tabBackgroundDark : tabBackgroundLight;

  /* ---------------- Text ---------------- */

  static Color get textPrimary =>
      isDarkMode ? Colors.white : const Color(0xFF5A5A5A);

  static Color get textSecondary =>
      isDarkMode ? const Color(0xFF999999) : const Color(0xFF666666);

  static Color get textOnBackground =>
      isDarkMode ? Colors.white : Colors.black;

  static Color get textDisabled =>
      textPrimary.withValues(alpha: 0.6);

  static Color get buttonText =>
      isDarkMode ? backgroundDark : surfaceLight;

  /* ---------------- Media / Player ---------------- */

  static Color get mediaControl =>
      isDarkMode ? Colors.white : Colors.black;
}
