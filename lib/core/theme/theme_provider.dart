import 'package:flutter/material.dart';
import 'package:taskaroo/core/theme/dark.dart';
import 'package:taskaroo/core/theme/light.dart';

class ThemeProvider extends ChangeNotifier {
  // initially dark theme
  ThemeData _currentTheme = darkTheme;

  // get current theme
  ThemeData get getCurrentTheme {
    return _currentTheme;
  }

  // check if current theme is lightTheme (helper)
  bool get isLightTheme {
    return _currentTheme == lightTheme;
  }

  // set theme
  set setNewTheme(ThemeData themeData) {
    _currentTheme = themeData;
    notifyListeners();
  }

  // toggle theme
  void toggleTheme() {
    if (_currentTheme == lightTheme) {
      setNewTheme = darkTheme;
    } else {
      setNewTheme = lightTheme;
    }
  }
}
