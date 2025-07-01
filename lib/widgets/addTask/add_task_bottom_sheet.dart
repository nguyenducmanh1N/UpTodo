import 'package:flutter/material.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/styles/app_text_styles.dart';
import 'package:uptodo/widgets/addTask/components/categories_dialog.dart';
import 'package:uptodo/widgets/addTask/components/date_dialog.dart';

class AddTaskBottomSheet extends StatelessWidget {
  const AddTaskBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 16.0,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: AppColor.upToDoBgSecondary,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              "Add Task",
              style: AppTextStyles.displayLarge.copyWith(
                color: AppColor.upToDoWhile,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              style: TextStyle(color: AppColor.upToDoWhile),
              decoration: InputDecoration(
                hintText: "Name",
                hintStyle: TextStyle(color: AppColor.upToDoBorder),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColor.upToDoBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColor.upToDoKeyPrimary, width: 2),
                ),
                filled: true,
                fillColor: AppColor.upToDoBorder,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              style: TextStyle(color: AppColor.upToDoWhile),
              decoration: InputDecoration(
                hintText: "Description",
                hintStyle: TextStyle(color: AppColor.upToDoBorder),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColor.upToDoBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColor.upToDoKeyPrimary, width: 2),
                ),
                filled: true,
                fillColor: AppColor.upToDoBorder,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DateDialog();
                            });
                      },
                      child: SizedBox(
                        child: Image(image: AssetImage('assets/images/timer_icon.png'), width: 24, height: 24),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        _showCategoriesDialog(context);
                      },
                      child: SizedBox(
                        child: Image(image: AssetImage('assets/images/tag_icon.png'), width: 24, height: 24),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {},
                      child: SizedBox(
                        child: Image(image: AssetImage('assets/images/flag_icon.png'), width: 24, height: 24),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {},
                  child: SizedBox(
                    child: Image(image: AssetImage('assets/images/send_icon.png'), width: 24, height: 24),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showCategoriesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CategoriesDialog(),
    );
  }
}
