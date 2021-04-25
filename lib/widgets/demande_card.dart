import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfa_app/Models/demande.dart';
import 'package:pfa_app/consts/constants.dart';
import 'package:pfa_app/screens/details.dart';

class DemandeCard extends StatelessWidget {
  DemandeCard(
      {@required this.data, @required this.height, @required this.showActions});

  final Demande data;
  final double height;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    double myWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {},
      child: Hero(
        tag: data.id,
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
                  Expanded(
                    child: Container(
                      width: myWidth * 0.50,
                      height: 130,
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
                        ],
                      ),
                    ),
                  ),
                  if (showActions)
                    Container(
                      height: 100,
                      width: myWidth * 0.16,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.info_outline),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return DetailsScreen(data);
                              }));
                            },
                          ),
                          data.etat
                              ? Icon(
                                  Icons.check,
                                  color: Colors.lightGreen,
                                )
                              : Icon(
                                  Icons.pending_outlined,
                                  color: Colors.orange,
                                ),
                          Text(
                            data.suivie,
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
      ),
    );
  }
}
