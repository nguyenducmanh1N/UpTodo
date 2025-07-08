import 'package:flutter/material.dart';
import 'package:uptodo/styles/app_color.dart';
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
      padding: const EdgeInsets.all(12),
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
                border: Border.all(
                  color: isCompleted ? AppColor.green : AppColor.upToDoWhile,
                  width: 2,
                ),
              ),
              child: isCompleted ? Icon(Icons.check, color: AppColor.upToDoWhile, size: 16) : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Text(
                          name,
                          style: TextStyle(
                            color: AppColor.upToDoWhile,
                            fontSize: 16.5,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        FormatTimeUtils.formatTaskTime(time),
                        style: TextStyle(
                          color: AppColor.upToDoWhile,
                          fontSize: 13.5,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: ColorUtils.getColorFromKey(categoryColorKey ?? ''),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            categoryImgUrl != null && categoryImgUrl!.isNotEmpty
                                ? Image.network(
                                    categoryImgUrl!,
                                    width: 16,
                                    height: 16,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/image_not_found.png',
                                        width: 16,
                                        height: 16,
                                      );
                                    },
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColor.upToDoWhile,
                                        ),
                                      );
                                    },
                                  )
                                : Image.asset(
                                    'assets/images/image_not_found.png',
                                    width: 16,
                                    height: 16,
                                  ),
                            const SizedBox(width: 6),
                            Text(
                              categoryLabel,
                              style: const TextStyle(
                                color: AppColor.upToDoWhile,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.upToDoPrimary, width: 1.4),
                          borderRadius: BorderRadius.circular(6),
                          color: AppColor.upToDoBgSecondary,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.flag, color: AppColor.upToDoPrimary, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              priorityLabel,
                              style: TextStyle(color: AppColor.upToDoWhile),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
