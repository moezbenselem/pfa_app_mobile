import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfa_app/Models/User.dart';
import 'package:pfa_app/consts/constants.dart';
import 'package:pfa_app/widgets/drawer.dart';

class AjoutDemandeScreen extends StatefulWidget {
  User user;

  AjoutDemandeScreen(this.user);

  @override
  _AjoutDemandeScreenState createState() => _AjoutDemandeScreenState(user);
}

class _AjoutDemandeScreenState extends State<AjoutDemandeScreen> {
  User user;
  DateTime selectedDate = DateTime.now();

  _AjoutDemandeScreenState(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Creation de Demande",
            style: kAppTitle,
          ),
        ),
        drawer: Drawer(
          child: DrawerWidget(this.user),
        ),
        body: ListView(
          children: [
            TextFormField(
              decoration: InputDecoration(
                  hintStyle: kHintTextStyle, labelText: "Description :"),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  hintStyle: kHintTextStyle, labelText: "Ville de Départ :"),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  hintStyle: kHintTextStyle, labelText: "Ville d'arrivée :"),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Text(
              "Date de Départ :",
              style: kFormLabelTextStyle,
            ),
            TextButton(
              onPressed: () => _selectDate(context),
              child: Text(
                "${selectedDate.toLocal()}".split(' ')[0],
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w100,
                    fontFamily: 'OpenSans',
                    fontSize: 18.0),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: 150, height: 50),
              child: ElevatedButton(
                onPressed: () => {},
                child: Text(
                  "Ajouter",
                  style: kLabelTextStyle,
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red[900],
                  onPrimary: Colors.red[500],
                  elevation: 5.0,
                  padding: EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            )
          ],
        ));
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
}
