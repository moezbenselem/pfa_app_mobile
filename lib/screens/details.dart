import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:pfa_app/Models/User.dart';
import 'package:pfa_app/Models/demande.dart';
import 'package:pfa_app/Utils/SharedPref.dart';
import 'package:pfa_app/Utils/api_config.dart';
import 'package:pfa_app/consts/const_strings.dart';
import 'package:pfa_app/consts/constants.dart';
import 'package:pfa_app/screens/accueil.dart';
import 'package:pfa_app/widgets/demande_details_card.dart';
import 'package:progress_indicators/progress_indicators.dart';

class DetailsScreen extends StatefulWidget {
  var data;
  User user;

  DetailsScreen(this.data);

  @override
  _DetailsScreenState createState() => _DetailsScreenState(data);
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    if (mapController != null) mapController.dispose();
  }

  Demande data;
  User user;
  GoogleMapController mapController;

  _DetailsScreenState(this.data);

  Completer<GoogleMapController> _controller = Completer();
  String searchValue = "";
  Set<Marker> markers = HashSet<Marker>();
  CameraPosition departCam, destCam;
  Marker markerDepart, markerDest;
  double distanceInMeters;
  String cmnt;
  double prix;
  bool showMap = false;
  Timer _timer;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    departCam = CameraPosition(
        target: LatLng(data.latDepart, data.longDepart), zoom: 7);
    destCam =
        CameraPosition(target: LatLng(data.latDest, data.longDest), zoom: 7);

    distanceInMeters = Geolocator.distanceBetween(
      data.latDepart,
      data.longDepart,
      data.latDest,
      data.longDepart,
    );

    markerDepart = Marker(
        markerId: new MarkerId("Depart"),
        position: LatLng(data.latDepart, data.longDepart),
        infoWindow: InfoWindow(title: "Depart", snippet: data.depart),
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange));
    markerDest = Marker(
        markerId: new MarkerId("Destination"),
        position: LatLng(data.latDest, data.longDest),
        infoWindow: InfoWindow(title: "Destination", snippet: data.destination),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan));
    markers.add(markerDepart);
    markers.add(markerDest);

    print("map timer started");
    const delay = const Duration(seconds: 1);
    if (_timer == null) {
      _timer = new Timer.periodic(
        delay,
        (Timer timer) {
          setState(() {
            showMap = true;
            _timer.cancel();
          });
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Details Demande", style: kAppTitle),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<dynamic>(
                  future: fetchDetails(data.id),
                  builder: (context, demande) {
                    if (demande.hasData) {
                      List<String> bagages = [];
                      List<dynamic> l = [];

                      l = demande.data["types_bagages"];
                      l.forEach((element) {
                        bagages.add(element["titre"]);
                      });
                      data.bagages = bagages;
                      data.idPaiement = demande.data['paiementId'];
                      return DemandeDetailsCard(data: data, height: 200);
                    } else {
                      return DemandeDetailsCard(data: data, height: 200);
                    }
                  }),
              Expanded(
                  child: Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: showMap
                    ? Stack(
                        children: [
                          GoogleMap(
                            myLocationButtonEnabled: true,
                            myLocationEnabled: true,
                            mapToolbarEnabled: true,
                            mapType: MapType.normal,
                            initialCameraPosition: departCam,
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                              setState(() {
                                mapController = controller;
                              });
                            },
                            markers: markers,
                          ),
                          Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                "Distance : ~" +
                                    (distanceInMeters / 1000)
                                        .toStringAsFixed(2) +
                                    ' Km',
                                style: kDistanceStyle,
                              )),
                        ],
                      )
                    : JumpingDotsProgressIndicator(
                        color: Colors.grey,
                      ),
              )),
              if (user != null) _getEditButtons()
            ],
          ),
        ),
      )),
    );
  }

  sendOffre() async {
    print("sending offre");
    //user = User.fromJson(await SharedPref().read('user'));
    var token = user.token;

    http.Response response;
    response = await http.post(Uri.http(apiBaseUrl, 'offre/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          "commentaire": cmnt,
          "prix": prix,
          "userId": user.id,
          "demandeId": data.id,
          "etat": "en cours",
          "date": data.date
        }));
    if (response.statusCode == 200) {
      try {
        var o = jsonDecode(response.body);
        print("offre result : " + response.body);

        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Offre Postulée !')));
      } catch (Exception) {
        Exception.toString();
      }
    } else {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Opération Echoué !'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("Votre Offre n'a pas été postuler !"),
                  Text("Veillez ressayer !"),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Réessayer'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      print("cant add offre !");
    }
  }

  fetchDetails(id) async {
    user = User.fromJson(await SharedPref().read('user'));
    var token = user.token;
    http.Response response;
    response = await http.get(
      Uri.http(apiBaseUrl, 'demande/' + data.id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      try {
        var d = jsonDecode(response.body);
        print(d);
        return d;
      } catch (Exception) {
        Exception.toString();
      }
    } else {
      print("cant load demandes !");
    }
  }

  Widget _getEditButtons() {
    if (user.role.toLowerCase() == USER_ROLE_TRANSPORTEUR.toLowerCase())
      return Align(
          alignment: Alignment.center,
          child: new RaisedButton(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: new Text("Postuler"),
            ),
            textColor: Colors.grey[900],
            color: Colors.green,
            onPressed: () {
              return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Information'),
                    content: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: ListBody(
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(
                                hintStyle: kHintTextStyle,
                                labelText: "Votre Commentaire",
                              ),
                              onChanged: (value) {
                                setState(() {
//                                if (value.isEmpty)
//                                  cmnt = "Je suis d'accord !";
//                                else
                                  cmnt = value;
                                });
                              },
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value.isEmpty || value == null)
                                  return "Champ Obligatoire !";
                                return null;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                hintStyle: kHintTextStyle,
                                labelText: "Vos Charges en DT",
                              ),
                              onChanged: (value) {
                                if (double.tryParse(value) != null)
                                  setState(() {
                                    prix = double.parse(value);
                                  });
                              },
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value.isEmpty || value == null) {
                                  return 'Champ Obligatoire !';
                                }
                                if (double.tryParse(value) == null ||
                                    double.tryParse(value) < 0) {
                                  return 'Prix Invalide !';
                                }
                                return null;
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Envoyer'),
                        onPressed: () {
                          if (_formKey.currentState.validate()) sendOffre();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0)),
          ));
    else
      return Padding(
        padding:
            EdgeInsets.only(left: 25.0, right: 25.0, top: 15.0, bottom: 15),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Container(
                    child: new RaisedButton(
                  child: new Text("Edit"),
                  textColor: Colors.grey[900],
                  color: Colors.green,
                  onPressed: () {},
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0)),
                )),
              ),
              flex: 2,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Container(
                    child: new RaisedButton(
                  child: new Text("Delete"),
                  textColor: Colors.grey[900],
                  color: Colors.red,
                  onPressed: () {
                    deleteDemande(user.id, data.id);
                  },
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0)),
                )),
              ),
              flex: 2,
            ),
          ],
        ),
      );
  }

  deleteDemande(userId, demandeId) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text("Vous ètes sur le point de supprimer une demande !"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Continuer !"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text("J'accepte"),
              style: TextButton.styleFrom(
                  primary: Colors.white, backgroundColor: Colors.green),
              onPressed: () async {
                String token = user.token;
                http.Response response = await http.delete(
                  Uri.http(apiBaseUrl, 'demande'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Authorization': 'Bearer $token',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'userId': userId,
                    'demandeId': demandeId
                  }),
                );
                if (response.statusCode == 200) {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Opération éffectuée !'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text("Demande Supprimée !"),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Ok'),
                            onPressed: () {
                              //Navigator.of(context).pop();
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return Accueil.forUser(user);
                              }));
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Opération Echoué !'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text("Veillez ressayer !"),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Réessayer'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
            TextButton(
              child: Text("Annuler"),
              style: TextButton.styleFrom(
                  primary: Colors.white, backgroundColor: Colors.deepOrange),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
