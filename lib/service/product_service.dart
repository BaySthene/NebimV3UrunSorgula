import 'package:flutter/material.dart';

class ProductServiceIp with ChangeNotifier {
  var _ipAddress = "89.252.188.10:61500";

  String get getIpAddress {
    return _ipAddress ;
  }

  void toggleIp(){
    notifyListeners();
  }


}