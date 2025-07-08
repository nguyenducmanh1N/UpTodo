import 'package:flutter/material.dart';
import 'package:uptodo/styles/app_color.dart';

class ColorUtils {
  static final List<Map<String, dynamic>> categoryColors = [
    {'key': 'yellow', 'color': AppColor.yellow},
    {'key': 'green', 'color': AppColor.green},
    {'key': 'cyan', 'color': AppColor.cyan},
    {'key': 'lightBlue', 'color': AppColor.lightBlue},
    {'key': 'blue', 'color': AppColor.blue},
    {'key': 'orange', 'color': AppColor.orange},
    {'key': 'purple', 'color': AppColor.purple},
    {'key': 'pink', 'color': AppColor.pink},
    {'key': 'red', 'color': AppColor.red},
    {'key': 'mint', 'color': AppColor.mint},
  ];

  static Color getColorFromKey(String key) {
    final found = categoryColors.firstWhere(
      (element) => element['key'] == key,
      orElse: () => categoryColors[0],
    );
    return found['color'];
  }

  static String getKeyFromColor(Color color) {
    final found = categoryColors.firstWhere(
      (element) => element['color'].value == color.value,
      orElse: () => categoryColors[0],
    );
    return found['key'];
  }
}
