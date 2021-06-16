import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pfa_app/Models/User.dart';
import 'package:pfa_app/Utils/SharedPref.dart';
import 'package:pfa_app/Utils/api_config.dart';
import 'package:pfa_app/consts/const_strings.dart';

class ProfilePage extends StatefulWidget {
  User user;

  ProfilePage(this.user);

  @override
  MapScreenState createState() => MapScreenState(user);
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  User user;
  User originalUser;
  SharedPref sharedPref = SharedPref();
  final _formKey = GlobalKey<FormState>();

  MapScreenState(this.user);

  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    originalUser = user;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new SafeArea(
            child: Container(
      color: Colors.grey[900],
      child: new ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: new Container(
                  color: Colors.grey[900],
                  child: new Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child:
                            new Stack(fit: StackFit.loose, children: <Widget>[
                          new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Container(
                                  width: 140.0,
                                  height: 140.0,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      image: new ExactAssetImage(
                                          'assets/images/male_avatar.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 90.0, right: 100.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 25.0,
                                    child: new Icon(
                                      Icons.camera_alt,
                                      color: Colors.grey[900],
                                    ),
                                  )
                                ],
                              )),
                        ]),
                      )
                    ],
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: new Container(
                  color: Colors.grey[900],
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 25),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Informations Personnelles',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    _status ? _getEditIcon() : new Container(),
                                  ],
                                )
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Nom',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: TextFormField(
                                    controller: new TextEditingController()
                                      ..text = user.nom
                                      ..selection = TextSelection.fromPosition(
                                          TextPosition(
                                              offset: user.nom.length)),
                                    decoration: const InputDecoration(
                                      hintText: "Votre Nom",
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        user.nom = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Champ obligatoire !";
                                      }
                                      if (value.length < 3)
                                        return "Nom Invalide";
                                      return null;
                                    },
                                    enabled: !_status,
                                    autofocus: !_status,
                                  ),
                                ),
                              ],
                            )),
                        if (user.type.toLowerCase() ==
                                USER_PARTICULIER.toLowerCase() ||
                            user.type.toLowerCase() ==
                                USER_EMPLOYEE.toLowerCase())
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Prenom',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        if (user.type.toLowerCase() ==
                                USER_PARTICULIER.toLowerCase() ||
                            user.type.toLowerCase() ==
                                USER_EMPLOYEE.toLowerCase())
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextFormField(
                                      controller: TextEditingController()
                                        ..text = user.prenom
                                        ..selection =
                                            TextSelection.fromPosition(
                                                TextPosition(
                                                    offset:
                                                        user.prenom.length)),
                                      decoration: const InputDecoration(
                                        hintText: "Votre Prenom",
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          user.prenom = value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Champ obligatoire !";
                                        }
                                        if (value.length < 3)
                                          return "Prénom Invalide";
                                        return null;
                                      },
                                      enabled: !_status,
                                      autofocus: !_status,
                                    ),
                                  ),
                                ],
                              )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Email',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextFormField(
                                    controller: TextEditingController()
                                      ..text = user.email,
                                    decoration: const InputDecoration(
                                        hintText: "Votre Email"),
                                    enabled: false,
                                    onChanged: (value) {
                                      setState(() {
                                        user.email = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Mobile',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextFormField(
                                    keyboardType: TextInputType.phone,
                                    controller: TextEditingController()
                                      ..text = user.tel
                                      ..selection = TextSelection.fromPosition(
                                          TextPosition(
                                              offset: user.tel.length)),
                                    decoration: const InputDecoration(
                                        hintText: "Enter Mobile Number"),
                                    enabled: !_status,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Champ obligatoire !";
                                      }
                                      if (int.tryParse(value) == null ||
                                          value.length != 8 ||
                                          !validPhone(value))
                                        return "Téléphone Invalide";
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        user.tel = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: new Text(
                                      'Adresse',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  flex: 2,
                                ),
                                if (user.type.toLowerCase() ==
                                    USER_PARTICULIER.toLowerCase())
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                        'CIN',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                if (user.type.toLowerCase() ==
                                    USER_ENTREPRISE.toLowerCase())
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                        'PATENTE',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child: new TextFormField(
                                      controller: TextEditingController()
                                        ..text = user.adresse
                                        ..selection =
                                            TextSelection.fromPosition(
                                                TextPosition(
                                                    offset:
                                                        user.adresse.length)),
                                      decoration: const InputDecoration(
                                          hintText: "Votre Adresse"),
                                      enabled: !_status,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Champ obligatoire !";
                                        }
                                        if (value.length < 3)
                                          return "Adresse Invalide";
                                        return null;
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          user.adresse = value;
                                        });
                                      },
                                    ),
                                  ),
                                  flex: 2,
                                ),
                                if (user.type.toLowerCase() ==
                                    USER_PARTICULIER.toLowerCase())
                                  Flexible(
                                    child: new TextFormField(
                                      controller: TextEditingController()
                                        ..text = user.cin,
                                      decoration: const InputDecoration(
                                          hintText: "Votre CIN"),
                                      enabled: false,
                                      onChanged: (value) {
                                        setState(() {
                                          user.cin = value;
                                        });
                                      },
                                    ),
                                    flex: 2,
                                  ),
                                if (user.type.toLowerCase() ==
                                    USER_ENTREPRISE.toLowerCase())
                                  Flexible(
                                    child: new TextField(
                                      controller: TextEditingController()
                                        ..text = user.code,
                                      decoration: const InputDecoration(
                                          hintText: "Votre Patente"),
                                      enabled: false,
                                      onChanged: (value) {
                                        setState(() {
                                          user.code = value;
                                        });
                                      },
                                    ),
                                    flex: 2,
                                  ),
                              ],
                            )),
                        !_status ? _getActionButtons() : new Container(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    )));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  bool validPhone(p) {
    int n = int.tryParse(p.toString().substring(0, 2));
    if ((n >= 20 && n <= 29) || (n >= 90 && n <= 99) || (n >= 50 && n <= 59)) {
      return true;
    }
    return false;
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Sauvegarder"),
                textColor: Colors.grey[900],
                color: Colors.green,
                onPressed: () {
                  if (_formKey.currentState.validate()) update(user);
//                  setState(() {
//                    _status = true;
//                    FocusScope.of(context).requestFocus(new FocusNode());
//                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Annuler"),
                textColor: Colors.grey[900],
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  update(User user) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Mise à jour en cours...',
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
    User u = user;

    http.Response response = await http.post(
      Uri.http(apiBaseUrl, 'auth/update'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + user.token,
      },
      body: jsonEncode({
        "id": user.id,
        "adresse": user.adresse,
        "tel": user.tel,
        "prenom": user.prenom,
        "nom": user.nom
      }),
    );
    Map body = json.decode(response.body), info;
    //remove dialog
    Navigator.pop(context);
    print(response.body);
    print(response.statusCode);
    bool success = body["sucess"];
    if (response.statusCode == 200) {
      sharedPref.save("user", user);
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Opération Effectuée !'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Informations mis à jour !'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ],
            );
          });
    } else {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Opération Echoué !'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Informations non mis à jour !'),
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

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.grey[900],
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
