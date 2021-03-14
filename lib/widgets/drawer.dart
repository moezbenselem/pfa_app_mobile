import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfa_app/Models/User.dart';
import 'package:pfa_app/Utils/SharedPref.dart';
import 'package:pfa_app/consts/constants.dart';
import 'package:pfa_app/screens/ajout_demande.dart';
import 'package:pfa_app/screens/login.dart';
import 'package:pfa_app/screens/mes_demandes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatelessWidget {
  User user;
  String userId, userEmail;
  bool userType;

  DrawerWidget(this.user) {}

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            verticalDirection: VerticalDirection.up,
            children: <Widget>[
              Text(
                this.user.nom.toString() + ' ' + this.user.prenom.toString(),
                style: kDrawerStyle,
              ),
              Text(
                user.description,
                style: kDrawerStyle,
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.red[900],
          ),
        ),
        if (user.type)
          ListTile(
            title: Text(
              'Crée une Demande',
              style: kDrawerItem,
            ),
            leading: Icon(Icons.create_new_folder_rounded),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AjoutDemandeScreen(this.user);
              }));
            },
          ),
        if (user.type)
          ListTile(
            title: Text(
              'Mes Demandes',
              style: kDrawerItem,
            ),
            leading: Icon(Icons.emoji_transportation),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MesDemandesScreen(this.user);
              }));
            },
          )
        else
          ListTile(
            title: Text(
              'Mes Offres',
              style: kDrawerItem,
            ),
            leading: Icon(Icons.request_page_rounded),
            onTap: () {},
          ),
        ListTile(
          title: Text(
            'Mes Commandes',
            style: kDrawerItem,
          ),
          leading: Icon(Icons.content_paste_rounded),
          onTap: () {},
        ),
        ListTile(
          title: Text(
            'Mon Compte',
            style: kDrawerItem,
          ),
          leading: Icon(Icons.account_circle),
          onTap: () {},
        ),
        ListTile(
          title: Text(
            'Logout',
            style: kDrawerItem,
          ),
          leading: Icon(Icons.logout),
          onTap: () async {
            SharedPref sharedPrefs = SharedPref();
            sharedPrefs.remove("user");
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return LoginScreen();
            }));
          },
        ),
      ],
    );
  }
}
