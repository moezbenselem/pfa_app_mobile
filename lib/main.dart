import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pfa_app/Models/User.dart';
import 'package:pfa_app/Utils/SharedPref.dart';
import 'package:pfa_app/Utils/api_config.dart';
import 'package:pfa_app/screens/accueil.dart';
import 'package:pfa_app/screens/login.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isLogged = false;
  SharedPref sharedPref = SharedPref();
  User user;
  try {
    user = User.fromJson(await sharedPref.read("user"));
    if (user != null) {
      String refreshToken = user.refresh_token;
      http.Response response = await http.post(
        Uri.http(apiBaseUrl, 'auth/refresh'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $refreshToken',
        },
      );
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        user.token = res["token"];
        user.refresh_token = res["refresh_token"];
        sharedPref.save("user", user);
        isLogged = true;
      } else
        isLogged = false;
    }
  } catch (Excepetion) {
    // do something
  }
  runApp(MyApp(isLogged, user));
}

class MyApp extends StatelessWidget {
  bool isLogged;
  User user;

  MyApp(
      this.isLogged, this.user); // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.grey[900],
          accentColor: Colors.red[500],
          fontFamily: 'Tahoma',
        ),
        home: isLogged ? Accueil.forUser(user) : LoginScreen());
  }
}
