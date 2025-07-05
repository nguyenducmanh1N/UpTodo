import 'package:flutter/material.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/styles/app_text_styles.dart';

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
        Text(
          "Category color :",
          style: AppTextStyles.displayMedium.copyWith(
            color: AppColor.upToDoWhile,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: colors.map((color) {
              final isSelected = color == selectedColor;
              return GestureDetector(
                onTap: () => onColorSelected(color),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: isSelected ? Border.all(color: AppColor.upToDoBorder, width: 3) : null,
                  ),
                  child: CircleAvatar(
                    backgroundColor: color,
                    radius: 18,
                    child: isSelected ? const Icon(Icons.check, color: AppColor.upToDoWhile, size: 18) : null,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
