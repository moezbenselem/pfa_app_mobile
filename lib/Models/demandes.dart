import 'package:pfa_app/Models/demande.dart';

class Demandes {
  final List<Demande> listDemandes;

  Demandes({this.listDemandes});

  factory Demandes.fromJson(List<dynamic> demandes) {
    try {
      List<Demande> ldemandes = [];
      for (var i = 0; i < demandes.length; i++) {
        ldemandes.add(Demande.fromJson(demandes[i]));
      }
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
