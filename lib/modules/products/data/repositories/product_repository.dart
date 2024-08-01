import 'package:market/modules/products/data/models/product.dart';
import 'package:market/modules/products/data/services/product_service.dart';

class ProductRepository {
  final ProductService _productService;

  ProductRepository({ProductService? productService})
      : _productService = productService ?? ProductService();

  Future<List<Product>> fetchProductsByCategory(String category) {
    return _productService.fetchProductsByCategory(category);
  }
}
