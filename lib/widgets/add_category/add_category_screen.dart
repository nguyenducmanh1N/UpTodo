import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
import 'package:uptodo/widgets/add_category/components/category_color_widget.dart';
import 'package:uptodo/widgets/auth/components/custom_text_field.dart';
import 'package:uuid/uuid.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final CategoryRepository _categoryRepository = CategoryRepository(CategoryService());
  final ImagePicker _imagePicker = ImagePicker();
  final ImagesStorageRepository _imagesStorageRepository = ImagesStorageRepository(ImagesStorageService());
  late final AuthProvider authProvider;
  Color? _selectedColor = ColorUtils.categoryColors[0]['color'];
  String _categoryName = '';
  String? _categoryNameError;
  String? _iconPath;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  void _onCategoryNameChanged(String value) {
    setState(() {
      if (value.trim().isEmpty) {
        _categoryNameError = 'Category name cannot be empty';
        return;
      }
      _categoryNameError = null;
      _categoryName = value;
    });
  }

  Future<String?> _uploadCategoryImage(String iconPath) async {
    try {
      final imageFile = File(iconPath);
      final imageUrl = await _imagesStorageRepository.saveImage(imageFile);
      return imageUrl;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save image: $e')),
      );
      return null;
    }
  }

  void _handleSaveCategory() async {
    if (_selectedColor == null || _iconPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all fields')),
      );
      return;
    }
    try {
      final imageUrl = await _uploadCategoryImage(_iconPath!);
      if (imageUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload category image')),
        );
        return;
      }
      final uuid = Uuid();
      final category = CategoryDTO(
        id: uuid.v4(),
        name: _categoryName,
        color: ColorUtils.getKeyFromColor(_selectedColor!),
        img: imageUrl,
      );

      final userId = authProvider.currentUser?.id ?? '';
      await _categoryRepository.saveCategory(userId, category);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category saved successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving category: $e')),
      );
    }
  }

  Future<void> _pickImageFromLibrary() async {
    try {
      final XFile? file = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        setState(() {
          _iconPath = file.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.upToDoBlack,
      body: SafeArea(
        child: SingleChildScrollView(
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
                  "Category name :",
                  style: AppTextStyles.displaySmall.copyWith(
                    color: AppColor.upToDoWhile,
                  ),
                ),
                SizedBox(height: 8),
                CustomTextField(
                  onChanged: _onCategoryNameChanged,
                  hintText: "Enter category name",
                  obscureText: false,
                  errorText: _categoryNameError,
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
                  child: ElevatedButton(
                    onPressed: _pickImageFromLibrary,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.upToDoPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: SizedBox(
                      child: Center(
                        child: Text(
                          "Choose icon from library",
                          style: AppTextStyles.displaySmall.copyWith(
                            color: AppColor.upToDoWhile,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (_iconPath != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Image.file(
                      File(_iconPath!),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                SizedBox(height: 16),
                CategoryColorPicker(
                  colors: ColorUtils.categoryColors.map((e) => e['color'] as Color).toList(),
                  selectedColor: _selectedColor,
                  onColorSelected: (color) {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.upToDoBlack,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: AppTextStyles.displaySmall.copyWith(
                          color: AppColor.upToDoWhile,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        _handleSaveCategory();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.upToDoPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Save",
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
        ),
      ),
    );
  }
}
