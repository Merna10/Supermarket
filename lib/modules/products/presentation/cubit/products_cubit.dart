import 'package:bloc/bloc.dart';
import 'package:market/modules/products/data/repositories/product_repository.dart';
import 'package:market/modules/products/presentation/cubit/products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductRepository _productRepository;

  ProductsCubit(this._productRepository) : super(ProductsInitial());

  Future<void> fetchProductsByCategory(String categoryId) async {
    try {
      emit(ProductsLoading());
      final products = await _productRepository.fetchProductsByCategory(categoryId);
      emit(ProductsLoaded(products: products));
    } catch (e) {
      emit(ProductsError(message: 'Failed to fetch products: $e'));
    }
  }
}
