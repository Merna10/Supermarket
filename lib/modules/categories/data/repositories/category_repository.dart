// lib/repositories/category_repository.dart

import 'package:market/modules/categories/data/models/category.dart';
import 'package:market/modules/categories/data/services/category_service.dart';

class CategoryRepository {
  final CategoryService _categoryService;

  CategoryRepository({CategoryService? categoryService})
      : _categoryService = categoryService ?? CategoryService();

  Future<List<Category>> fetchCategories() {
    return _categoryService.fetchCategories();
  }
}
