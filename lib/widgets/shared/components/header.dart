import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptodo/providers/auth_provider.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/styles/app_text_styles.dart';
import 'package:uptodo/utils/task_utils/sort_task_utils.dart';

class Header extends StatefulWidget {
  final Function(TaskSortType type, SortStatus status)? onSortSelected;
  const Header({super.key, this.onSortSelected});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
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
                        color: Colors.white,
                      ),
                    ),
                    PopupMenuButton<SortStatus>(
                      color: AppColor.upToDoBlack,
                      icon: const Icon(
                        Icons.arrow_right,
                        color: Colors.white,
                      ),
                      onSelected: (status) {
                        widget.onSortSelected!(type, status);
                      },
                      itemBuilder: (context) => SortStatus.values.map((status) {
                        return PopupMenuItem<SortStatus>(
                          value: status,
                          child: Text(
                            status.toString().split('.').last,
                            style: AppTextStyles.displaySmall.copyWith(
                              color: Colors.white,
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
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(Icons.logout, color: AppColor.upToDoWhile),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
