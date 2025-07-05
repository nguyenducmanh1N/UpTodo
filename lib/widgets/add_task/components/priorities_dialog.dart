import 'package:flutter/material.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/styles/app_text_styles.dart';
import 'package:uptodo/utils/priority_utils.dart';

class PrioritiesDialog extends StatelessWidget {
  const PrioritiesDialog({super.key});

  void _onPrioritySelected(String priorityKey, BuildContext context) {
    Navigator.pop(context, priorityKey);
  }

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
                  itemCount: PriorityUtils.priorities.length,
                  itemBuilder: (context, index) {
                    final priority = PriorityUtils.priorities[index];
                    return Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: AppColor.upToDoBgPrimary,
                      ),
                      child: GestureDetector(
                        onTap: () => _onPrioritySelected(
                          priority['key'],
                          context,
                        ),
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
                                image: AssetImage(priority['icon']),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              priority['label'],
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
                    backgroundColor: AppColor.upToDoPrimary,
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
}
