// lib/bloc/product_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:market/modules/products/data/models/product.dart';
import 'package:market/modules/products/data/repositories/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(ProductInitial()) {
    on<FetchProductsByCategory>(_onFetchProductsByCategory);
  }

  void _onFetchProductsByCategory(FetchProductsByCategory event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final products = await _productRepository.fetchProductsByCategory(event.category);
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(error: e.toString()));
    }
  }
}
