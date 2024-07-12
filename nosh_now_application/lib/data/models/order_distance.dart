import 'package:nosh_now_application/data/models/order.dart';

class OrderDistance{
  Order order;
  double distance;
  OrderDistance({required this.order, required this.distance});
  factory OrderDistance.fromJson(Map<dynamic, dynamic> json){
    return OrderDistance(order: Order.fromJson(json['order']), distance: json['distance']);
  }
}