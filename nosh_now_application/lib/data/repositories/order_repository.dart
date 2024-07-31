import 'dart:convert';

import 'package:http/http.dart';
import 'package:nosh_now_application/core/constants/global_variable.dart';
import 'package:nosh_now_application/data/models/order.dart';

//all role
class OrderRepository {
  Future<Order> getById(int orderId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer ${GlobalVariable.jwt}"
    };
    try {
      Response response = await get(
          Uri.parse("${GlobalVariable.url}/api/order/$orderId"),
          headers: headers);
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        throw Exception(response.body);
      }
      Map<String, dynamic> data = json.decode(response.body);
      return Order.fromJson(data);
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to get data');
    }
  }

  Future<Order> getByMerchantAndEater(int merchantId, int eaterId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer ${GlobalVariable.jwt}"
    };
    try {
      Response response = await get(
          Uri.parse(
              "${GlobalVariable.url}/api/order/merchant-eater?merchantId=$merchantId&eaterId=$eaterId"),
          headers: headers);
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        throw Exception(response.body);
      }
      Map<String, dynamic> data = json.decode(response.body);
      return Order.fromJson(data);
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to get data');
    }
  }

  Future<List<Order>> getByEater(int eaterId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer ${GlobalVariable.jwt}"
    };
    try {
      Response response = await get(
          Uri.parse("${GlobalVariable.url}/api/order/eater/$eaterId"),
          headers: headers);
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        throw Exception(response.body);
      }
      List<dynamic> data = json.decode(response.body);
      return data.map((e) => Order.fromJson(e)).toList();
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to get data');
    }
  }

  Future<List<Order>> getByMerchant(int merchantId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer ${GlobalVariable.jwt}"
    };
    try {
      Response response = await get(
          Uri.parse("${GlobalVariable.url}/api/order/merchant/$merchantId"),
          headers: headers);
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        throw Exception(response.body);
      }
      List<dynamic> data = json.decode(response.body);
      return data.map((e) => Order.fromJson(e)).toList();
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to get data');
    }
  }

  Future<List<Order>> getByShipper(int shipperId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer ${GlobalVariable.jwt}"
    };
    try {
      Response response = await get(
          Uri.parse("${GlobalVariable.url}/api/order/shipper/$shipperId"),
          headers: headers);
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        throw Exception(response.body);
      }
      List<dynamic> data = json.decode(response.body);
      return data.map((e) => Order.fromJson(e)).toList();
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to get data');
    }
  }

  Future<List<Order>> getAllNearBy(String coordinator) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer ${GlobalVariable.jwt}"
    };
    try {
      Response response = await get(
          Uri.parse(
              "${GlobalVariable.url}/api/order/near-by?coordinator=$coordinator"),
          headers: headers);
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        throw Exception();
      }
      List<dynamic> data = json.decode(response.body);
      return data.map((e) => Order.fromJson(e['order'])).toList();
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to get data');
    }
  }

  Future<bool> update(Order order, {int shipperId = 0}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer ${GlobalVariable.jwt}"
    };
    try {
      print("shipper id: $shipperId");
      Response response =
          await put(Uri.parse("${GlobalVariable.url}/api/order"),
              headers: headers,
              body: jsonEncode(<String, dynamic>{
                "id": order.orderId,
                "shipmentFee": order.shipmentFee,
                "coordinator": order.coordinator,
                "phone": order.phone,
                "statusId": order.orderStatus.orderStatusId,
                "shipperId": shipperId,
                "methodId": order.paymentMethod!.methodId
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
}
