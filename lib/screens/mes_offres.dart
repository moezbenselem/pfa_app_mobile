import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfa_app/Models/User.dart';
import 'package:pfa_app/Utils/offres_builder.dart';
import 'package:pfa_app/consts/const_strings.dart';

class MesOffresScreen extends StatefulWidget {
  User user;
  String filtre = 'all';

  MesOffresScreen(this.user);

  @override
  _MesOffresScreenState createState() => _MesOffresScreenState(this.user);
}

class _MesOffresScreenState extends State<MesOffresScreen> {
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
                    filtre = ETAT_OFFRE_ACCEPT;
                  });
                },
                child: Card(
                    shape: RoundedRectangleBorder(
                      side: filtre == ETAT_OFFRE_ACCEPT
                          ? BorderSide(color: Colors.green[900], width: 4)
                          : BorderSide(color: Colors.green, width: 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    color: Colors.green,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      child: Text(
                        ETAT_OFFRE_ACCEPT,
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
                    filtre = ETAT_OFFRE_DEFAULT;
                  });
                },
                child: Card(
                    shape: RoundedRectangleBorder(
                      side: filtre == ETAT_OFFRE_DEFAULT
                          ? BorderSide(color: Colors.orange[900], width: 4)
                          : BorderSide(color: Colors.orange, width: 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    color: Colors.orange,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      child: Text(
                        ETAT_OFFRE_DEFAULT,
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
                    filtre = ETAT_OFFRE_REFUS;
                  });
                },
                child: Card(
                    shape: RoundedRectangleBorder(
                      side: filtre == ETAT_OFFRE_REFUS
                          ? BorderSide(color: Colors.red[900], width: 4)
                          : BorderSide(color: Colors.red, width: 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      child: Text(
                        ETAT_OFFRE_REFUS,
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
            child: OffresBuilder(
          user: user,
          filtre: filtre,
        )),
      ],
    );
  }

  _MesOffresScreenState(this.user);
}
