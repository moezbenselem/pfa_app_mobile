import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Demande {
  int id;
  String depart, destination, description, suivie;
  String date;
  bool etat;
  int userId;

  Demande(this.id, this.depart, this.destination, this.description, this.suivie,
      this.date, this.etat, this.userId);

  factory Demande.fromJson(Map<String, dynamic> demande) {
    return Demande(
        demande['id'],
        demande['depart'],
        demande['destination'],
        demande['description'],
        demande['suivie'],
        demande['date'],
        demande['etat'],
        demande['UserId']);
  }

  @override
  String toString() {
    return 'Demande{id: $id, depart: $depart, destination: $destination, description: $description, suivie: $suivie, date: $date, etat: $etat, userId: $userId}';
  }
}
