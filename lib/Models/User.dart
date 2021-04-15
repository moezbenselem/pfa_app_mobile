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
      code_entreprise,
      type,
      role,
      refresh_token;
  bool verified;

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
      this.code_entreprise,
      this.type,
      this.role,
      this.verified);

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
      info['code_entreprise'],
      info['type'],
      info['role'],
      info['verified'],
    );
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
        'refresh_token': refresh_token,
        'type': type,
        'role': role,
        'verified': verified,
      };

  @override
  String toString() {
    return 'User{id: $id, email: $email, nom: $nom, prenom: $prenom, cin: $cin, code: $code, adresse: $adresse, tel: $tel, description: $description, token: $token, code_entreprise: $code_entreprise, type: $type, role: $role, refresh_token: $refresh_token, verified: $verified}';
  }
}
