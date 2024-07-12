import 'package:nosh_now_application/data/models/eater.dart';

class OrderStatus {
  int orderStatusId;
  String orderStatusName;
  int step;
  OrderStatus(
      {required this.orderStatusId,
      required this.orderStatusName,
      required this.step});
  factory OrderStatus.fromJson(Map<String, dynamic> json) {
    return OrderStatus(
        orderStatusId: json['id'],
        orderStatusName: json['orderStatusName'],
        step: json['step']);
  }
}

