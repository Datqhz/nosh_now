import 'dart:convert';

import 'package:http/http.dart';
import 'package:nosh_now_application/core/constants/global_variable.dart';
import 'package:nosh_now_application/data/models/payment_method.dart';

class PaymentMethodRepository{
   Future<List<PaymentMethod>> getAll() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer ${GlobalVariable.jwt}"
    };
    try {
      Response response =
          await get(Uri.parse("${GlobalVariable.url}/api/payment-method"),
              headers: headers);
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        return [];
      }
      List<dynamic> data = json.decode(response.body);
      return data.map((e) => PaymentMethod.fromJson(e)).toList();
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to get data');
    }
  }
}