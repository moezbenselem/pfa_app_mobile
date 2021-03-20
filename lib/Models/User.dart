import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class User {
  int id;
  String email,
      nom,
      prenom,
      cin,
      code,
      adresse,
      tel,
      description,
      token,
      refresh_token;
  bool verified, type;

  User(
      this.id,
      this.email,
      this.nom,
      this.prenom,
      this.cin,
      this.code,
      this.adresse,
      this.tel,
      this.description,
      this.token,
      this.refresh_token,
      this.verified,
      this.type);

  factory User.fromJson(Map<String, dynamic> info) {
    return User(
        info['id'],
        info['email'],
        info['nom'],
        info['prenom'],
        info['cin'],
        info['code'],
        info['adresse'],
        info['tel'],
        info['description'],
        info['token'],
        info['refresh_token'],
        info['verified'],
        info['type']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'cin': cin,
        'code': code,
        'adresse': adresse,
        'tel': tel,
        'description': description,
        'token': token,
        'refresh_token': refresh_token,
        'verified': verified,
        'type': type,
      };
}
