import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager {
  static const _darkModeKey = 'dark_mode';
  
  static void saveSettings(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_darkModeKey, value);
  }

  Future<dynamic> readSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(_darkModeKey);
  }

  Future<bool> deleteSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(_darkModeKey);
  }
}
