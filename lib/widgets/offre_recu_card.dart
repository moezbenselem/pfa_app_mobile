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
import 'package:pfa_app/screens/details.dart';
import 'package:pfa_app/services.dart';

class OffreRecuCard extends StatefulWidget {
  OffreRecuCard(
      {@required this.user, @required this.data, @required this.height});

  @override
  User user;
  final Offre data;
  final double height;

  _OffresRecusCard createState() => _OffresRecusCard(user, data);
}

class _OffresRecusCard extends State<OffreRecuCard> {
  User user;
  final Offre data;
  String cmnt;
  bool showMore = false;
  final _formKey = GlobalKey<FormState>();

  _OffresRecusCard(this.user, this.data);

  @override
  Widget build(BuildContext context) {
    double myWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        setState(() {
          showMore = !showMore;
        });
      },
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
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          data.commentaire,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w100,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          data.date.substring(0, data.date.indexOf('T')),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w100,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          data.prix.toString() + "dt",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w100,
                            color: Colors.lightGreen,
                          ),
                        ),
                        if (data.etat.toLowerCase() == ETAT_OFFRE_DEFAULT)
                          Center(
                            child: ElevatedButton(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: new Text("Accepter"),
                              ),
                              onPressed: () {
                                acceptOffre(data.id, data.demandeId);
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 5.0,
                                primary: Colors.green,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0)),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 120,
                  width: myWidth * 0.18,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      PopupMenuButton(
                        icon: Icon(Icons.info_outline),
                        onSelected: (selected) async {
                          if (selected == 0) {
                            var d = await fetchDemandeDetails(
                                user.token, data.demandeId.toString());
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return DetailsScreen(Demande.fromJson(d));
                            }));
                          }
                          if (selected == 1) {
                            var u = await fetchUserInfo(
                                user.token, data.userId.toString());
                            _callNumber(u['tel']);
                          }
                          if (selected == 2) {
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
                          const PopupMenuItem<int>(
                            value: 1,
                            child: Text('Appeler'),
                          ),
                          const PopupMenuItem<int>(
                            value: 2,
                            child: Text('Reclamation'),
                          ),
                        ],
                      ),
                      Text(
                        data.etat,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w100,
                          color: data.etat.toLowerCase().compareTo(
                                      ETAT_OFFRE_ACCEPT.toLowerCase()) ==
                                  0
                              ? Colors.green
                              : Colors.deepOrangeAccent,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  acceptOffre(offreId, demandeId) {
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
                  child: Text("Vous ??tes sur le point d'accepter une offre !"),
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
                String token = user.token;
                http.Response response = await http.post(
                  Uri.http(apiBaseUrl, 'offre/updateEtat'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Authorization': 'Bearer $token',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'etat': ETAT_OFFRE_ACCEPT,
                    'offreId': offreId,
                    'demandeId': demandeId
                  }),
                );
                if (response.statusCode == 200) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Offre Accept??e !')));
                } else {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Op??ration Echou?? !'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text("Veillez ressayer !"),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('R??essayer'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
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
            .showSnackBar(SnackBar(content: Text('Reclamation envoy??e !')));
      } catch (Exception) {
        Exception.toString();
      }
    } else {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Op??ration Echou?? !'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("La R??clamation n'est pas envoy??e!"),
                  Text("Veillez ressayer !"),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('R??essayer'),
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
