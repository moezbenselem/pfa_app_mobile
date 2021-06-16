import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pfa_app/Models/User.dart';
import 'package:pfa_app/Utils/SharedPref.dart';
import 'package:pfa_app/consts/const_strings.dart';
import 'package:pfa_app/consts/constants.dart';
import 'package:pfa_app/screens/login.dart';

import '../Utils/api_config.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  int _currentStep = 0;
  final _formKey1 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  var user = {
    "email": "",
    "password": "",
    "nom": "",
    "prenom": null,
    "cin": null,
    "code": null,
    "adresse": "",
    "tel": "",
    "description": "",
    "code_entreprise": null,
    "type": "",
    "role": "",
    "image": "link",
    "verified": false
  };
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
                                if (_currentStep != 1 ||
                                    (_currentStep == 1 &&
                                        _roleValue != 0 &&
                                        _typeValue != 0)) _currentStep++;
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
        content: Form(
          key: _formKey1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildField("Email", Icon(Icons.email),
                  TextInputType.emailAddress, "email"),
              _buildPasswordTF(),
            ],
          ),
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
          content: Form(
            key: _formKey3,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              _buildField("Nom", Icon(Icons.supervised_user_circle_outlined),
                  TextInputType.name, "nom"),
              if (_typeValue == 1)
                _buildField(
                    "Prenom",
                    Icon(Icons.supervised_user_circle_rounded),
                    TextInputType.name,
                    "prenom"),
              if (_typeValue == 1)
                _buildField("CIN", Icon(Icons.perm_identity),
                    TextInputType.number, "cin"),
              if (_typeValue == 2)
                _buildField("Patente ", Icon(Icons.domain_verification),
                    TextInputType.number, "code"),
              _buildField("Adresse", Icon(Icons.location_city),
                  TextInputType.streetAddress, "adresse"),
              _buildField("Téléphone", Icon(Icons.phone_android),
                  TextInputType.number, "tel"),
              _buildField("Exprimer !", Icon(Icons.description),
                  TextInputType.text, "description"),
            ]),
          ),
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
                    user['role'] = text;
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
                    user['type'] = text;
                    if (value == 1) {
                      user["code"] = null;
                    } else {
                      user["cin"] = null;
                      user["prenom"] = null;
                    }
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

  List<TextFormField> _listFields = [];

  Widget _buildField(hint, Icon icon, inputType, key) {
    TextFormField tf = TextFormField(
      textInputAction: TextInputAction.next,
      keyboardType: inputType,
      onChanged: (value) {
        setState(() {
          user[key] = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Champs Obligatoire !";
        }
        RegExp reg = RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

        if (hint == "Email" && !reg.hasMatch(value)) {
          return "Email Invalide !";
        }
        if (hint == "Nom" && value.length < 3) {
          return "Nom Invalide !";
        }
        if (hint == "Prenom" && value.length < 3) {
          return "Prenom Invalide !";
        }
        if (hint == "CIN" && value.length != 8 && int.tryParse(value) == null) {
          return "CIN Invalide !";
        }
        if (hint == "Patente" && value.length < 8) {
          return "Patente Invalide !";
        }
        if (hint == "Adresse" && value.length < 3) {
          return "Adresse Invalide !";
        }
        if (hint == "Téléphone" && (value.length != 8 || !validPhone(value))) {
          return "Téléphone Invalide !";
        }
        return null;
      },
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
    );
    _listFields.add(tf);
    return Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(bottom: 10),
        decoration: kBoxDecorationStyle,
        height: 60.0,
        child: tf);
  }

  bool validPhone(p) {
    int n = int.tryParse(p.toString().substring(0, 2));
    if ((n >= 20 && n <= 29) || (n >= 90 && n <= 99) || (n >= 50 && n <= 59)) {
      return true;
    }
    return false;
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
          child: TextFormField(
            textInputAction: TextInputAction.next,
            obscureText: obscured,
            onChanged: (value) {
              setState(() {
                user['password'] = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty)
                return "Mot de Passe Obligatoire !";
              if (value.length < 4) return "Mot de Passe trop court !";
              return null;
            },
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
        onPressed: () {
          print(user);
          if (_formKey1.currentState.validate() &&
              _formKey3.currentState.validate()) _signup(user);
        },
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

  Future<User> _signup(user) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Création en cours...',
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
      Uri.http(apiBaseUrl, 'auth/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user),
    );
    Map body = json.decode(response.body), info;
    //remove dialog
    Navigator.pop(context);
    print(response.body);
    print(response.statusCode);
    bool success = body["sucess"];
    if (success) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Création Effectuée !'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Votre Compte a été créer !'),
                    Text("Veillez se connecter !"),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    setState(() {
                      user = {
                        "email": "",
                        "password": "",
                        "nom": "",
                        "prenom": null,
                        "cin": null,
                        "code": null,
                        "adresse": "",
                        "tel": "",
                        "description": "",
                        "code_entreprise": null,
                        "type": "",
                        "role": "",
                        "image": "link",
                        "verified": false
                      };

                      _currentStep = 0;
                      _roleValue = 0;
                      _typeValue = 0;
                      obscured = true;
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return LoginScreen();
                      }));
                    });

                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    } else {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Création Echoué !'),
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
