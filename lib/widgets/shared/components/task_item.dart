import 'package:flutter/material.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/styles/app_text_styles.dart';
import 'package:uptodo/utils/color_utils.dart';
import 'package:uptodo/utils/format_time_utils.dart';

class TaskItem extends StatelessWidget {
  final String name;
  final DateTime time;
  final String categoryLabel;
  final String priorityLabel;
  final String? categoryImgUrl;
  final String? categoryColorKey;
  final VoidCallback onTap;
  final bool isCompleted;
  final VoidCallback? setTaskCompleted;

  const TaskItem({
    super.key,
    required this.name,
    required this.time,
    required this.categoryLabel,
    required this.priorityLabel,
    this.categoryImgUrl,
    this.categoryColorKey,
    required this.onTap,
    required this.isCompleted,
    this.setTaskCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColor.upToDoBgSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: setTaskCompleted,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isCompleted ? AppColor.green : AppColor.upToDoWhile, width: 2),
                color: isCompleted ? AppColor.upToDoPrimary : AppColor.upToDoBorder,
              ),
              child: isCompleted
                  ? Icon(
                      Icons.check,
                      color: AppColor.upToDoWhile,
                      size: 16,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.displaySmall.copyWith(
                      color: AppColor.upToDoWhile,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    FormatTimeUtils.formatTaskTime(time),
                    style: AppTextStyles.displaySmall.copyWith(
                      color: AppColor.upToDoBorder,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: ColorUtils.getColorFromKey(categoryColorKey ?? ''),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Image(
                  image: categoryImgUrl != null
                      ? NetworkImage(categoryImgUrl ?? '')
                      : AssetImage(
                          'assets/images/image_not_found.png',
                        ),
                  width: 15,
                  height: 15,
                ),
                const SizedBox(width: 4),
                Text(
                  categoryLabel,
                  style: AppTextStyles.displaySmall.copyWith(
                    color: AppColor.upToDoWhile,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.upToDoPrimary, width: 1.5),
              borderRadius: BorderRadius.circular(6),
              color: AppColor.upToDoBgSecondary,
            ),
            child: Row(
              children: [
                Icon(Icons.flag, color: AppColor.upToDoPrimary, size: 18),
                const SizedBox(width: 2),
                Text(
                  priorityLabel,
                  style: AppTextStyles.displaySmall.copyWith(
                    color: AppColor.upToDoWhile,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
