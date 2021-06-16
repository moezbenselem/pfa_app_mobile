import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pfa_app/Utils/api_config.dart';
import 'package:pfa_app/consts/const_strings.dart';

fetchDemandeDetails(token, id) async {
  http.Response response;
  response = await http.get(
    Uri.http(apiBaseUrl, 'demande/' + id),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    try {
      var d = jsonDecode(response.body);
      print(d);
      return d;
    } catch (Exception) {
      Exception.toString();
    }
  } else {
    print("cant load demandes !");
  }
}

fetchUserInfo(token, id) async {
  http.Response response;
  response = await http.get(
    Uri.http(apiBaseUrl, 'auth/info/' + id),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
  );
  print(response.request);
  if (response.statusCode == 200) {
    try {
      Map body = json.decode(response.body);
      print(body['data']);
      return body['data'];
    } catch (Exception) {
      print(Exception);
    }
  } else {
    print("cant load user info !");
  }
}
