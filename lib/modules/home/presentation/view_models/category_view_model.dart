import 'package:market/modules/home/data/models/category.dart';
import 'package:market/modules/home/data/repositories/category_repository.dart';

class CategoryViewModel {
  final CategoryRepository _categoryRepository = CategoryRepository();

  Future<Category> fetchCategory(String id) async {
    List<Category> categories = await _categoryRepository.fetchCategories();
    return categories.firstWhere((category) => category.id == id);
  }
}