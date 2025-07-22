import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptodo/providers/auth_provider.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/styles/app_text_styles.dart';
import 'package:uptodo/utils/task_utils/sort_task_utils.dart';

class Header extends StatefulWidget {
  final Function(TaskSortType type, SortOrder sortOrder)? onSortSelected;
  const Header({super.key, this.onSortSelected});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  String _getSortOrderLabel(TaskSortType type, SortOrder sortOrder) {
    switch (type) {
      case TaskSortType.name:
        return sortOrder == SortOrder.ascending ? 'A → Z' : 'Z → A';
      case TaskSortType.date:
        return sortOrder == SortOrder.ascending ? 'Oldest' : 'Newest';
      case TaskSortType.priority:
        return sortOrder == SortOrder.ascending ? 'Low → High' : 'High → Low';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PopupMenuButton<TaskSortType>(
            icon: Image.asset('assets/images/sort_icon.png'),
            color: AppColor.upToDoBlack,
            itemBuilder: (context) => TaskSortType.values.map((type) {
              return PopupMenuItem<TaskSortType>(
                value: type,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      type.toString().split('.').last,
                      style: AppTextStyles.displaySmall.copyWith(
                        color: AppColor.upToDoWhite,
                      ),
                    ),
                    PopupMenuButton<SortOrder>(
                      color: AppColor.upToDoBlack,
                      icon: const Icon(
                        Icons.arrow_right,
                        color: AppColor.upToDoWhite,
                      ),
                      onSelected: (status) {
                        widget.onSortSelected!(type, status);
                      },
                      itemBuilder: (context) => SortOrder.values.map((sortOrder) {
                        return PopupMenuItem<SortOrder>(
                          value: sortOrder,
                          child: Text(
                            _getSortOrderLabel(type, sortOrder),
                            style: AppTextStyles.displaySmall.copyWith(
                              color: AppColor.upToDoWhite,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          Text(
            'UpToDo',
            style: AppTextStyles.displaySmall.copyWith(
              color: AppColor.upToDoWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(Icons.logout, color: AppColor.upToDoWhite),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
