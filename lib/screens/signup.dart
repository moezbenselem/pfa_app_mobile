import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pfa_app/Models/User.dart';
import 'package:pfa_app/Utils/SharedPref.dart';
import 'package:pfa_app/consts/const_strings.dart';
import 'package:pfa_app/consts/constants.dart';

import '../Utils/api_config.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  int _currentStep = 0;
  String email = "",
      password = "",
      nom = "",
      prenom = "",
      cin = "",
      code = "",
      adresse = "",
      tel = "",
      description = "",
      code_entreprise = "",
      type = "",
      role = "";
  bool obscured = true;
  SharedPref sharedPref = SharedPref();

  @override
  void initState() {
    //_read();
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
                      right: 20.0,
                      left: 20.0,
                      top: 50.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Créer un Compte',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30.0),
                        Stepper(
                          steps: _mySteps(),
                          currentStep: this._currentStep,
                          onStepTapped: (step) {
                            if (step != 2)
                              setState(() {
                                _currentStep = step;
                              });
                          },
                          onStepContinue: () {
                            setState(() {
                              if (this._currentStep < _mySteps().length - 1) {
                                _currentStep++;
                              } else {
                                //Save Logic
                              }
                            });
                          },
                          onStepCancel: () {
                            setState(() {
                              if (_currentStep > 0) {
                                _currentStep--;
                              } else {
                                _currentStep = 0;
                              }
                            });
                          },
                        ),
                        _buildSignupBtn(),
                        _buildLoginBtn(),
                        SizedBox(height: 10.0),
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

  int _roleValue = 0;

  List<Step> _mySteps() {
    List<Step> _steps = [
      Step(
        title: Text("Informations du Login"),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildField(
                "Email", Icon(Icons.email), TextInputType.emailAddress, email),
            _buildPasswordTF(),
          ],
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
          title: Text("Informations du Compte"),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vous êtes :',
                style: kLabelStyle,
              ),
              SizedBox(
                height: 5,
              ),
              radioRole(USER_ROLE_CLIENT, 1),
              radioRole(USER_ROLE_TRANSPORTEUR, 2),
              SizedBox(
                height: 10,
              ),
              Text(
                'Vous êtes :',
                style: kLabelStyle,
              ),
              SizedBox(
                height: 5,
              ),
              radioType(USER_PARTICULIER, 1),
              radioType(USER_ENTREPRISE, 2),
            ],
          ),
          isActive: _currentStep >= 1),
      Step(
          title: Text("Information Personelles"),
          content:
              Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            _buildField("Nom", Icon(Icons.supervised_user_circle_outlined),
                TextInputType.name, nom),
            if (_typeValue == 1)
              _buildField("Prenom", Icon(Icons.supervised_user_circle_rounded),
                  TextInputType.name, prenom),
            if (_typeValue == 1)
              _buildField(
                  "CIN", Icon(Icons.perm_identity), TextInputType.number, cin),
            if (_typeValue == 2)
              _buildField("Patente ", Icon(Icons.domain_verification),
                  TextInputType.number, code),
            _buildField("Adresse", Icon(Icons.location_city),
                TextInputType.streetAddress, adresse),
            _buildField("Téléphone", Icon(Icons.phone_android),
                TextInputType.number, tel),
            _buildField("Exprimer !", Icon(Icons.description),
                TextInputType.text, description),
          ]),
          isActive: _currentStep >= 2),
    ];
    return _steps;
  }

  void _roleRadioValueChange(int value) {
    setState(() {
      _roleValue = value;
    });
  }

  Widget radioRole(text, val) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Container(
        height: 20.0,
        child: Row(
          children: <Widget>[
            Theme(
              data: ThemeData(
                unselectedWidgetColor: Colors.white,
              ),
              child: Radio(
                value: val,
                groupValue: _roleValue,
                activeColor: Colors.red,
                onChanged: (value) {
                  setState(() {
                    _roleRadioValueChange(value);
                  });
                },
              ),
            ),
            Text(
              text,
              style: kHintTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  int _typeValue = 0;

  void _typeRadioValueChange(int value) {
    setState(() {
      _typeValue = value;
    });
  }

  Widget radioType(text, val) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Container(
        height: 20.0,
        child: Row(
          children: <Widget>[
            Theme(
              data: ThemeData(
                unselectedWidgetColor: Colors.white,
              ),
              child: Radio(
                value: val,
                groupValue: _typeValue,
                activeColor: Colors.red,
                onChanged: (value) {
                  setState(() {
                    _typeRadioValueChange(value);
                  });
                },
              ),
            ),
            Text(
              text,
              style: kHintTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  _tooglePassword() {
    setState(() {
      obscured = !obscured;
    });
  }

  Widget _buildField(hint, Icon icon, inputType, variable) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(bottom: 10),
      decoration: kBoxDecorationStyle,
      height: 60.0,
      child: TextField(
        textInputAction: TextInputAction.next,
        keyboardType: inputType,
        onChanged: (value) => variable = value,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'OpenSans',
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 14.0),
          prefixIcon: icon,
          hintText: hint,
          hintStyle: kHintTextStyle,
        ),
      ),
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 10),
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
                //color: Colors.white,
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

  Widget _buildSignupBtn() {
    return Container(
      padding: EdgeInsets.only(top: 25.0, bottom: 5),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
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
          'Créer',
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

  Widget _buildLoginBtn() {
    return Container(
      alignment: Alignment.topCenter,
      child: TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(
          'Ou bien Connecté vous !',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              fontSize: 16.0),
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
}
