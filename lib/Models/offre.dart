import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Offre {
  int id, demandeId, userId;
  String commentaire, etat, date;
  int prix;

  Offre(this.id, this.demandeId, this.userId, this.commentaire, this.etat,
      this.date, this.prix);

  factory Offre.fromJson(Map<String, dynamic> demande) {
    return Offre(
        demande['id'],
        demande['demandeId'],
        demande['userId'],
        demande['commentaire'],
        demande['etat'],
        demande['date'],
        demande['prix']);
  }
}
