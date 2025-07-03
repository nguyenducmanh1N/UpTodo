import 'package:uptodo/models/category/category_dto.dart';
import 'package:uptodo/services/category_service.dart';

class CategoryRepository {
  final CategoryService _categoryService;
  CategoryRepository(this._categoryService);

  Future<List<CategoryDTO>> getCategories(String userId) async {
    return await _categoryService.getCategories(userId);
  }

  Future<void> saveCategory(String userId, CategoryDTO category) async {
    await _categoryService.saveCategory(userId, category);
  }
}
