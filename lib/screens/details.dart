import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:pfa_app/Models/User.dart';
import 'package:pfa_app/Utils/SharedPref.dart';
import 'package:pfa_app/Utils/api_config.dart';
import 'package:pfa_app/consts/const_strings.dart';
import 'package:pfa_app/consts/constants.dart';
import 'package:pfa_app/widgets/demande_card.dart';

class DetailsScreen extends StatefulWidget {
  var data;
  User user;

  DetailsScreen(this.data);

  @override
  _DetailsScreenState createState() => _DetailsScreenState(data);
}

class _DetailsScreenState extends State<DetailsScreen> {
  var data;
  User user;

  _DetailsScreenState(this.data);

  Completer<GoogleMapController> _controller = Completer();
  String searchValue = "";
  Set<Marker> markers = HashSet<Marker>();
  CameraPosition departCam, destCam;
  Marker markerDepart, markerDest;
  double distanceInMeters;
  String cmnt;
  double prix;

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

    return Scaffold(
      appBar: AppBar(
        title: Text("Details Demande", style: kAppTitle),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DemandeCard(data: data, height: 200, showActions: false),
            FutureBuilder<dynamic>(
              future: fetchDetails(data.id),
              builder: (context, demande) {
                List<String> bagages = [];
                List<dynamic> l = demande.data["types_bagages"];
                l.forEach((element) {
                  bagages.add(element["titre"]);
                });
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Paiement : " +
                              TYPE_PAIEMENTS[demande.data['paiementId'] - 1]
                                  ['titre'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w100,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "Bagages : " + bagages.join(" ; "),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w100,
                            color: Colors.grey,
                          ),
                        ),
                      ]),
                );
              },
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Stack(
                children: [
                  GoogleMap(
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    mapToolbarEnabled: true,
                    mapType: MapType.normal,
                    initialCameraPosition: departCam,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    markers: markers,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 75.0, horizontal: 16),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: FloatingActionButton(
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: Colors.cyan,
                        child: const Icon(Icons.pending_outlined, size: 36.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 150.0, horizontal: 16),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: FloatingActionButton(
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: Colors.orange,
                        child: const Icon(Icons.mobile_friendly, size: 36.0),
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        "Distance : " +
                            (distanceInMeters / 1000).toStringAsFixed(2) +
                            ' Km',
                        style: kDistanceStyle,
                      )),
                ],
              ),
            )),
            Align(
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
                            child: ListBody(
                              children: <Widget>[
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintStyle: kHintTextStyle,
                                    labelText: "Votre Commentaire",
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value.isEmpty)
                                        cmnt = "Je suis d'accord !";
                                      else
                                        cmnt = value;
                                    });
                                  },
                                  keyboardType: TextInputType.text,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintStyle: kHintTextStyle,
                                    labelText: "Vos Charges en DT",
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      prix = double.parse(value);
                                    });
                                  },
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Champ Obligatoire !';
                                    }
                                    return null;
                                  },
                                )
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Envoyer'),
                              onPressed: () {
                                sendOffre();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0)),
                )),
          ],
        ),
      )),
    );
  }

  sendOffre() async {
    print("sending offre");
    user = User.fromJson(await SharedPref().read('user'));
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
        return o;
      } catch (Exception) {
        Exception.toString();
      }
    } else {
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
}
