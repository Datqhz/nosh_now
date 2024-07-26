import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';
import 'package:nosh_now_application/data/models/order.dart';
import 'package:nosh_now_application/data/repositories/firebase_message_repository.dart';
import 'package:nosh_now_application/data/repositories/order_repository.dart';

Future<void> handleNotificationWhenChangeStatus(int orderId, int eaterId,
    int shipperId, int merchantId, int status, LatLng coord) async {
  await FirebaseMessageRepository().sendPushMessage('order-status',
      'Order is change status', "Your order is changed status to $status by shipper", {
    "orderId": orderId,
    "eaterId": eaterId,
    "merchant": merchantId,
    "shipper": shipperId,
    "status": status
  });
  await FirebaseMessageRepository().sendPushMessage(
      'tracking', 'Current shipper location', "Tracking shipper", {
    "orderId": orderId,
    "eaterId": eaterId,
    "merchant": merchantId,
    "shipperCoord": "${coord.latitude}-${coord.longitude}"
  });
}

Future<void> updateLocationForTracking(int orderId, int eaterId, 
    int merchantId, LatLng coord) async {
  await FirebaseMessageRepository().sendPushMessage(
      'tracking', 'Current shipper location', "Tracking shipper", {
    "orderId": orderId,
    "eaterId": eaterId,
    "merchant": merchantId,
    "shipperCoord": "${coord.latitude}-${coord.longitude}"
  });
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.notification != null) {
    if (message.notification!.title == 'Order is change status') {
      print("Your order is changed status ${message.data['status']} shipper has id is ${message.data['shipper']} ");
    }
  }
}
