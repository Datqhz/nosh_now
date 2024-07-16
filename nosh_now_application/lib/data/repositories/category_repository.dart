import 'dart:convert';

import 'package:http/http.dart';
import 'package:nosh_now_application/core/constants/global_variable.dart';
import 'package:nosh_now_application/data/models/category.dart';
import 'package:nosh_now_application/data/models/category.dart';

class CategoryRepository {
  // Future<bool> create(FoodCategory category, int accountId) async {
  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json; charset=UTF-8',
  //   };
  //   try {
  //     Response response =
  //         await post(Uri.parse("${GlobalVariable.url}/api/category"),
  //             headers: headers,
  //             body: jsonEncode(<String, dynamic>{
  //               "displayName": category.displayName,
  //               "avatar": category.avatar,
  //             }));
  //     int statusCode = response.statusCode;
  //     if (statusCode != 201) {
  //       return false;
  //     }
  //     return true;
  //   } catch (e) {
  //     print(e.toString());
  //     throw Exception('Fail to register');
  //   }
  // }

  Future<List<FoodCategory>> getAll() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response =
          await get(Uri.parse("${GlobalVariable.url}/api/category"),
              headers: headers);
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        return [];
      }
      List<dynamic> data = json.decode(response.body);
      return data.map((e) => FoodCategory.fromJson(e)).toList();
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to get data');
    }
  }
}
