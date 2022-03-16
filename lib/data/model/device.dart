import 'package:flutter/cupertino.dart';

class Device {
  static final _instane = Device._();

  factory Device() {
    return _instane;
  }

  late double width;
  late double height;

  void init(BuildContext context) {
    var size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
  }

  Device._() {}
}
