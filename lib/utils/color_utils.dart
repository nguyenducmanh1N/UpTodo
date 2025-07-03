import 'package:flutter/material.dart';

class ColorUtils {
  static final List<Color> categoryColors = [
    Color(0xFFEDE861), // Yellow
    Color(0xFF61ED7A), // Green
    Color(0xFF61EDE6), // Cyan
    Color(0xFF6195ED), // Light Blue
    Color(0xFF617AED), // Blue
    Color(0xFFEDB061), // Orange
    Color(0xFFB061ED), // Purple
    Color(0xFFED6195), // Pink
    Color(0xFFED6161), // Red
    Color(0xFF61ED9E), // Mint
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
