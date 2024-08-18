import 'dart:io';

import 'package:market/modules/products/data/models/product.dart';
import 'package:market/modules/products/data/services/product_service.dart';

class ProductRepository {
  final ProductService _productService;

  ProductRepository({ProductService? productService})
      : _productService = productService ?? ProductService();

  Stream<List<Product>> fetchProductsByCategory(String category) {
    return _productService.fetchProductsByCategory(category);
  }

  Stream<List<Product>> fetchProductsByCollection(String collection) {
    return _productService.fetchProductsByCollection(collection);
  }

  Stream<int> fetchProductQuantity(String productId) {
    return _productService.fetchProductQuantity(productId);
  }

  Stream<List<Product>> fetchFavoriteProducts(String userId) {
    return _productService.fetchFavoriteProducts(userId);
  }

  Future<void> addToFavorites(String userId, Product product) async {
    return _productService.addToFavorites(userId, product);
  }

  Future<bool> isProductFavorite(String userId, String productId) async {
    return _productService.isProductFavorite(userId, productId);
  }

  Future<void> removeFromFavorites(String userId, Product product) async {
    return _productService.removeFromFavorites(userId, product);
  }

  Future<Map<String, dynamic>?> getCollectionDetails(String collectionId) {
    return _productService.getCollectionDetails(collectionId);
  }

  Future<void> addProduct(Product product, List<File>? imageFiles) async {
    try {
      return _productService.addProduct(product, imageFiles);
    } catch (e) {
      print('Failed to add product: $e');
      throw Exception('Failed to add product: $e');
    }
  }

  Future<Product> updateProduct(Product product) async {
    try {
      return _productService.updateProduct(product);
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      return _productService.deleteProduct(productId);
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
}
