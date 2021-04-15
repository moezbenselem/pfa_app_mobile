import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfa_app/Models/User.dart';
import 'package:pfa_app/Utils/offres_builder.dart';

class MesOffresScreen extends StatelessWidget {
  User user;

  MesOffresScreen(this.user);

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
              child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.green, width: 1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  color: Colors.green,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Text(
                      'Livré',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                    ),
                  )),
            ),
            Container(
              width: myWidth * 0.25,
              child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.orange, width: 1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  color: Colors.orange,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Text(
                      'En Cours',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                    ),
                  )),
            ),
            Container(
              width: myWidth * 0.25,
              child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.red, width: 1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  color: Colors.red,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Text(
                      'Annulée',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                    ),
                  )),
            ),
          ],
        ),
        Expanded(
            child: OffresBuilder(
          user: user,
        )),
      ],
    );
  }
}
