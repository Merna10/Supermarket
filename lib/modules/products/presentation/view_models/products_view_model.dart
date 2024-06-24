import 'package:flutter/material.dart';
import 'package:market/modules/products/data/models/product.dart';
import 'package:market/modules/products/data/repositories/product_repository.dart';

class ProductsViewModel extends ChangeNotifier {
  final ProductRepository _productRepository = ProductRepository();
  bool isLoading = false;
  List<Product> products = [];

  Future<void> fetchProductsByCategory(String categoryId) async {
    isLoading = true;
    notifyListeners();

    products = await _productRepository.fetchProductsByCategory(categoryId);

    isLoading = false;
    notifyListeners();
  }
}
