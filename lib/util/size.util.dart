import 'package:flutter/material.dart';

class SizeUtil {
  static double width = 0;
  static double height = 0;

  // TODO(viviane): use
  static double getDoubleByDeviceVertical(double num) {
    return num * (height / 752.0);
  }

  static double getDoubleByDeviceHorizontal(double num) {
    return num * (width / 1280.0);
  }
}
