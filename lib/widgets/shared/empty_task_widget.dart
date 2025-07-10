import 'package:flutter/material.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/styles/app_text_styles.dart';

class EmptyTasksWidget extends StatelessWidget {
  const EmptyTasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(image: AssetImage('assets/images/Checklist-rafiki_1.png')),
          Text(
            'What do you want to do today?',
            style: AppTextStyles.displaySmall.copyWith(
              color: AppColor.upToDoWhite,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Tap + to add your tasks",
            style: AppTextStyles.displaySmall.copyWith(
              color: AppColor.upToDoWhite,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          )
        ],
      ),
    );
  }
}
