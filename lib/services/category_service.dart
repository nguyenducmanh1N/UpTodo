import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uptodo/models/category/category_dto.dart';
import 'package:uptodo/constants/shared_preferences.dart';
import 'package:collection/collection.dart';

class CategoryService {
  final String key = SharedPreferencesKeys.categoriesKey;
  String _userCategoriesKey(String userId) => '${key}_$userId';

  Future<List<CategoryDTO>> getCategories(String userId) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final String? categoriesJson = sharedPreferences.getString(_userCategoriesKey(userId));
      if (categoriesJson == null) {
        return [];
      }
      final List<dynamic> jsonList = json.decode(categoriesJson);
      if (jsonList.isEmpty) {
        return [];
      }
      return jsonList.map((json) => CategoryDTO.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveCategory(String userId, CategoryDTO category) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final List<CategoryDTO> categories = await getCategories(userId);
      categories.add(category);
      final String categoriesJson = json.encode(categories.map((c) => c.toJson()).toList());
      await sharedPreferences.setString(_userCategoriesKey(userId), categoriesJson);
    } catch (e) {
      throw Exception('Failed to save category: $e');
    }
  }

  Future<CategoryDTO?> getCategoryById(String userId, String categoryId) async {
    try {
      final categories = await getCategories(userId);
      return categories.firstWhereOrNull((category) => category.id == categoryId);
    } catch (e) {
      return null;
    }
  }

  Future<bool> checkCategoryExists(String userId, String categoryName) async {
    try {
      final categories = await getCategories(userId);
      return categories.any((category) => category.name.trim().toLowerCase() == categoryName.trim().toLowerCase());
    } catch (e) {
      return false;
    }
  }
}
