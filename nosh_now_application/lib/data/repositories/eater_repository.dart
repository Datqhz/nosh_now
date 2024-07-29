import 'dart:convert';

import 'package:http/http.dart';
import 'package:nosh_now_application/core/constants/global_variable.dart';
import 'package:nosh_now_application/data/models/eater.dart';

class EaterRepository {
  Future<List<Eater>> getAllEater() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response = await get(
          Uri.parse("${GlobalVariable.url}/api/eater"),
          headers: headers);
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        return [];
      }
      List<dynamic> data = json.decode(response.body);
      return data.map((e) => Eater.fromJson(e)).toList();
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to get data');
    }
  }

  Future<Eater?> create(Eater eater, int accountId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response =
          await post(Uri.parse("${GlobalVariable.url}/api/eater"),
              headers: headers,
              body: jsonEncode(<String, dynamic>{
                "displayName": eater.displayName,
                "avatar": eater.avatar,
                "email": eater.email,
                "phone": eater.phone,
                "accountId": accountId
              }));
      int statusCode = response.statusCode;
      if (statusCode != 201) {
        return null;
      }
      Map<String, dynamic> data = json.decode(response.body);
      return Eater.fromJson(data);
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to register');
    }
  }

  Future<Eater?> update(Eater eater) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response =
          await put(Uri.parse("${GlobalVariable.url}/api/eater"),
              headers: headers,
              body: jsonEncode(<String, dynamic>{
                "id": eater.eaterId,
                "displayName": eater.displayName,
                "avatar": eater.avatar == '' ? '' : eater.avatar,
                "email": eater.email,
                "phone": eater.phone,
              }));
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        print('body ${response.body}');
        return null;
      }
      Map<String, dynamic> data = json.decode(response.body);
      return Eater.fromJson(data);
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to register');
    }
  }
}
