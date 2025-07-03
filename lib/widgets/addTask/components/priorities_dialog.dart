import 'dart:math';

import 'package:flutter/material.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/styles/app_text_styles.dart';

class PrioritiesDialog extends StatelessWidget {
  PrioritiesDialog({super.key});

  final List<Map<String, dynamic>> priorities = [
    {'icon': Icons.local_grocery_store, 'label': '1'},
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColor.upToDoBgSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Choose Task Priority",
                style: AppTextStyles.displayMedium.copyWith(
                  color: AppColor.upToDoWhile,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 400,
              width: double.infinity,
              child: SingleChildScrollView(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: priorities.length,
                  itemBuilder: (context, index) {
                    final priortity = priorities[index];
                    return Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: AppColor.upToDoBgPrimary,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          print('Selected priority: ${priorities[index]['label']}');
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image(
                                  width: 10,
                                  height: 10,
                                  image: AssetImage(
                                    'assets/images/flag_icon.png',
                                  )),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              priortity['label'],
                              style: AppTextStyles.displaySmall.copyWith(
                                color: AppColor.upToDoWhile,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: AppTextStyles.displaySmall.copyWith(
                      color: AppColor.upToDoKeyPrimary,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.upToDoKeyPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Choose Time",
                    style: AppTextStyles.displaySmall.copyWith(
                      color: AppColor.upToDoWhile,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onCategorySelected(String priortity) {
    print('Selected priority: $priortity');
  }
}
