import 'dart:convert';

import 'package:http/http.dart';
import 'package:nosh_now_application/core/constants/global_variable.dart';
import 'package:nosh_now_application/data/models/category.dart';
import 'package:nosh_now_application/data/models/category.dart';

class CategoryRepository {
  Future<FoodCategory?> create(FoodCategory category) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response = await post(
          Uri.parse("${GlobalVariable.url}/api/category"),
          headers: headers,
          body: jsonEncode(<String, dynamic>{
            "categoryName": category.categoryName,
            "image": category.categoryImage
          }));
      int statusCode = response.statusCode;
      if (statusCode != 201) {
        return null;
      }
      Map<String, dynamic> data = json.decode(response.body);
      return FoodCategory.fromJson(data);
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to save');
    }
  }

  Future<bool> update(FoodCategory category) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response =
          await put(Uri.parse("${GlobalVariable.url}/api/category"),
              headers: headers,
              body: jsonEncode(<String, dynamic>{
                "id": category.categoryId,
                "categoryName": category.categoryName,
                "image": category.categoryImage
              }));
      int statusCode = response.statusCode;
      print("body: ${response.body}");
      if (statusCode != 200) {
        return false;
      }
      return true;
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to save');
    }
  }
  Future<bool> deleteCategory(int id) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response =
          await delete(Uri.parse("${GlobalVariable.url}/api/category/$id"),
              headers: headers,
              );
      int statusCode = response.statusCode;
      print("body: ${response.body}");
      if (statusCode != 200) {
        return false;
      }
      return true;
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to delete');
    }
  }

  Future<List<FoodCategory>> getAll() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response = await get(
          Uri.parse("${GlobalVariable.url}/api/category"),
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
