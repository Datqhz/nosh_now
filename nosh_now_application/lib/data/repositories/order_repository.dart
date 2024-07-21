import 'dart:convert';

import 'package:http/http.dart';
import 'package:nosh_now_application/core/constants/global_variable.dart';
import 'package:nosh_now_application/data/models/food.dart';
import 'package:nosh_now_application/data/models/order.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/prepare_order_screen.dart';

class OrderRepository {
  Future<Order> getAllByMerchantAndEater(int merchantId, int eaterId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
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

  Future<bool> update(Order order, {int shipperId = 0}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      print(
          "try send request - id: ${order.orderId} shipmenFee: ${order.shipmentFee} coordinator: ${order.coordinator} phone: ${order.phone} statusId: ${order.orderStatus.orderStatusId} shipperId: ${shipperId} methodId: ${order.paymentMethod!.methodId}");
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
      print('Send successful $statusCode body: ${response.body}');
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
