import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPref {
  read(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return json.decode(prefs.getString(key));
    } catch (Exception) {
      print("exeption heyyyy");
    }
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
