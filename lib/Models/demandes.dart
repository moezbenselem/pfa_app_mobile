import 'package:pfa_app/Models/demande.dart';

class Demandes {
  final List<Demande> listDemandes;

  Demandes({this.listDemandes});

  factory Demandes.fromJson(List<dynamic> demandes) {
    try {
      print("demandes in Demande class : " + demandes.toString());
      List<Demande> ldemandes = [];
      for (var i = 0; i < demandes.length; i++) {
        ldemandes.add(Demande.fromJson(demandes[i]));
      }
      print("demandes after for : " + ldemandes.toString());
      return Demandes(listDemandes: ldemandes);
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  String toString() {
    return 'Demandes{listDemandes: $listDemandes}';
  }
}
