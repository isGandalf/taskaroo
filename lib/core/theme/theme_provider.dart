import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskaroo/core/global/global.dart';
import 'package:taskaroo/core/theme/dark.dart';
import 'package:taskaroo/core/theme/light.dart';

class ThemeProvider extends ChangeNotifier {
  // set default theme
  ThemeData currentTheme = lightTheme;

  // when instantiated
  ThemeProvider() {
    loadSavedThemeFromLocal();
    logger.d('Current theme is: ${currentTheme.brightness}');
  }

  // load saved theme
  Future<void> loadSavedThemeFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final isLight = prefs.getBool('isLightTheme') ?? false;
    final newTheme = isLight ? lightTheme : darkTheme;

    if (newTheme != currentTheme) {
      currentTheme = newTheme;
      notifyListeners();
    }
  }

  // save theme to local
  Future<void> saveThemeToLocal(ThemeData themeData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLightTheme', themeData == lightTheme);
  }

  // getter method to get current theme
  ThemeData get getCurrentTheme {
    return currentTheme;
  }

  // toggle
  void toggleTheme() {
    if (currentTheme == lightTheme) {
      currentTheme = darkTheme;
    } else {
      currentTheme = lightTheme;
    }
    saveThemeToLocal(currentTheme);
    notifyListeners();
  }
}
