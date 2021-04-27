import 'package:flutter/cupertino.dart';
import 'package:pfa_app/Models/User.dart';
import 'package:pfa_app/Utils/offres_recus_builder.dart';

class OffresRecusScreen extends StatefulWidget {
  User user;

  OffresRecusScreen(this.user);

  @override
  _OffresRecusScreenState createState() => _OffresRecusScreenState(this.user);
}

class _OffresRecusScreenState extends State<OffresRecusScreen> {
  User user;

  _OffresRecusScreenState(this.user);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: OffresRecusBuilder(
          user: user,
        )),
      ],
    );
  }
}
