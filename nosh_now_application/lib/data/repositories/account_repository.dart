import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nosh_now_application/core/constants/global_variable.dart';
import 'package:nosh_now_application/data/models/eater.dart';
import 'package:nosh_now_application/data/models/manager.dart';
import 'package:nosh_now_application/data/models/merchant.dart';
import 'package:nosh_now_application/data/models/shipper.dart';

class AccountRepository {
  Future<bool> signIn(String email, String password) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response =
          await post(Uri.parse("${GlobalVariable.url}/api/account/login"),
              headers: headers,
              body: jsonEncode(<String, dynamic>{
                "email": email,
                "password": password,
              }));
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        return false;
      }
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['user']['account']['role']['roleName'] == 'Manager') {
        GlobalVariable.user = Manager.fromJson(data['user']);
      } else if (data['user']['account']['role']['roleName'] == 'Eater') {
        GlobalVariable.user = Eater.fromJson(data['user']);
      } else if (data['user']['account']['role']['roleName'] == 'Merchant') {
        GlobalVariable.user = Merchant.fromJson(data['user']);
      } else {
        GlobalVariable.user = Shipper.fromJson(data['user']);
      }
      GlobalVariable.currentUid = data['user']['id'];
      GlobalVariable.roleName = data['user']['account']['role']['roleName'];
      GlobalVariable.roleId = data['user']['account']['role']['id'];
      GlobalVariable.jwt = data['token'];
      return true;
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to login');
    }
  }

  Future<int> signUp(String email, String password, int roleId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response =
          await post(Uri.parse("${GlobalVariable.url}/api/account"),
              headers: headers,
              body: jsonEncode(<String, dynamic>{
                "email": email,
                "password": password,
                "roleId": roleId,
              }));
      int statusCode = response.statusCode;
      if (statusCode != 201) {
        return 0;
      }
      Map<String, dynamic> data = json.decode(response.body);
      return data['id'];
    } catch (e) {
      throw Exception('Fail to register');
    }
  }

  Future<bool> changePassword(int accountId, String oldPass, String newPass,
      BuildContext context) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response = await put(
          Uri.parse("${GlobalVariable.url}/api/account"),
          headers: headers,
          body: jsonEncode(<String, dynamic>{
            "id": accountId,
            "oldPassword": oldPass,
            "newPassword": newPass
          }));
      int statusCode = response.statusCode;
      print(response.body);
      if (statusCode != 200) {
        return false;
      }
      return true;
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to register');
    }
  }
}
