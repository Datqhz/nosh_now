import 'dart:convert';

import 'package:http/http.dart';
import 'package:nosh_now_application/core/constants/global_variable.dart';
import 'package:nosh_now_application/data/models/order_detail.dart';

class OrderDetailRepository {
  Future<List<OrderDetail>> getAllByOrderId(int orderId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      print("${GlobalVariable.url}/api/order-detail/order/$orderId");
      Response response = await get(
          Uri.parse("${GlobalVariable.url}/api/order-detail/order/$orderId"),
          headers: headers);
      int statusCode = response.statusCode;
      print(response.body);
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

  Future<OrderDetail?> create(OrderDetail orderDetail) async {
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
        return null;
      }
      Map<String, dynamic> data = json.decode(response.body);
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

  Future<bool> updateMultiple(List<OrderDetail> orderDetails) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response = await put(
          Uri.parse("${GlobalVariable.url}/api/order-detail/multiple"),
          headers: headers,
          body: jsonEncode(orderDetails
              .map((detail) => {
                    'id': detail.odId,
                    'quantity': detail.quantity,
                    'price': detail.price,
                  })
              .toList()));
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
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };
      Response response = await delete(
          Uri.parse("${GlobalVariable.url}/api/order-detail/$id"),
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
