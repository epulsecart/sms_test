import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static void saveString(String key, String value) async {
    Future<SharedPreferences> preferences = SharedPreferences.getInstance();
    SharedPreferences sharedPreferences = await preferences;
    sharedPreferences.setString(key, value);
  }
  static void saveBool(String key, bool value) async {
    Future<SharedPreferences> preferences = SharedPreferences.getInstance();
    SharedPreferences sharedPreferences = await preferences;
    sharedPreferences.setBool(key, value);
  }

  static Future<String?> getString(String key) async {
    Future<SharedPreferences> preferences = SharedPreferences.getInstance();
    SharedPreferences sharedPreferences = await preferences;
    return sharedPreferences.getString(key);
  }
  static Future<bool> getBool(String key) async {
    Future<SharedPreferences> preferences = SharedPreferences.getInstance();
    SharedPreferences sharedPreferences = await preferences;
    return sharedPreferences.getBool(key)??false;
  }

  static Future removeKey(String key) async {
    Future<SharedPreferences> preferences = SharedPreferences.getInstance();
    SharedPreferences sharedPreferences = await preferences;
    sharedPreferences.remove(key);
  }

  static Future saveList(String key, List<String> data) async {
    Future<SharedPreferences> preferences = SharedPreferences.getInstance();
    SharedPreferences sharedPreferences = await preferences;
    sharedPreferences.setStringList(key, data);
  }

  static Future getList(String key) async {
    Future<SharedPreferences> preferences = SharedPreferences.getInstance();
    SharedPreferences sharedPreferences = await preferences;
    List<String>? data = sharedPreferences.getStringList(key);

    return data;
  }

  static Future<bool> checkKey(String key) async {
    Future<SharedPreferences> preferences = SharedPreferences.getInstance();
    SharedPreferences sharedPreferences = await preferences;
    bool available = sharedPreferences.containsKey(key);
    return available;
  }
}
