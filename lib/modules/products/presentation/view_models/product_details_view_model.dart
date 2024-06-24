import 'package:flutter/material.dart';
import 'package:market/modules/products/data/models/product.dart';
import 'package:market/modules/products/data/repositories/product_repository.dart';

class ProductDetailsViewModel extends ChangeNotifier {
  final ProductRepository _productRepository = ProductRepository();
  bool isLoading = false;
  Product? product;

  Future<void> fetchProductDetails(String productId) async {
    isLoading = true;
    notifyListeners();

    product = await _productRepository.fetchProductById(productId);

    isLoading = false;
    notifyListeners();
  }
}
