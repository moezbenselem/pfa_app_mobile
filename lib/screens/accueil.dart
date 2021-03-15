import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfa_app/Models/User.dart';
import 'package:pfa_app/Utils/SharedPref.dart';
import 'package:pfa_app/consts/constants.dart';
import 'package:pfa_app/screens/ajout_demande.dart';
import 'package:pfa_app/screens/login.dart';
import 'package:pfa_app/screens/mes_demandes.dart';
import 'package:pfa_app/screens/profile.dart';

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}

class Accueil extends StatefulWidget {
  User user;
  SharedPref sharedPref = SharedPref();

  final drawerItems = [
    new DrawerItem("Crée une Demande", Icons.create_new_folder_rounded),
    new DrawerItem("Crée une Offre", Icons.create_new_folder_rounded),
    new DrawerItem("Mes Demandes", Icons.emoji_transportation),
    new DrawerItem("Mes Offres", Icons.emoji_transportation),
    new DrawerItem("Mes Commandes", Icons.content_paste_rounded),
    new DrawerItem("Mon Compte", Icons.account_circle),
    new DrawerItem("Déconnecter", Icons.logout)
  ];

  Accueil() {
    user = User.fromJson(sharedPref.read("user"));
  }

  Accueil.forUser(this.user) {}

  @override
  _AccueilState createState() => _AccueilState(user);
}

class _AccueilState extends State<Accueil> {
  User user;
  String title = "TranspApp";
  int selectedNav = 0;

  _AccueilState(this.user) {}

  Widget getFragment(int index) {
    switch (index) {
      case 0:
        return AjoutDemandeScreen(user);
        break;
      case 2:
        return MesDemandesScreen(user);
        break;
      case 5:
        return ProfilePage(user);
        break;
    }
  }

  _onSelectItem(int index) {
    try {
      if (index == 6) {
        SharedPref sharedPrefs = SharedPref();
        sharedPrefs.remove("user");
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return LoginScreen();
        }));
      } else {
        setState(() => selectedNav = index);
        Navigator.of(context).pop();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    List<Widget> drawerOptions = [];

    if (user.type) {
      var d = widget.drawerItems[0];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(
          d.title,
          style: kDrawerItem,
        ),
        selected: 0 == selectedNav,
        onTap: () => _onSelectItem(0),
      ));

      d = widget.drawerItems[2];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(
          d.title,
          style: kDrawerItem,
        ),
        selected: 2 == selectedNav,
        onTap: () => _onSelectItem(2),
      ));
    } else {
      var d = widget.drawerItems[1];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(
          d.title,
          style: kDrawerItem,
        ),
        selected: 1 == selectedNav,
        onTap: () => _onSelectItem(1),
      ));

      d = widget.drawerItems[3];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(
          d.title,
          style: kDrawerItem,
        ),
        selected: 3 == selectedNav,
        onTap: () => _onSelectItem(3),
      ));
    }

    for (var i = 4; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(
          d.title,
          style: kDrawerItem,
        ),
        selected: i == selectedNav,
        onTap: () => _onSelectItem(i),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.drawerItems[selectedNav].title,
          style: kAppTitle,
        ),
        actions: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Icon(Icons.notifications))
        ],
      ),
      drawer: Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: Text(
                this.user.nom.toString() + ' ' + this.user.prenom.toString(),
                style: kDrawerStyle,
              ),
              accountEmail: Text(
                user.description,
                style: kDrawerStyle,
              ),
              currentAccountPicture: new CircleAvatar(
                backgroundImage:
                    new AssetImage("assets/images/male_avatar.png"),
              ),
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image: new AssetImage("assets/images/bgRed.jpg"),
                      fit: BoxFit.cover)),
            ),
            new Column(children: drawerOptions)
          ],
        ),
      ),
      body: getFragment(selectedNav),
    );
  }
}
