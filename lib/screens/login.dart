import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pfa_app/Models/User.dart';
import 'package:pfa_app/Utils/SharedPref.dart';
import 'package:pfa_app/consts/constants.dart';
import 'package:pfa_app/screens/accueil.dart';
import 'package:pfa_app/screens/signup.dart';
import '../Utils/api_config.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  String email = "", password = "";
  bool obscured = true;
  String token = "";
  SharedPref sharedPref = SharedPref();

  @override
  void initState() {
    //_read();
  }

  _tooglePassword() {
    setState(() {
      obscured = !obscured;
    });
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => email = value,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Votre Email',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Mot de Passe',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            textInputAction: TextInputAction.next,
            obscureText: obscured,
            onChanged: (value) => password = value,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  obscured ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white10,
                ),
                onPressed: _tooglePassword,
              ),
              hintText: 'Votre Mot de Passe',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => print('Forgot Password Button Pressed'),
        child: Text(
          'Mot de passe Oublié ?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.white,
              activeColor: Colors.red,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'Rester connecté',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _login(email, password),
        style: ElevatedButton.styleFrom(
          primary: Colors.red[900],
          onPrimary: Colors.red[500],
          elevation: 5.0,
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        child: Text(
          'Connexion',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildSignupBtn() {
    return Container(
      alignment: Alignment.topCenter,
      child: TextButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SignupScreen();
          }));
        },
        child: Text(
          'Ou bien Crée un compte !',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              fontSize: 16.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.grey[900],
                      ],
                      stops: [0.1],
                    ),
                  ),
                ),
                Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      right: 40.0,
                      left: 40.0,
                      top: 70.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Se Connecter',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30.0),
                        _buildEmailTF(),
                        SizedBox(
                          height: 30.0,
                        ),
                        _buildPasswordTF(),
                        _buildForgotPasswordBtn(),
                        _buildRememberMeCheckbox(),
                        _buildLoginBtn(),
                        _buildSignupBtn(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<User> _login(String email, String password) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Connexion en cours...',
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.red[900],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text('Veillez patienter !'),
                )
              ],
            ),
          ),
        );
      },
    );
    http.Response response = await http.post(
      Uri.http(apiBaseUrl, 'auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'email': email.trim(), 'password': password}),
    );
    Map body = json.decode(response.body), info;
    //remove dialog
    Navigator.pop(context);

    if (response.statusCode == 200) {
      info = body["data"];
      User user = User.fromJson(info);
      _save(user);
    } else {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Connexion Echoué !'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Données Incorrectes !'),
                  Text(body['message']),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Réessayer'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  _read() async {
    try {
      User user = User.fromJson(await sharedPref.read("user"));
//      setState(() {
//        user = user;
//      });

      if (user != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Accueil.forUser(user);
        }));
      }
    } catch (Excepetion) {
      // do something
    }
  }

  _save(User user) async {
    sharedPref.save("user", user);

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Accueil.forUser(user);
    }));
  }
}
