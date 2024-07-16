import 'package:flutter/material.dart';
import 'package:nosh_now_application/data/models/account.dart';

class UserLogin with ChangeNotifier {
  bool _isLogin = false;

  get isLogin => _isLogin;

  void login(){
    _isLogin = true;
    notifyListeners();
  }
  void logout(){
    _isLogin = false;
    notifyListeners();
  }
}
