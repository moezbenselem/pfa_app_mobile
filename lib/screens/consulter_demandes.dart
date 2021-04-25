import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfa_app/Models/User.dart';
import 'package:pfa_app/Utils/demandes_builder.dart';

class ConsulterDemandes extends StatefulWidget {
  User user;
  String filtre = 'all';

  ConsulterDemandes(this.user);

  @override
  _ConsulterDemandesState createState() => _ConsulterDemandesState(this.user);
}

class _ConsulterDemandesState extends State<ConsulterDemandes> {
  User user;
  String filtre = 'all';

  @override
  Widget build(BuildContext context) {
    double myWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: DemandesBuilder(
          user: user,
          filtre: "En Cours",
        )),
      ],
    );
  }

  _ConsulterDemandesState(this.user);
}
