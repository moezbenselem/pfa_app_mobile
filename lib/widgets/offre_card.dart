import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfa_app/Models/offre.dart';
import 'package:pfa_app/consts/constants.dart';

class OffreCard extends StatelessWidget {
  OffreCard({@required this.data, @required this.height});

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
                  height: 100,
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
                      Icon(Icons.info_outline),
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
}
