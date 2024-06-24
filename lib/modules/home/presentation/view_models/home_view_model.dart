import 'package:market/modules/home/data/models/category.dart';
import 'package:market/modules/home/data/repositories/category_repository.dart';

class HomeViewModel {
  final CategoryRepository _categoryRepository = CategoryRepository();

  Future<List<Category>> fetchCategories() async {
    return await _categoryRepository.fetchCategories();
  }
}
