import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Offre {
  int id;
  String commentaire, etat, date;
  int prix;

  Offre(this.id, this.commentaire, this.etat, this.date, this.prix);

  factory Offre.fromJson(Map<String, dynamic> demande) {
    return Offre(demande['id'], demande['commentaire'], demande['etat'],
        demande['date'], demande['prix']);
  }
}
