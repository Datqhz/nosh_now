import 'package:nosh_now_application/data/models/eater.dart';
import 'package:nosh_now_application/data/models/merchant.dart';
import 'package:nosh_now_application/data/models/order_status.dart';
import 'package:nosh_now_application/data/models/payment_method.dart';
import 'package:nosh_now_application/data/models/shipper.dart';

class Order {
  int orderId;
  DateTime? orderedDate;
  double? shipmentFee;
  double totalPay;
  String? coordinator;
  String? phone;
  OrderStatus orderStatus;
  Merchant merchant;
  Eater eater;
  Shipper? shipper;
  PaymentMethod? paymentMethod;
  Order(
      {required this.orderId,
      required this.totalPay,
      required this.orderStatus,
      required this.eater,
      required this.merchant,
      this.coordinator,
      this.orderedDate,
      this.paymentMethod,
      this.phone,
      this.shipmentFee,
      this.shipper});
  factory Order.fromJson(Map<dynamic, dynamic> json) {
    return Order(
        orderId: json['id'],
        totalPay: json['totalPay'],
        orderStatus: json['orderStatus'],
        eater: json['eater'],
        merchant: json['merchant'],
        coordinator: json['coordinator'],
        phone: json['phone'],
        orderedDate: DateTime.parse(json['orderedDate']),
        shipmentFee: json['shipmentFee'],
        paymentMethod: json['paymentMethod'] != null
            ? PaymentMethod.fromJson(json['paymentMethod'])
            : null,
        shipper:
            json['shipper'] != null ? Shipper.fromJson(json['shipper']) : null);
  }
}
