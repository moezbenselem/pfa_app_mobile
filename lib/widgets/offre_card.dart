import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:pfa_app/Models/User.dart';
import 'package:pfa_app/Models/demande.dart';
import 'package:pfa_app/Models/offre.dart';
import 'package:pfa_app/screens/details.dart';
import 'package:pfa_app/services.dart';

class OffreCard extends StatelessWidget {
  OffreCard({@required this.user, @required this.data, @required this.height});
  User user;
  final Offre data;
  final double height;

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
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  width: myWidth * 0.16,
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
                          if (selected == 2) {
                            var d = await fetchDemandeDetails(
                                user.token, data.demandeId.toString());
                            var u = await fetchUserInfo(
                                user.token, d['userId'].toString());
                            _callNumber(u['tel']);
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
                            child: Text('Supprimer Offre'),
                          ),
                          const PopupMenuItem<int>(
                            value: 2,
                            child: Text('Appeler'),
                          ),
                        ],
                      ),
                      Text(
                        data.etat,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w100,
                          color: Colors.deepOrangeAccent,
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

  _callNumber(number) async {
    bool res = await FlutterPhoneDirectCaller.callNumber(number);
  }
}
