import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfa_app/Models/demande.dart';
import 'package:pfa_app/consts/constants.dart';

class DemandeCard extends StatelessWidget {
  DemandeCard({@required this.data, @required this.height});

  final Demande data;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: Card(
          elevation: 5,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.description,
                      size: 100,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          data.description,
                          style: kLabelTextStyle,
                        ),
                        Text(
                          data.depart,
                          style: kLabelTextStyle,
                        ),
                        Text(
                          data.destination,
                          style: kLabelTextStyle,
                        ),
                        Text(
                          data.date.substring(0, data.date.indexOf('T')),
                          style: kLabelTextStyle,
                        ),
                      ],
                    )
                  ],
                ),
              )),
        ));
  }
}
