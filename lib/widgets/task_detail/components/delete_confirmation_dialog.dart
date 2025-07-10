import 'package:flutter/material.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/styles/app_text_styles.dart';
import 'package:uptodo/widgets/auth/components/custom_button.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final Function? onDeleteConfirmed;
  const DeleteConfirmationDialog({super.key, this.onDeleteConfirmed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.upToDoBgSecondary,
      title: Text(
        'Delete Task',
        style: AppTextStyles.displayMedium.copyWith(color: AppColor.upToDoWhite),
      ),
      content: Text(
        'Are you sure you want to delete this task?',
        style: AppTextStyles.displaySmall.copyWith(color: AppColor.upToDoWhite),
      ),
      actions: [
        CustomButton(
            onPressed: () {
              Navigator.pop(context);
            },
            label: 'Cancel',
            isEnabled: true),
        CustomButton(
            onPressed: () {
              onDeleteConfirmed!();
              Navigator.pop(context);
            },
            label: 'Delete',
            isEnabled: true)
      ],
    );
  }
}
