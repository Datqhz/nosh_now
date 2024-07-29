import 'dart:convert';

import 'package:http/http.dart';
import 'package:nosh_now_application/core/constants/global_variable.dart';
import 'package:nosh_now_application/data/models/food.dart';

class FoodRepository {
  Future<List<Food>> getAllByMerchantAndIsSelling(int merchantId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response = await get(
          Uri.parse("${GlobalVariable.url}/api/food/sell/merchant/$merchantId"),
          headers: headers);
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        return [];
      }
      List<dynamic> data = json.decode(response.body);
      return data.map((e) => Food.fromJson(e)).toList();
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to get data');
    }
  }

  Future<List<Food>> getAllByMerchant(int merchantId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response = await get(
          Uri.parse("${GlobalVariable.url}/api/food/all/merchant/$merchantId"),
          headers: headers);
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        return [];
      }
      List<dynamic> data = json.decode(response.body);
      return data.map((e) => Food.fromJson(e)).toList();
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to get data');
    }
  }

  Future<Food?> create(Food food, int merchantId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response =
          await post(Uri.parse("${GlobalVariable.url}/api/food"),
              headers: headers,
              body: jsonEncode(<String, dynamic>{
                "foodName": food.foodName,
                "foodImage": food.foodImage,
                "foodDescribe": food.foodDescribe,
                "price": food.price,
                "status": food.status,
                "merchantId": merchantId
              }));
      int statusCode = response.statusCode;
      if (statusCode != 201) {
        print(response.body);
        return null;
      }
      return Food.fromJson(json.decode(response.body));
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to save food');
    }
  }

  Future<Food> update(Food food, int merchantId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response = await put(Uri.parse("${GlobalVariable.url}/api/food"),
          headers: headers,
          body: jsonEncode(<String, dynamic>{
            "id": food.foodId,
            "foodName": food.foodName,
            "foodImage": food.foodImage,
            "foodDescribe": food.foodDescribe,
            "price": food.price,
            "status": food.status,
          }));
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        print(response.body);
        throw Exception();
      }
      return Food.fromJson(json.decode(response.body));
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to save food');
    }
  }
  Future<bool> deleteFood(int id) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response = await delete(Uri.parse("${GlobalVariable.url}/api/food/$id"),
          headers: headers,);
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        print(response.body);
        return false;
      }
      return true;
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to delete food');
    }
  }
}
