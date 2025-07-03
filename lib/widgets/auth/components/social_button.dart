import 'package:flutter/material.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/styles/app_text_styles.dart';

class SocialButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final VoidCallback onPressed;
  final Color backgroundColor;

  const SocialButton({
    super.key,
    required this.label,
    required this.iconPath,
    required this.onPressed,
    this.backgroundColor = AppColor.upToDoBlack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColor.upToDoPrimary, width: 1.5),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: backgroundColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(iconPath),
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.displaySmall.copyWith(
                color: AppColor.upToDoWhile,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
