import 'dart:async';

import 'package:nosh_now_application/data/models/order_detail.dart';

class ChangeStream{
  final StreamController<OrderDetail?> _controller = StreamController<OrderDetail?>.broadcast();

  // OrderDetail? detail;

  Stream<OrderDetail?> get stream => _controller.stream;

  // void initStream(OrderDetail? detail){

  // }

  void notifyDataChanged(OrderDetail? detail){
    _controller.add(detail);
  }
  void dispose(){
    _controller.close();
  }
}