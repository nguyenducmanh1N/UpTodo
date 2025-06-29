import 'package:flutter/material.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/styles/app_text_styles.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool isEnabled;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? AppColor.upToDoPrimary : AppColor.upToDoPrimary50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          disabledBackgroundColor: AppColor.upToDoPrimary50,
          disabledForegroundColor: AppColor.upToDoWhile,
        ),
        child: Text(
          label,
          style: AppTextStyles.displaySmall.copyWith(
            color: AppColor.upToDoWhile,
          ),
        ),
      ),
    );
  }
}
