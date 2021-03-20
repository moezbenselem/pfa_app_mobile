import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pfa_app/Models/User.dart';
import 'package:pfa_app/Models/demandes.dart';
import 'package:pfa_app/widgets/demande_card.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'api_config.dart';

class DemandesBuilder extends StatelessWidget {
  final User user;

  DemandesBuilder({@required this.user});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Demandes>(
        future: fetchDemandes(user),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }
          if (snapshot.hasData)
            return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.listDemandes.length,
                itemBuilder: (context, index) {
                  return DemandeCard(
                      data: snapshot.data.listDemandes[index], height: 200);
                });
          else
            return JumpingDotsProgressIndicator(
              color: Colors.grey,
            );
        });
  }

  Future<Demandes> fetchDemandes(User user) async {
    var token = user.token;
    http.Response response = await http.get(
      Uri.http(apiBaseUrl, 'demandes/' + user.id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      try {
        print("slm");
        Demandes demandes = Demandes.fromJson(json.decode(response.body));
        print(demandes);
        return demandes;
      } catch (Exception) {
        Exception.toString();
      }
    } else {
      print("cant load demandes !");
    }
  }
}
