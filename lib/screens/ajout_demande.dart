import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'package:pfa_app/Models/User.dart';
import 'package:pfa_app/Utils/api_config.dart';
import 'package:pfa_app/consts/constants.dart';
import 'package:pfa_app/screens/map.dart';

class AjoutDemandeScreen extends StatefulWidget {
  User user;

  AjoutDemandeScreen(this.user);

  @override
  _AjoutDemandeScreenState createState() => _AjoutDemandeScreenState(user);
}

class _AjoutDemandeScreenState extends State<AjoutDemandeScreen> {
  User user;
  var info = null;
  String departure = '', destination = '';
  DateTime selectedDate = DateTime.now();
  var demandeData = {};
  var typeBagages = [
    {"bagageId": 1, "titre": 'Fragile'},
    {"bagageId": 2, "titre": 'Electronique'},
    {"bagageId": 3, "titre": 'Emeuble'}
  ];
  var typePaiements = [
    {"id": 1, "titre": 'Chèque'},
    {"id": 2, "titre": 'Espèses'},
  ];
  bool chkFragile = false;
  bool chkElect = false;
  bool chkEm = false;
  List<dynamic> selectedBagages = [];
  int _radioValue = 0;

  var selectedPaiement = null;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
      selectedPaiement = typePaiements[value - 1];
    });
  }

  Coordinates departCords, destCords;

  TextEditingController departController = new TextEditingController();
  TextEditingController destinationcontroller = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  _AjoutDemandeScreenState(this.user);

  @override
  Widget build(BuildContext context) {
    double myWidth = MediaQuery.of(context).size.width;
    final _formKey = GlobalKey<FormState>();

    return Container(
      margin: EdgeInsets.only(top: 0, bottom: 0, right: 5, left: 5),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyFormField(
                  "description", "Description :", descriptionController),
              MyFormFieldMap("depart", "Départ :", departController),
              MyFormFieldMap(
                  "destination", "Destination :", destinationcontroller),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 8),
                child: Text(
                  "Types de Bagages :",
                  style: kFormLabelTextStyle,
                ),
              ),
              MyCheckBox(typeBagages[0]['titre'], false),
              MyCheckBox(typeBagages[1]['titre'], false),
              MyCheckBox(typeBagages[2]['titre'], false),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 8),
                child: Text(
                  "Types de Paiement :",
                  style: kFormLabelTextStyle,
                ),
              ),
              MyRadio(typePaiements[0], 1),
              MyRadio(typePaiements[1], 2),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  "Date de Départ",
                  style: kFormLabelTextStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Center(
                  child: TextButton.icon(
                    label: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    icon: Text(
                      "${selectedDate.toLocal()}".split(' ')[0],
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w100,
                          fontFamily: 'OpenSans',
                          fontSize: 18.0),
                    ),
                    onPressed: () => _selectDate(context),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: myWidth * 0.7,
                  height: myWidth * 0.12,
                  child: ElevatedButton(
                    onPressed: () =>
                        {if (_formKey.currentState.validate()) submitForm()},
                    child: Text(
                      "Ajouter",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w100,
                          fontFamily: 'OpenSans',
                          fontSize: 18.0),
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
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Widget MyFormField(
      String key, String hint, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintStyle: kHintTextStyle,
        labelText: hint,
      ),
      onChanged: (value) => demandeData[key] = value,
      validator: (value) {
        if (value.isEmpty || value == null) {
          return 'Champ Obligatoire !';
        }
        return null;
      },
    );
  }

  Widget MyFormFieldMap(
      String key, String hint, TextEditingController controller) {
    return TextFormField(
      onTap: () => {},
      controller: controller,
      decoration: InputDecoration(
        enabled: true,
        suffixIcon: IconButton(
          icon: Icon(Icons.place_outlined),
          onPressed: () async {
            info = await Navigator.push(
                context,
                CupertinoPageRoute(
                    fullscreenDialog: true, builder: (context) => MapScreen()));

            setState(() {
              if (key == 'destination') {
                destCords = info.first.coordinates;
                demandeData[key] = info.first.addressLine
                    .toString()
                    .replaceAll("Unnamed Road, ", "");
                demandeData[key] = info.first.addressLine
                    .toString()
                    .replaceAll("Unnamed Road، ", "");
              } else {
                demandeData[key] = info.first.addressLine
                    .toString()
                    .replaceAll("Unnamed Road, ", "");
                demandeData[key] = info.first.addressLine
                    .toString()
                    .replaceAll("Unnamed Road، ", "");
                departCords = info.first.coordinates;
              }

              controller.value = TextEditingValue(
                  text: info.first.addressLine
                      .toString()
                      .replaceAll("Unnamed Road, ", ""));
            });
          },
        ),
        hintStyle: kHintTextStyle,
        labelText: hint,
      ),
      onChanged: (value) => demandeData[key] = value,
      validator: (value) {
        if (value.isEmpty) {
          return 'Champ Obligatoire !';
        }
        return null;
      },
    );
  }

  Widget MyCheckBox(titre, isChecked) {
    if (titre == typeBagages[0]['titre']) isChecked = chkFragile;
    if (titre == typeBagages[1]['titre']) isChecked = chkElect;
    if (titre == typeBagages[2]['titre']) isChecked = chkEm;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Container(
        height: 20.0,
        child: Row(
          children: <Widget>[
            Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white),
              child: Checkbox(
                value: isChecked,
                checkColor: Colors.white,
                activeColor: Colors.red,
                onChanged: (value) {
                  setState(() {
                    if (titre == typeBagages[0]['titre']) {
                      chkFragile = value;
                      value
                          ? selectedBagages
                              .add({'bagageId': typeBagages[0]["bagageId"]})
                          : selectedBagages
                              .remove({'bagageId': typeBagages[0]["bagageId"]});
                    }
                    if (titre == typeBagages[1]['titre']) {
                      chkElect = value;
                      value
                          ? selectedBagages
                              .add({'bagageId': typeBagages[1]["bagageId"]})
                          : selectedBagages
                              .remove({'bagageId': typeBagages[1]["bagageId"]});
                    }
                    if (titre == typeBagages[2]['titre']) {
                      chkEm = value;
                      value
                          ? selectedBagages
                              .add({'bagageId': typeBagages[2]["bagageId"]})
                          : selectedBagages
                              .remove({'bagageId': typeBagages[2]["bagageId"]});
                    }
                  });
                },
              ),
            ),
            Text(
              titre,
              style: kHintTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget MyRadio(paiement, val) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Container(
        height: 20.0,
        child: Row(
          children: <Widget>[
            Theme(
              data: ThemeData(
                unselectedWidgetColor: Colors.white,
              ),
              child: Radio(
                value: val,
                groupValue: _radioValue,
                activeColor: Colors.red,
                onChanged: (value) {
                  setState(() {
                    _handleRadioValueChange(value);
                  });
                },
              ),
            ),
            Text(
              paiement["titre"],
              style: kHintTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  submitForm() async {
    print(selectedBagages);
    http.Response response = await http.post(
      Uri.http(apiBaseUrl, '/demande'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${user.token}',
      },
      body: jsonEncode(<String, dynamic>{
        "depart": demandeData['depart'],
        "destination": demandeData['destination'],
        "departLong": departCords.longitude,
        "destinationLong": destCords.longitude,
        "departLat": departCords.latitude,
        "destinationLat": destCords.latitude,
        "description": demandeData['description'],
        "date": selectedDate.toLocal().toString().split(' ')[0],
        "userId": user.id,
        "paiementId": selectedPaiement['id'],
        "suivie": "en cours",
        "etat": false,
        "types_bagages": selectedBagages
      }),
    );
    print(response.body);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success !'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Demande Publiée !'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                setState(() {
                  demandeData = {};
                  _radioValue = 0;
                  chkFragile = false;
                  chkElect = false;
                  chkEm = false;
                  selectedBagages = [];
                  info = null;
                  departure = '';
                  destination = '';
                  selectedDate = DateTime.now();
                  departController.text = "";
                  destinationcontroller.text = "";
                  descriptionController.text = "";
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
