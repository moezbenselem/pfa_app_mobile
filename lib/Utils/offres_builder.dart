import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pfa_app/Models/User.dart';
import 'package:pfa_app/Models/offres.dart';
import 'package:pfa_app/widgets/offre_card.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'api_config.dart';

class OffresBuilder extends StatelessWidget {
  final User user;
  final String filtre;

  OffresBuilder({@required this.user, this.filtre});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Offres>(
        future: fetchOffres(user, filtre),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }
          if (snapshot.hasData)
            return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.listOffres.length,
                itemBuilder: (context, index) {
                  return OffreCard(
                      user: user,
                      data: snapshot.data.listOffres[index],
                      height: 200);
                });
          else
            return JumpingDotsProgressIndicator(
              color: Colors.grey,
            );
        });
  }

  Future<Offres> fetchOffres(User user, String filtre) async {
    var token = user.token;
    filtre = filtre.replaceAll("é", "e").replaceAll(' ', '').toLowerCase();
    print('fetching ${filtre}');
    http.Response response = await http.get(
      Uri.http(apiBaseUrl, 'offres/' + user.id.toString() + "/" + filtre),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
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
