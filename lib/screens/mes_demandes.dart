import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfa_app/Models/User.dart';
import 'package:pfa_app/Utils/demandes_builder.dart';

class MesDemandesScreen extends StatefulWidget {
  User user;
  String filtre = 'all';

  MesDemandesScreen(this.user);

  @override
  _MesDemandesScreenState createState() => _MesDemandesScreenState(this.user);
}

class _MesDemandesScreenState extends State<MesDemandesScreen> {
  User user;
  String filtre = 'all';

  @override
  Widget build(BuildContext context) {
    double myWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: myWidth * 0.25,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    filtre = "Livré";
                  });
                },
                child: Card(
                    shape: RoundedRectangleBorder(
                      side: filtre == 'Livré'
                          ? BorderSide(color: Colors.green[900], width: 4)
                          : BorderSide(color: Colors.green, width: 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    color: Colors.green,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      child: Text(
                        'Livré',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                      ),
                    )),
              ),
            ),
            Container(
              width: myWidth * 0.25,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    filtre = "En Cours";
                  });
                },
                child: Card(
                    shape: RoundedRectangleBorder(
                      side: filtre == 'En Cours'
                          ? BorderSide(color: Colors.orange[900], width: 4)
                          : BorderSide(color: Colors.orange, width: 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    color: Colors.orange,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      child: Text(
                        'En Cours',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                      ),
                    )),
              ),
            ),
            Container(
              width: myWidth * 0.25,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    filtre = "annulé";
                  });
                },
                child: Card(
                    shape: RoundedRectangleBorder(
                      side: filtre == 'annulé'
                          ? BorderSide(color: Colors.red[900], width: 4)
                          : BorderSide(color: Colors.red, width: 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      child: Text(
                        'Annulée',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                      ),
                    )),
              ),
            ),
            Container(
              width: myWidth * 0.15,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    filtre = "all";
                  });
                },
                child: Card(
                    shape: RoundedRectangleBorder(
                      side: filtre == 'all'
                          ? BorderSide(color: Colors.grey[700], width: 4)
                          : BorderSide(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    color: Colors.grey,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        child: Icon(Icons.highlight_remove_outlined))),
              ),
            ),
          ],
        ),
        Expanded(
            child: DemandesBuilder(
          user: user,
          filtre: filtre,
        )),
      ],
    );
  }

  _MesDemandesScreenState(this.user);
}
