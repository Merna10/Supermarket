// product_details_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/modules/products/data/models/product.dart';
import 'package:market/modules/products/data/repositories/product_repository.dart';

class ProductDetailsCubit extends Cubit<Product?> {
  final ProductRepository _repository = ProductRepository();

  ProductDetailsCubit() : super(null);

  Future<void> fetchProductDetails(String productId) async {
    try {
      final product = await _repository.fetchProductById(productId);
      emit(product);
    } catch (e) {
      print(e);
    }
  }
}
