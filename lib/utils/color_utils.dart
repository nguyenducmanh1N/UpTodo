import 'package:flutter/material.dart';

class ColorUtils {
  static final List<Color> categoryColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
    Colors.cyan,
    Colors.lime,
    Colors.indigo,
    Colors.amber,
  ];

  static Color getColorFromIndex(int index) {
    if (index >= 0 && index < categoryColors.length) {
      return categoryColors[index];
    }
    return Colors.grey;
  }

  static int getIndexFromColor(Color color) {
    for (int i = 0; i < categoryColors.length; i++) {
      if (categoryColors[i].value == color.value) {
        return i;
      }
    }
    return 0;
  }
}
