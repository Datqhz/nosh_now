import 'dart:convert';

import 'package:http/http.dart';
import 'package:nosh_now_application/core/constants/global_variable.dart';
import 'package:nosh_now_application/data/models/eater.dart';

class EaterRepository {
  Future<bool> create(Eater eater, int accountId) async {
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
        return false;
      }
      return true;
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to register');
    }
  }
}
