import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptodo/models/category/category_dto.dart';
import 'package:uptodo/providers/auth_provider.dart';
import 'package:uptodo/repositories/category_repository.dart';
import 'package:uptodo/repositories/images_storage_repository.dart';
import 'package:uptodo/services/category_service.dart';
import 'package:uptodo/services/images_storage_service.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/styles/app_text_styles.dart';
import 'package:uptodo/utils/color_utils.dart';
import 'package:uptodo/widgets/addCategory/add_category_screen.dart';

class CategoriesDialog extends StatefulWidget {
  const CategoriesDialog({super.key});

  @override
  State<CategoriesDialog> createState() => _CategoriesDialogState();
}

class _CategoriesDialogState extends State<CategoriesDialog> {
  final CategoryRepository _categoryRepository = CategoryRepository(CategoryService());
  final ImagesStorageRepository _imagesStorageRepository = ImagesStorageRepository(ImagesStorageService());

  late final AuthProvider authProvider;

  List<CategoryDTO> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    _loadCategories();
  }

  Color _getColorFromCategory(String colorIndex) {
    try {
      int index = int.parse(colorIndex);
      return ColorUtils.getColorFromIndex(index);
    } catch (e) {
      print('Error parsing color index: $e');
      return Colors.grey;
    }
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userId = authProvider.currentUser?.id ?? '';
      final categories = await _categoryRepository.getCategories(userId);
      for (var category in categories) {
        print('Category: ${category.name}, Color: ${category.color}, Image: ${category.img}');
      }
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving category: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
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
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];

                    return GestureDetector(
                      onTap: () {},
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: _getColorFromCategory(category.color),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _onCategorySelected(category.id);
                              },
                              child: FutureBuilder<String?>(
                                future: _imagesStorageRepository.getImagePath(category.img),
                                builder: (context, snapshot) => _buildCategoryImage(snapshot),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            category.name,
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
                backgroundColor: AppColor.upToDoPrimary,
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

  void _onCategorySelected(String id) {
    print('Selected category: $id');
  }

  void _onAddCategoryPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddCategoryScreen()),
    );
  }
}

Widget _buildCategoryImage(AsyncSnapshot<String?> snapshot) {
  if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      ),
    );
  }

  if (snapshot.hasData && snapshot.data != null) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.file(
        File(snapshot.data!),
        fit: BoxFit.cover,
      ),
    );
  }

  return const Icon(
    Icons.image_not_supported,
    color: AppColor.upToDoWhile,
  );
}
