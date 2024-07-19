import 'dart:async';

import 'package:nosh_now_application/data/models/order_detail.dart';

class ChangeStream{
  final StreamController _controller = StreamController.broadcast();
  Stream get stream => _controller.stream;
  
  void notifyChange(){
    _controller.add(null);
  }
  void dispose(){
    _controller.close();
  }
}