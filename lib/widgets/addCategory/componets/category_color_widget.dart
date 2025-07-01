// Widget chọn màu category
import 'dart:ui';

import 'package:flutter/material.dart';

class CategoryColorPicker extends StatelessWidget {
  final List<Color> colors;
  final Color? selectedColor;
  final ValueChanged<Color> onColorSelected;

  const CategoryColorPicker({
    super.key,
    required this.colors,
    required this.onColorSelected,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Category color :",
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Row(
          children: colors.map((color) {
            final isSelected = color == selectedColor;
            return GestureDetector(
              onTap: () => onColorSelected(color),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
                ),
                child: CircleAvatar(
                  backgroundColor: color,
                  radius: 18,
                  child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
