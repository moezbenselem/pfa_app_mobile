import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfa_app/Models/demande.dart';
import 'package:pfa_app/consts/const_strings.dart';

class DemandeDetailsCard extends StatelessWidget {
  DemandeDetailsCard(
      {@required this.data, @required this.height, @required this.showActions});

  final Demande data;
  final double height;
  final bool showActions;

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
                Hero(
                  tag: data.id,
                  child: Icon(
                    Icons.description,
                    size: myWidth * 0.25,
                  ),
                ),
                if (data.idPaiement != null)
                  Expanded(
                    child: Container(
                      width: myWidth * 0.50,
                      height: 130,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              data.description,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w100,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "de " + data.depart,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w100,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "à " + data.destination,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w100,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              data.date.substring(0, data.date.indexOf('T')),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w100,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "Paiement : " +
                                  TYPE_PAIEMENTS[data.idPaiement - 1]['titre'],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w100,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "Bagages : " + data.bagages.join(" ; "),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w100,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          )),
    );
  }
}
