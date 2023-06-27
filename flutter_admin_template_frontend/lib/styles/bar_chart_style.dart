import 'package:flutter/material.dart';

class BarChartStyle {
  static const Color chartColor1 = Color.fromARGB(255, 15, 84, 188);
  static const Color chartColor2 = Color.fromARGB(255, 188, 84, 15);
  static const Color chartColor3 = Color.fromARGB(255, 15, 188, 84);

  static const Color textColor = Color.fromARGB(255, 15, 15, 15);

  static Color getIndex(int id) {
    switch (id) {
      case 1:
        return chartColor1;
      case 2:
        return chartColor2;
      case 3:
        return chartColor3;
      default:
        return chartColor1;
    }
  }
}
