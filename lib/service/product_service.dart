import 'package:flutter/material.dart';

class ProductServiceIp with ChangeNotifier {
  var _ipAddress = "89.252.188.10:2207";

  String get getIpAddress {
    return _ipAddress ;
  }

  void toggleIp(){
    notifyListeners();
  }


}