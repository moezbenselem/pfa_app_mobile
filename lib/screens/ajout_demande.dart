import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfa_app/Models/User.dart';
import 'package:pfa_app/consts/constants.dart';

class AjoutDemandeScreen extends StatefulWidget {
  User user;

  AjoutDemandeScreen(this.user);

  @override
  _AjoutDemandeScreenState createState() => _AjoutDemandeScreenState(user);
}

class _AjoutDemandeScreenState extends State<AjoutDemandeScreen> {
  User user;
  DateTime selectedDate = DateTime.now();
  var demandeData = {};
  var typeBagages = [
    {"id": 1, "titre": 'Fragile'},
    {"id": 2, "titre": 'Electronique'},
    {"id": 3, "titre": 'Emeuble'}
  ];
  var typePaiements = [
    {"id": 1, "titre": 'Chèque'},
    {"id": 2, "titre": 'Espèses'},
  ];
  var selectedBagages = {};
  var selectedPaiement = null;

  _AjoutDemandeScreenState(this.user);

  @override
  Widget build(BuildContext context) {
    double myWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(top: 0, bottom: 0, right: 5, left: 5),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyFormField("description", "Description :"),
            MyFormField("depart", "Départ :"),
            MyFormField("destination", "Destination :"),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 8),
              child: Text(
                "Types de Bagages :",
                style: kFormLabelTextStyle,
              ),
            ),
            MyCheckBox(typeBagages[0]),
            MyCheckBox(typeBagages[1]),
            MyCheckBox(typeBagages[2]),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 8),
              child: Text(
                "Types de Paiement :",
                style: kFormLabelTextStyle,
              ),
            ),
            MyRadio(typePaiements[0]),
            MyRadio(typePaiements[1]),
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
                  onPressed: () => {},
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
    );
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

  Widget MyFormField(String key, String hint) {
    return TextFormField(
      decoration: InputDecoration(hintStyle: kHintTextStyle, labelText: hint),
      onChanged: (value) => demandeData[key] = value,
      validator: (value) {
        if (value.isEmpty) {
          return 'Champ Obligatoire !';
        }
        return null;
      },
    );
  }

  Widget MyCheckBox(bagage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Container(
        height: 20.0,
        child: Row(
          children: <Widget>[
            Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white),
              child: Checkbox(
                value: selectedBagages[bagage['id']] != null,
                checkColor: Colors.white,
                activeColor: Colors.red,
                onChanged: (value) {
                  setState(() {
                    selectedBagages[bagage['id']] = bagage.id;
                  });
                },
              ),
            ),
            Text(
              bagage["titre"],
              style: kHintTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget MyRadio(paiement) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Container(
        height: 20.0,
        child: Row(
          children: <Widget>[
            Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white),
              child: Radio(
                value: selectedPaiement == paiement['id'],
                activeColor: Colors.red,
                onChanged: (value) {
                  setState(() {
                    selectedPaiement = paiement['id'];
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
}
