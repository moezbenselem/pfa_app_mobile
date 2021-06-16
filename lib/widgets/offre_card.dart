import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:http/http.dart' as http;
import 'package:pfa_app/Models/User.dart';
import 'package:pfa_app/Models/demande.dart';
import 'package:pfa_app/Models/offre.dart';
import 'package:pfa_app/Utils/api_config.dart';
import 'package:pfa_app/consts/const_strings.dart';
import 'package:pfa_app/consts/constants.dart';
import 'package:pfa_app/screens/accueil.dart';
import 'package:pfa_app/screens/details.dart';
import 'package:pfa_app/services.dart';

class OffreCard extends StatefulWidget {
  OffreCard({@required this.user, @required this.data, @required this.height});

  User user;
  final Offre data;
  final double height;

  @override
  _OffreCardState createState() => _OffreCardState();
}

class _OffreCardState extends State<OffreCard> {
  final _formKey = GlobalKey<FormState>();
  String cmnt;
  @override
  Widget build(BuildContext context) {
    double myWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {},
      child: Card(
          elevation: 5,
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.description,
                  size: myWidth * 0.25,
                ),
                Container(
                  width: myWidth * 0.50,
                  height: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        widget.data.commentaire,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w100,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        widget.data.date
                            .substring(0, widget.data.date.indexOf('T')),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w100,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        widget.data.prix.toString() + "dt",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w100,
                          color: Colors.lightGreen,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  width: myWidth * 0.16,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        PopupMenuButton(
                          icon: Icon(Icons.info_outline),
                          onSelected: (selected) async {
                            if (selected == 0) {
                              var d = await fetchDemandeDetails(
                                  widget.user.token,
                                  widget.data.demandeId.toString());
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return DetailsScreen(Demande.fromJson(d));
                              }));
                            }
                            if (selected == 1) {
                              deleteOffre(widget.data.id);
                            }
                            if (selected == 2) {
                              var d = await fetchDemandeDetails(
                                  widget.user.token,
                                  widget.data.demandeId.toString());
                              var u = await fetchUserInfo(
                                  widget.user.token, d['userId'].toString());
                              _callNumber(u['tel']);
                            }
                            if (selected == 3) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Information'),
                                    content: SingleChildScrollView(
                                      child: Form(
                                        key: _formKey,
                                        child: ListBody(
                                          children: <Widget>[
                                            TextFormField(
                                              decoration: InputDecoration(
                                                hintStyle: kHintTextStyle,
                                                labelText: "Votre Commentaire",
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  cmnt = value;
                                                });
                                              },
                                              keyboardType: TextInputType.text,
                                              validator: (value) {
                                                if (value.isEmpty ||
                                                    value == null)
                                                  return "Champ Obligatoire !";
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Envoyer'),
                                        onPressed: () {
                                          if (_formKey.currentState.validate())
                                            sendReclamation();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<int>>[
                            const PopupMenuItem<int>(
                              value: 0,
                              child: Text('Voir Demande'),
                            ),
                            if (widget.data.etat.toLowerCase() ==
                                    ETAT_OFFRE_DEFAULT.toLowerCase() ||
                                widget.data.etat.toLowerCase() ==
                                    ETAT_OFFRE_REFUS.toLowerCase())
                              const PopupMenuItem<int>(
                                value: 1,
                                child: Text('Supprimer Offre'),
                              ),
                            if (widget.data.etat.toLowerCase() ==
                                ETAT_OFFRE_ACCEPT.toLowerCase())
                              const PopupMenuItem<int>(
                                value: 3,
                                child: Text('Réclamation'),
                              ),
                            const PopupMenuItem<int>(
                              value: 2,
                              child: Text('Appeler'),
                            ),
                          ],
                        ),
                        Text(
                          widget.data.etat,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w100,
                            color: widget.data.etat.toLowerCase().compareTo(
                                        ETAT_OFFRE_ACCEPT.toLowerCase()) ==
                                    0
                                ? Colors.green
                                : Colors.deepOrangeAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  deleteOffre(offreId) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text("Vous ètes sur le point de supprimer une offre !"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Continuer !"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
                child: Text("J'accepte"),
                style: TextButton.styleFrom(
                    primary: Colors.white, backgroundColor: Colors.green),
                onPressed: () async {
                  String token = widget.user.token;
                  http.Response response = await http.delete(
                    Uri.http(apiBaseUrl, 'offre'),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                      'Authorization': 'Bearer $token',
                    },
                    body: jsonEncode(<String, dynamic>{
                      'userId': widget.user.id,
                      'offreId': widget.data.id
                    }),
                  );
                  if (response.statusCode == 200) {
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Opération éffectuée !'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text("Demande Supprimée !"),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Ok'),
                              onPressed: () {
                                //Navigator.of(context).pop();
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Accueil.forUser(widget.user);
                                }));
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Opération Echoué !'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text("Veillez ressayer !"),
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
                }),
            TextButton(
              child: Text("Annuler"),
              style: TextButton.styleFrom(
                  primary: Colors.white, backgroundColor: Colors.deepOrange),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  sendReclamation() async {
    print("sending reclamation");
    //user = User.fromJson(await SharedPref().read('user'));
    var token = widget.user.token;

    http.Response response;
    response = await http.post(Uri.http(apiBaseUrl, 'reclamation/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          "description": cmnt,
          "offreId": widget.data.id,
          "userId": widget.user.id,
          "date": DateTime.now().toLocal().toString().split(' ')[0],
        }));
    if (response.statusCode == 200) {
      try {
        var o = jsonDecode(response.body);
        print("reclamation result : " + response.body);

        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Reclamation envoyée !')));
      } catch (Exception) {
        Exception.toString();
      }
    } else {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Opération Echoué !'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("La Réclamation n'est pas envoyée!"),
                  Text("Veillez ressayer !"),
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
      print("cant add reclamation !");
    }
  }

  _callNumber(number) async {
    bool res = await FlutterPhoneDirectCaller.callNumber(number);
  }
}
