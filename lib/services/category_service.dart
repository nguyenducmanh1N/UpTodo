import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uptodo/models/category/category_dto.dart';
import 'package:uptodo/constants/shared_preferences.dart';

class CategoryService {
  final String key = SharedPreferencesKeys.categoriesKey;
  String _userCategoriesKey(String userId) => '${key}_$userId';

  Future<List<CategoryDTO>> getCategories(String userId) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final String? categoriesJson = sharedPreferences.getString(_userCategoriesKey(userId));
    if (categoriesJson == null) {
      return [];
    }
    final List<dynamic> jsonList = json.decode(categoriesJson);
    return jsonList.map((json) => CategoryDTO.fromJson(json)).toList();
  }

  Future<void> saveCategory(String userId, CategoryDTO category) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final List<CategoryDTO> categories = await getCategories(userId);
    categories.add(category);
    final String categoriesJson = json.encode(categories.map((c) => c.toJson()).toList());
    await sharedPreferences.setString(_userCategoriesKey(userId), categoriesJson);
  }

  Future<CategoryDTO?> getCategoryById(String userId, String categoryId) async {
    final categories = await getCategories(userId);
    return categories.firstWhere((category) => category.id == categoryId);
  }
}
