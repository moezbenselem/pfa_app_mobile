import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Demande {
  int id;
  String depart, destination, description;
  String date;
  int userId;

  Demande(this.id, this.depart, this.destination, this.description, this.date,
      this.userId);

  factory Demande.fromJson(Map<String, dynamic> demande) {
    return Demande(demande['id'], demande['depart'], demande['destination'],
        demande['description'], demande['date'], demande['UserId']);
  }

  @override
  String toString() {
    return 'Demande{id: $id, depart: $depart, destination: $destination, description: $description, date: $date, userId: $userId}';
  }
}
