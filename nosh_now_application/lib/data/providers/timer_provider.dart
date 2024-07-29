
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:nosh_now_application/core/utils/map.dart';
import 'package:nosh_now_application/core/utils/notify.dart';

class TimerProvider extends ChangeNotifier {
  Timer? _timer;

  void startTimer(Duration duration, Function(LatLng) callback, int orderId, int eaterId, int merchantId) {
    _timer = Timer.periodic(duration, (timer) async {
      LatLng coord = await checkPermissions();
      await updateLocationForTracking(orderId, eaterId,  merchantId, coord);
      callback(coord);
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }
}