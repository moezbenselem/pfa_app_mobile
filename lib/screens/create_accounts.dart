import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pfa_app/Models/User.dart';
import 'package:pfa_app/Utils/api_config.dart';
import 'package:pfa_app/consts/const_strings.dart';
import 'package:pfa_app/consts/constants.dart';

class CreateAccountScreen extends StatefulWidget {
  User entreprise;

  CreateAccountScreen(this.entreprise);

  @override
  _CreateAccountScreenState createState() =>
      _CreateAccountScreenState(this.entreprise);
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  int _currentStep = 0;
  User entreprise;
  final _formKey = GlobalKey<FormState>();

  var user = {
    "email": "",
    "password": "",
    "nom": "",
    "prenom": null,
    "cin": null,
    "code": null,
    "adresse": "",
    "tel": "",
    "description": "un sous compte",
    "code_entreprise": null,
    "type": USER_EMPLOYEE,
    "role": USER_ROLE_TRANSPORTEUR,
    "image": "link",
    "verified": false
  };

  @override
  void initState() {}

  _CreateAccountScreenState(this.entreprise);

  @override
  Widget build(BuildContext context) {
    double myWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(top: 0, bottom: 0, right: 5, left: 5),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyFormField("email", "Email :"),
              TextFormField(
                decoration: InputDecoration(
                  hintStyle: kHintTextStyle,
                  labelText: "Mot de Passe",
                ),
                obscureText: true,
                onChanged: (value) => user['password'] = value,
                validator: (value) {
                  if (value.isEmpty || value == null) {
                    return 'Champ Obligatoire !';
                  }
                  return null;
                },
              ),
              MyFormField("nom", "Nom :"),
              MyFormField("prenom", "Prénom :"),
              MyFormField("cin", "CIN :"),
              MyFormField("tel", "Téléphone :"),
              MyFormField("adresse", "Adresse :"),
              Center(
                child: Container(
                  width: myWidth * 0.7,
                  height: myWidth * 0.12,
                  child: ElevatedButton(
                    onPressed: () =>
                        {if (_formKey.currentState.validate()) _signup(user)},
                    child: Text(
                      "Créer",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w100,
                          fontFamily: 'OpenSans',
                          fontSize: 18.0),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red[900],
                      onPrimary: Colors.red[500],
                      elevation: 5.0,
                      padding: EdgeInsets.all(10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget MyFormField(String key, String hint) {
    return TextFormField(
      decoration: InputDecoration(
        hintStyle: kHintTextStyle,
        labelText: hint,
      ),
      onChanged: (value) => user[key] = value,
      validator: (value) {
        if (value.isEmpty || value == null) {
          return 'Champ Obligatoire !';
        }
        return null;
      },
    );
  }

  Future<User> _signup(user) async {
    user['code_entreprise'] = entreprise.code;
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
                    Text('Un Compte a été créer !'),
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
                    });
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
