import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Demande {
  int id;
  String depart, destination, description, suivie;
  double latDepart, latDest, longDest, longDepart;
  String date;
  bool etat;
  int userId;
  List<String> bagages;
  int idPaiement;
  Demande(
      this.id,
      this.depart,
      this.destination,
      this.description,
      this.suivie,
      this.latDepart,
      this.latDest,
      this.longDest,
      this.longDepart,
      this.date,
      this.etat,
      this.userId);

  factory Demande.fromJson(Map<String, dynamic> demande) {
    return Demande(
        demande['id'],
        demande['depart'],
        demande['destination'],
        demande['description'],
        demande['suivie'],
        demande['departLat'],
        demande['destinationLat'],
        demande['destinationLong'],
        demande['departLong'],
        demande['date'],
        demande['etat'],
        demande['UserId']);
  }

  @override
  String toString() {
    return 'Demande{id: $id, depart: $depart, destination: $destination, description: $description, suivie: $suivie, date: $date, etat: $etat, userId: $userId}';
  }
}
