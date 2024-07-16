import 'dart:convert';

import 'package:http/http.dart';
import 'package:nosh_now_application/core/constants/global_variable.dart';
import 'package:nosh_now_application/data/models/merchant.dart';

class MerchantRepository {
  Future<bool> create(Merchant merchant, int accountId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response =
          await post(Uri.parse("${GlobalVariable.url}/api/merchant"),
              headers: headers,
              body: jsonEncode(<String, dynamic>{
                "displayName": merchant.displayName,
                "avatar": merchant.avatar,
                "email": merchant.email,
                "phone": merchant.phone,
                "openingTime": merchant.openingTime,
                "closingTime": merchant.closingTime,
                "coordinator": merchant.coordinator,
                "accountId": accountId,
                "categoryId": merchant.category!.categoryId
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
