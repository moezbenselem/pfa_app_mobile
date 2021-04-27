import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfa_app/Models/User.dart';
import 'package:pfa_app/Models/offre.dart';

class OffreRecuCard extends StatefulWidget {
  OffreRecuCard({@required this.data, @required this.height});

  @override
  User user;
  final Offre data;
  final double height;
  bool showMore = false;

  _OffresRecusCard createState() => _OffresRecusCard(data);
}

class _OffresRecusCard extends State<OffreRecuCard> {
  User user;
  final Offre data;
  bool showMore = false;

  _OffresRecusCard(this.data);

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
                      RaisedButton(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: new Text("Accepter"),
                        ),
                        textColor: Colors.grey[900],
                        color: Colors.green,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0)),
                      )
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
                      IconButton(
                        icon: Icon(Icons.info_outline),
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
}
