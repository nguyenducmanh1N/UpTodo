import 'package:flutter/material.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/styles/app_text_styles.dart';
import 'package:uptodo/widgets/addCategory/componets/category_color_widget.dart';

class AddCategoryScreen extends StatelessWidget {
  const AddCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Category",
                style: AppTextStyles.displayLarge.copyWith(
                  color: AppColor.upToDoWhile,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Category name",
                style: AppTextStyles.displaySmall.copyWith(
                  color: AppColor.upToDoWhile,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Category Icon",
                style: AppTextStyles.displaySmall.copyWith(
                  color: AppColor.upToDoWhile,
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 48,
                width: 150,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.upToDoKeyPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: SizedBox(
                    child: Center(
                      child: Text(
                        "Add Category",
                        style: AppTextStyles.displaySmall.copyWith(
                          color: AppColor.upToDoWhile,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              CategoryColorPicker(
                colors: [
                  Color(0xFFEDE861),
                  Color(0xFF61ED7A),
                  Color(0xFF61EDE6),
                  Color(0xFF6195ED),
                  Color(0xFF617AED),
                  Color(0xFFEDB061),
                  Color(0xFFB061ED),
                  Color(0xFFED6195),
                ],
                selectedColor: null,
                onColorSelected: (color) {
                  // setState(() {
                  //   _selectedColor = color;
                  // });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
