import 'package:flutter/foundation.dart';
import 'package:nosh_now_application/data/models/order_detail.dart';

class OrderDetailNotifier with ChangeNotifier{
  OrderDetail? _detail;
  OrderDetail? get detail => _detail;
  int get quantity => _detail?.quantity ?? 0;

  
  void change(OrderDetail? detail){
    _detail = detail;
    notifyListeners();
  }
  void init(OrderDetail? detail){
    _detail = detail;
  }
}