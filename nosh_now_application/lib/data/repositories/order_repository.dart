import 'dart:convert';

import 'package:http/http.dart';
import 'package:nosh_now_application/core/constants/global_variable.dart';
import 'package:nosh_now_application/data/models/food.dart';
import 'package:nosh_now_application/data/models/order.dart';

class OrderRepository{
  Future<Order> getAllByMerchantAndEater(int merchantId, int eaterId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      print("${GlobalVariable.url}/api/order/merchant-eater?merchantId=$merchantId&eaterId=$eaterId");
      Response response =
          await get(Uri.parse("${GlobalVariable.url}/api/order/merchant-eater?merchantId=$merchantId&eaterId=$eaterId"),
              headers: headers);
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        throw Exception();
      }
      Map<String, dynamic> data = json.decode(response.body);
      return Order.fromJson(data);
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to get data');
    }
  }
}