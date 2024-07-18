import 'dart:convert';

import 'package:http/http.dart';
import 'package:nosh_now_application/core/constants/global_variable.dart';
import 'package:nosh_now_application/data/models/food.dart';
import 'package:nosh_now_application/data/models/order.dart';
import 'package:nosh_now_application/data/models/order_detail.dart';

class OrderDetailRepository {
  Future<List<OrderDetail>> getAllByOrderId(int orderId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response = await get(
          Uri.parse("${GlobalVariable.url}/api/order-detail/order/$orderId"),
          headers: headers);
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        throw Exception();
      }
      List<dynamic> data = json.decode(response.body);
      return data.map((e) => OrderDetail.fromJson(e)).toList();
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to get data');
    }
  }

  Future<OrderDetail> create(OrderDetail orderDetail) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response =
          await post(Uri.parse("${GlobalVariable.url}/api/order-detail"),
              headers: headers,
              body: jsonEncode(<String, dynamic>{
                "foodId": orderDetail.food.foodId,
                "orderId": orderDetail.orderId,
                "quantity": orderDetail.quantity,
                "price": orderDetail.price,
              }));
      int statusCode = response.statusCode;
      if (statusCode != 201) {
        throw Exception();
      }
      Map<String,dynamic> data = json.decode(response.body);
      return OrderDetail.fromJson(data);
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to save data');
    }
  }

  Future<bool> update(OrderDetail orderDetail) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response =
          await put(Uri.parse("${GlobalVariable.url}/api/order-detail"),
              headers: headers,
              body: jsonEncode(<String, dynamic>{
                "id": orderDetail.odId,
                "quantity": orderDetail.quantity,
                "price": orderDetail.price,
              }));
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        return false;
      }
      return true;
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to save data');
    }
  }

  Future<bool> deleteDetail(int id) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    Response response = await delete(
        Uri.parse("${GlobalVariable.url}/api/study-set/$id"),
        headers: headers);
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        return false;
      }
      return true;
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to delete data');
    }
  }
}
