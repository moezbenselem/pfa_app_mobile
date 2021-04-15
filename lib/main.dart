import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pfa_app/Models/User.dart';
import 'package:pfa_app/Utils/SharedPref.dart';
import 'package:pfa_app/Utils/api_config.dart';
import 'package:pfa_app/screens/accueil.dart';
import 'package:pfa_app/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isLogged = false;
  SharedPref sharedPref = SharedPref();
  User user;
  try {
    var v_user = await sharedPref.read("user");
    if (v_user != null) {
      user = User.fromJson(v_user);
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
        startTimer(user);
      } else
        isLogged = false;
    }
  } catch (err) {
    print("exp in refresh : $err");
  }

  runApp(MyApp(isLogged, user));
}

Timer _timer;

void startTimer(User u) {
  print("timer started");
  const oneSec = const Duration(minutes: 14);
  if (_timer == null) {
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        print("tick");
        refreshToken(u);
      },
    );
  }
}

refreshToken(User u) async {
  SharedPref sharedPref = SharedPref();
  String refreshToken = u.refresh_token;
  http.Response response = await http.post(
    Uri.http(apiBaseUrl, 'auth/refresh'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $refreshToken',
    },
  );
  if (response.statusCode == 200) {
    var res = jsonDecode(response.body);
    u.token = res["token"];
    u.refresh_token = res["refresh_token"];
    sharedPref.save("user", u);
    print("token updated");
    startTimer(u);
  }
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
