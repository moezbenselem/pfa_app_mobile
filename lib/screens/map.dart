import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pfa_app/Utils/SharedPref.dart';
import 'package:pfa_app/consts/constants.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  String searchValue = "";
  Set<Marker> markers = HashSet<Marker>();
  SharedPref shared = SharedPref();
  Coordinates testCord = Coordinates(35.238847, 11.118249);
  Coordinates selectedCords = null;
  CameraPosition currentPosition =
          CameraPosition(target: LatLng(35.238847, 11.118249), zoom: 7),
      searchPosition = null;
  Marker curentPosMarker = null, selectedMarker = null;
  var selectedAdress = null;
  bool showMap = false;

  @override
  Widget build(BuildContext context) {
    determinePosition();

    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          textInputAction: TextInputAction.search,
          keyboardType: TextInputType.streetAddress,
          onFieldSubmitted: (value) {
            searchLocation(value);
          },
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                searchLocation(searchValue);
              },
            ),
            hintStyle: kHintTextStyle,
            labelText: "Recherche",
          ),
          onChanged: (value) => {searchValue = value},
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            //showMap?
            GoogleMap(
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              mapToolbarEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: currentPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: markers,
              onTap: (cord) {
                selectedCords = Coordinates(cord.latitude, cord.longitude);
                setState(() {
                  selectedMarker = Marker(
                      markerId: new MarkerId("selected position"),
                      position: LatLng(cord.latitude, cord.longitude),
                      infoWindow: InfoWindow(title: "Selected Position"),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueAzure));
                  markers.removeWhere(
                      (element) => element.markerId == selectedMarker.markerId);
                  markers.add(selectedMarker);
                });
              },
            )
//                : JumpingDotsProgressIndicator(
//                    color: Colors.grey,
//                  ),
            ,
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 25.0, horizontal: 16),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FloatingActionButton(
                  onPressed: () async {
                    if (selectedCords != null)
                      selectedAdress = await Geocoder.local
                          .findAddressesFromCoordinates(selectedCords);
                    //shared.save("selectedLocationName", selectedAdress);
                    //shared.save("selectedLocationCord", selectedCords);
                    print("heree :" + selectedAdress.first.featureName);
                    Navigator.pop(context, selectedAdress);
                  },
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.save, size: 36.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<CameraPosition> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        new Coordinates(position.latitude, position.longitude));
    var first = addresses.first;
    if (mounted) {
      setState(() {
        currentPosition = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 16);

        markers.add(Marker(
            markerId: new MarkerId("current position"),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: InfoWindow(
                title: "Votre Position", snippet: first.featureName)));
        showMap = true;
      });
//      final GoogleMapController controller = await _controller.future;
//      controller.animateCamera(CameraUpdate.newCameraPosition(currentPosition));
    }

    return CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 16);
  }

  searchLocation(String value) async {
    var addresses = await Geocoder.local.findAddressesFromQuery(value);
    var first = addresses.first;

    searchPosition = CameraPosition(
        target: LatLng(first.coordinates.latitude, first.coordinates.longitude),
        zoom: 16);
    _goToSearch();
  }

  Future<void> _goToSearch() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(searchPosition));
  }
}
