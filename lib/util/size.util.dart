import 'package:flutter/material.dart';

class SizeUtil {
  // TODO(viviane): use
  static double getDoubleByDeviceVertical(double height, double num) {
    return num * (height / 752.0);
  }

  static double getDoubleByDeviceHorizontal(double width, double num) {
    return num * (width / 1280.0);
  }
}
