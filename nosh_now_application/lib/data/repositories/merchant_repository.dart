import 'dart:convert';

import 'package:http/http.dart';
import 'package:nosh_now_application/core/constants/global_variable.dart';
import 'package:nosh_now_application/data/models/merchant.dart';
import 'package:nosh_now_application/data/models/merchant_with_distance.dart';

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

  Future<List<MerchantWithDistance>> getAllMerchantNearby(
      String coordinator) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response = await get(
          Uri.parse(
              "${GlobalVariable.url}/api/merchant/near-by?coordinator=$coordinator"),
          headers: headers);
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        return [];
      }
      List<dynamic> data = json.decode(response.body);
      return data.map((e) => MerchantWithDistance.fromJson(e)).toList();
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to get data');
    }
  }

  Future<List<MerchantWithDistance>> getAllMerchantByCategory(
      int cateogryId, String coord) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response = await get(
          Uri.parse(
              "${GlobalVariable.url}/api/merchant/category?categoryId=$cateogryId&coordinator=$coord"),
          headers: headers);
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        return [];
      }
      List<dynamic> data = json.decode(response.body);
      return data.map((e) => MerchantWithDistance.fromJson(e)).toList();
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to get data');
    }
  }

  Future<List<Merchant>> getAllMerchant() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response = await get(
          Uri.parse("${GlobalVariable.url}/api/merchant"),
          headers: headers);
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        return [];
      }
      List<dynamic> data = json.decode(response.body);
      return data.map((e) => Merchant.fromJson(e)).toList();
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to get data');
    }
  }

  Future<List<MerchantWithDistance>> FindByRegex(
      String regex, String coord) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response = await get(
          Uri.parse(
              "${GlobalVariable.url}/api/merchant/find?regex=$regex&coordinator=$coord"),
          headers: headers);
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        return [];
      }
      List<dynamic> data = json.decode(response.body);
      return data.map((e) => MerchantWithDistance.fromJson(e)).toList();
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to get data');
    }
  }

  Future<List<MerchantWithDistance>> getMerchantById(String coordinator) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response = await get(
          Uri.parse(
              "${GlobalVariable.url}/api/merchant/near-by?coordinator=$coordinator"),
          headers: headers);
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        return [];
      }
      List<dynamic> data = json.decode(response.body);
      return data.map((e) => MerchantWithDistance.fromJson(e)).toList();
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to get data');
    }
  }
}
