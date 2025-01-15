import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  // ذخیره در لوکال دیتابیس
  Future createCacheString(String key, String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(key, value);
  }

  Future createCacheBool(String key, bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(key, value);
  }

  Future createCacheDouble(String key, double value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setDouble(key, value);
  }

  Future createCacheInt(String key, int value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(key, value);
  }

  Future createCacheStringList(String key, List<String> valueList) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList(key, valueList);
  }

  // خواندن از لوکال دیتابیس
  Future readCacheString(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final cache = preferences.getString(key);
    return cache;
  }

  Future readCacheBool(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final cache = preferences.getBool(key);
    return cache;
  }

  Future readCacheDouble(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final cache = preferences.getDouble(key);
    return cache;
  }

  Future readCacheInt(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final cache = preferences.getInt(key);
    return cache;
  }

  Future readCacheStringList(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final cache = preferences.getStringList(key);
    return cache;
  }

  // حذف از لوکال دیتابیس
  Future removeCache(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(key);
  }
}
