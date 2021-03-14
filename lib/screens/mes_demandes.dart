import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfa_app/Models/User.dart';
import 'package:pfa_app/Utils/demandes_builder.dart';
import 'package:pfa_app/consts/constants.dart';
import 'package:pfa_app/widgets/drawer.dart';

class MesDemandesScreen extends StatelessWidget {
  User user;

  MesDemandesScreen(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mes Demandes",
          style: kAppTitle,
        ),
      ),
      drawer: Drawer(
        child: DrawerWidget(this.user),
      ),
      body: Container(
          child: DemandesBuilder(
        userId: user.id,
      )),
    );
  }
}
