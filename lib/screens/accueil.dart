import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfa_app/Models/User.dart';
import 'package:pfa_app/Utils/SharedPref.dart';
import 'package:pfa_app/consts/constants.dart';
import 'package:pfa_app/widgets/drawer.dart';

class Accueil extends StatefulWidget {
  User user;

  SharedPref sharedPref = SharedPref();

  Accueil() {
    user = User.fromJson(sharedPref.read("user"));
  }

  Accueil.forUser(this.user) {}

  @override
  _AccueilState createState() => _AccueilState(user);
}

class _AccueilState extends State<Accueil> {
  User user;

  _AccueilState(this.user) {}

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "TransApp",
          style: kAppTitle,
        ),
      ),

      drawer: Drawer(
        child: DrawerWidget(this.user),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 3),
//            child: Row(
//              mainAxisSize: MainAxisSize.max,
//              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//              children: <Widget>[
//                Icon(
//                  Icons.emoji_transportation,
//                  color: Colors.red[800],
//                  size: kIconSize,
//                ),
//                Icon(
//                  Icons.info_outline,
//                  color: Colors.red[800],
//                  size: kIconSize,
//                ),
//                Icon(
//                  Icons.tv,
//                  color: Colors.red[800],
//                  size: kIconSize,
//                ),
//                Icon(
//                  Icons.favorite,
//                  color: Colors.red[800],
//                  size: kIconSize,
//                ),
//              ],
//            ),
          ),
        ],
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),*/ // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
