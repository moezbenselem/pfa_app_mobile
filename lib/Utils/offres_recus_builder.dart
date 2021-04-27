import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pfa_app/Models/User.dart';
import 'package:pfa_app/Models/offres.dart';
import 'package:pfa_app/widgets/offre_card.dart';
import 'package:pfa_app/widgets/offre_recu_card.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'api_config.dart';

class OffresRecusBuilder extends StatelessWidget {
  final User user;

  OffresRecusBuilder({@required this.user});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Offres>(
        future: fetchOffresRecus(user),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }
          if (snapshot.hasData)
            return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.listOffres.length,
                itemBuilder: (context, index) {
                  return OffreRecuCard(
                      data: snapshot.data.listOffres[index], height: 200);
                });
          else
            return JumpingDotsProgressIndicator(
              color: Colors.grey,
            );
        });
  }

  Future<Offres> fetchOffresRecus(User user) async {
    var token = user.token;
    http.Response response = await http.get(
      Uri.http(apiBaseUrl, 'offre/recus/' + user.id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      try {
        Offres offres = Offres.fromJson(json.decode(response.body));
        return offres;
      } catch (Exception) {
        Exception.toString();
      }
    } else {
      print("cant load offres !");
      print(response.body);
    }
  }
}
