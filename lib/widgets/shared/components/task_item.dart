import 'package:flutter/material.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/styles/app_text_styles.dart';
import 'package:uptodo/utils/color_utils.dart';

class TaskItem extends StatelessWidget {
  final String title;
  final String timeText;
  final String categoryLabel;
  final String? categoryIcon;
  final String priorityLabel;
  final String? categoryImgUrl;
  final String? categoryColorKey;

  const TaskItem({
    super.key,
    required this.title,
    required this.timeText,
    required this.categoryLabel,
    this.categoryIcon,
    required this.priorityLabel,
    this.categoryImgUrl,
    this.categoryColorKey,
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
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColor.upToDoWhile, width: 2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.displaySmall.copyWith(
                    color: AppColor.upToDoWhile,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  timeText,
                  style: AppTextStyles.displaySmall.copyWith(
                    color: Colors.white54,
                    fontSize: 15,
                  ),
                ),
              ],
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
              color: Colors.transparent,
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
