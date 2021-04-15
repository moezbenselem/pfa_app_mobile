import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  read(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var u = prefs.getString(key);
      if (u != null) {
        return json.decode(prefs.getString(key));
      }
      return null;
    } catch (Exception) {
      print("exp in sharedPref read : $Exception");
    }
  }

  save(String key, value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(key, json.encode(value));
    } catch (Exception) {
      print("exp in sharedPref save : $Exception");
    }
  }

  remove(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove(key);
    } catch (exp) {
      print("exp in sharedPref remove : $exp");
    }
  }
}
