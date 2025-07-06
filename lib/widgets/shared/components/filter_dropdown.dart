import 'package:flutter/material.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/styles/app_text_styles.dart';
import 'package:uptodo/utils/task_filter_utils.dart';
import 'package:uptodo/utils/task_sort_utils.dart';
import 'package:uptodo/utils/task_filter_by_status_utils.dart';

enum Type {
  filter,
  sort,
  status,
}

class TaskFilterDropdown extends StatefulWidget {
  final dynamic selectedValue;
  final Function(dynamic) onChanged;
  final Type type;

  const TaskFilterDropdown({
    super.key,
    required this.selectedValue,
    required this.onChanged,
    required this.type,
  });

  @override
  State<TaskFilterDropdown> createState() => _TaskFilterDropdownState();
}

class _TaskFilterDropdownState extends State<TaskFilterDropdown> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColor.upToDoBgSecondary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColor.upToDoPrimary.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: DropdownButton<dynamic>(
                value: widget.selectedValue,
                items: _buildDropdownItems(),
                onChanged: (value) {
                  widget.onChanged(value);
                },
                dropdownColor: AppColor.upToDoBgSecondary,
                hint: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.filter_list, color: AppColor.upToDoWhile, size: 16),
                    SizedBox(width: 8),
                    Text(
                      widget.type == Type.filter
                          ? 'Filter'
                          : widget.type == Type.sort
                              ? 'Sort'
                              : 'Status',
                      style: AppTextStyles.displaySmall.copyWith(color: AppColor.upToDoWhile),
                    ),
                  ],
                ),
                underline: SizedBox.shrink(),
                icon: Icon(Icons.arrow_drop_down, color: AppColor.upToDoWhile),
                style: AppTextStyles.displaySmall.copyWith(color: AppColor.upToDoWhile),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<DropdownMenuItem<dynamic>> _buildDropdownItems() {
    if (widget.type == Type.sort) {
      return [
        _buildDropdownMenuItem(TaskSortType.date, 'Date'),
        _buildDropdownMenuItem(TaskSortType.priority, 'Priority'),
        _buildDropdownMenuItem(TaskSortType.name, 'Title'),
      ];
    }
    if (widget.type == Type.status) {
      return [
        _buildDropdownMenuItem(TaskStatus.completed, 'Completed'),
        _buildDropdownMenuItem(TaskStatus.notCompleted, 'NotCompleted'),
      ];
    }
    return [
      _buildDropdownMenuItem(TaskFilter.all, 'All'),
      _buildDropdownMenuItem(TaskFilter.today, 'Today'),
      _buildDropdownMenuItem(TaskFilter.tomorrow, 'Tomorrow'),
    ];
  }
}

DropdownMenuItem<dynamic> _buildDropdownMenuItem(
  dynamic value,
  String label,
) {
  return DropdownMenuItem<dynamic>(
    value: value,
    child: Text(
      label,
      style: AppTextStyles.displaySmall.copyWith(color: AppColor.upToDoWhile),
    ),
  );
}
