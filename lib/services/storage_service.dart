
import 'package:shared_preferences/shared_preferences.dart';


class StorageService {
 
  static const String _themeKey = 'isDarkMode';



  // Theme operations
  Future<bool> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }

  Future<void> saveThemeMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode);
  }

}
