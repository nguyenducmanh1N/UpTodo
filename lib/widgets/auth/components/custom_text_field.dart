import 'package:flutter/material.dart';
import 'package:uptodo/styles/app_color.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onChanged;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (value) => onChanged(),
      obscureText: obscureText,
      style: TextStyle(color: AppColor.uptodowhite),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColor.uptodoBoder),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[900],
      ),
    );
  }
}
