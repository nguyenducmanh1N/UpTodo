import 'package:flutter/material.dart';
import 'package:uptodo/styles/app_color.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final String? errorText;
  final String? initialValue;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.obscureText = false,
    this.errorText,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      obscureText: obscureText,
      style: TextStyle(color: AppColor.upToDoWhite),
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
        hintStyle: TextStyle(color: AppColor.upToDoWhite),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: AppColor.upToDoBorder,
      ),
    );
  }
}
