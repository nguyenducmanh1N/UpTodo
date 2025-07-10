import 'package:flutter/material.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/styles/app_text_styles.dart';

enum Type { filter, status }

class TaskFilterDropdown extends StatelessWidget {
  final dynamic selectedValue;
  final ValueChanged<dynamic>? onChanged;
  final Type type;

  final List<dynamic>? items;
  final String? title;

  const TaskFilterDropdown({
    super.key,
    required this.selectedValue,
    this.onChanged,
    required this.type,
    this.items,
    this.title,
  });

  String _getLabel(dynamic item) {
    final String fullString = item.toString();
    final int dotIndex = fullString.indexOf('.');
    if (dotIndex != -1 && dotIndex < fullString.length - 1) {
      return fullString.substring(dotIndex + 1);
    }
    return fullString;
  }

  List<DropdownMenuItem<dynamic>>? _buildDropdownItems() {
    if (items == null) return null;
    return items!
        .map<DropdownMenuItem<dynamic>>(
          (item) => DropdownMenuItem<dynamic>(
            value: item,
            child: Text(
              _getLabel(item).toString(),
              style: AppTextStyles.displaySmall.copyWith(color: AppColor.upToDoWhite),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColor.upToDoBgSecondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<dynamic>(
          value: selectedValue,
          items: _buildDropdownItems(),
          onChanged: onChanged,
          dropdownColor: AppColor.upToDoBgSecondary,
          icon: Icon(Icons.keyboard_arrow_down, color: AppColor.upToDoWhite),
          style: AppTextStyles.displaySmall.copyWith(color: AppColor.upToDoWhite),
          hint: Text("", style: AppTextStyles.displaySmall.copyWith(color: AppColor.upToDoWhite)),
        ),
      ),
    );
  }
}
