import 'package:market/modules/categories/data/models/category.dart';
import 'package:market/modules/categories/data/services/category_service.dart';

class CategoryRepository {
  final CategoryService _categoryService;

  CategoryRepository({CategoryService? categoryService})
      : _categoryService = categoryService ?? CategoryService();

  Future<List<Category>> fetchCategories() {
    return _categoryService.fetchCategories();
  }

  Future<void> addCategory(Category category) async {
    return _categoryService.addCategory(category);
  }

  Future<void> deleteCategory(Category category) async {
    try {
      return _categoryService.deleteCategory(category);
    } catch (e) {
      print('Failed to delete category: $e');
      throw Exception('Failed to delete categories: $e');
    }
  }

  Future<String> fetchCategoryName(String categoryID) async {
    try {
      return _categoryService.fetchCategoryName(categoryID);
    } catch (e) {
      print('Failed to get category: $e');
      throw Exception('Failed to get categories: $e');
    }
  }
}
