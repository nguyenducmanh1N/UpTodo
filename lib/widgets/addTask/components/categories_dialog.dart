import 'package:flutter/material.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/styles/app_text_styles.dart';
import 'package:uptodo/widgets/addCategory/add_category_screen.dart';

class CategoriesDialog extends StatelessWidget {
  const CategoriesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {'icon': Icons.local_grocery_store, 'label': 'Grocery', 'color': Colors.lightGreen},
      {'icon': Icons.work, 'label': 'Work', 'color': Colors.orange},
      {'icon': Icons.fitness_center, 'label': 'Sport', 'color': Colors.cyan},
      {'icon': Icons.design_services, 'label': 'Design', 'color': Colors.teal},
      {'icon': Icons.school, 'label': 'University', 'color': Colors.blue},
      {'icon': Icons.campaign, 'label': 'Social', 'color': Colors.pink},
      {'icon': Icons.music_note, 'label': 'Music', 'color': Colors.pinkAccent},
      {'icon': Icons.health_and_safety, 'label': 'Health', 'color': Colors.greenAccent},
      {'icon': Icons.movie, 'label': 'Movie', 'color': Colors.lightBlue},
      {'icon': Icons.home, 'label': 'Home', 'color': Colors.amber},
      {'icon': Icons.add, 'label': 'Create New', 'color': Colors.tealAccent},
    ];

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
                "Choose Category",
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
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return GestureDetector(
                      onTap: () {
                        print('Selected category: ${category['label']}');
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: category['color'],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              category['icon'],
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            category['label'],
                            style: AppTextStyles.displaySmall.copyWith(
                              color: AppColor.upToDoWhile,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _onAddCategoryPressed(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.upToDoKeyPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
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
          ],
        ),
      ),
    );
  }

  void _onCategorySelected(String category) {
    print('Selected category: $category');
  }

  void _onAddCategoryPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddCategoryScreen()),
    );
  }
}
