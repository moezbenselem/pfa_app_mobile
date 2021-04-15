import 'package:pfa_app/Models/offre.dart';

class Offres {
  final List<Offre> listOffres;

  Offres({this.listOffres});

  factory Offres.fromJson(List<dynamic> demandes) {
    try {
      List<Offre> loffres = [];
      for (var i = 0; i < demandes.length; i++) {
        loffres.add(Offre.fromJson(demandes[i]));
      }
      return Offres(listOffres: loffres);
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  String toString() {
    return 'Offres{listOffres: $listOffres}';
  }
}
