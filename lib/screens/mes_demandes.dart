import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfa_app/Models/User.dart';
import 'package:pfa_app/Utils/demandes_builder.dart';

class MesDemandesScreen extends StatelessWidget {
  User user;

  MesDemandesScreen(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: DemandesBuilder(
      userId: user.id,
    ));
  }
}
