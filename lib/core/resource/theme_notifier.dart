import 'package:flutter/material.dart';
import 'package:news_app/core/resource/theme_manager.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData = ThemeData.light(useMaterial3: true);
  ThemeData getTheme() => _themeData;

  final darkTheme = ThemeData.dark(useMaterial3: true);
  final lightTheme = ThemeData.light(useMaterial3: true);

  ThemeNotifier() {
    ThemeManager().readSettings().then((val) {
      var isDarkMode = val;
      if (isDarkMode) {
        _themeData = darkTheme;
      } else {
        _themeData = lightTheme;
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    ThemeManager.saveSettings(true);
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    ThemeManager.saveSettings(false);
    notifyListeners();
  }
}
