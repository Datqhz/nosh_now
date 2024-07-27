import 'dart:convert';

import 'package:http/http.dart';
import 'package:nosh_now_application/core/constants/global_variable.dart';
import 'package:nosh_now_application/core/utils/shared_preference.dart';
import 'package:nosh_now_application/core/utils/snack_bar.dart';
import 'package:nosh_now_application/data/models/account.dart';
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
      print("success");
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['user']['account']['role']['roleName'] == 'Manager') {
        await storeCurrentUser(manager: Manager.fromJson(data['user']));
        GlobalVariable.user = Manager.fromJson(data['user']);
      } else if (data['user']['account']['role']['roleName'] == 'Eater') {
        await storeCurrentUser(eater: Eater.fromJson(data['user']));
        GlobalVariable.user = Eater.fromJson(data['user']);
      } else if (data['user']['account']['role']['roleName'] == 'Merchant') {
        await storeCurrentUser(merchant: Merchant.fromJson(data['user']));
        GlobalVariable.user = Merchant.fromJson(data['user']);
      } else {
        await storeCurrentUser(shipper: Shipper.fromJson(data['user']));
        GlobalVariable.user = Shipper.fromJson(data['user']);
      }
      var account = Account.fromJson(data['user']['account']);
      await storeAccount(account);
      await storeToken(data['token']);
      GlobalVariable.currentUid = data['user']['id'];
      GlobalVariable.roleName = data['user']['account']['role']['roleName'];
      GlobalVariable.roleId = data['user']['account']['role']['id'];
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
}
