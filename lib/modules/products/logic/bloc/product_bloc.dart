import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:market/core/enum/fetch_method.dart';
import 'package:market/modules/products/data/models/product.dart';
import 'package:market/modules/products/data/repositories/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  StreamSubscription<List<Product>>? _productSubscription;

  ProductBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(ProductInitial()) {
    on<FetchProductsByCategory>(_onFetchProductsByCategory);
    on<FetchProductsByCollection>(_onFetchProductsByCollection);
    on<SortProductsByPrice>(_onSortProductsByPrice);
    on<SortProductsAlphabetically>(_onSortProductsAlphabetically);
    on<ProductsLoaded>(_onProductsLoaded);
    on<ProductsError>(_onProductsError);
    on<FetchFavorites>(_onFetchFavorites);
    on<AddToFavorites>(_onAddToFavorites);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
    on<CheckIfFavorite>(_onCheckIfFavorite);
    on<AddToProducts>(_onAddProducts);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
    on<SortProductsByStatus>(_onSortProductsByStatus);

    on<ClearFilters>(_onClearFilters);
  }

  void _onFetchProductsByCategory(
      FetchProductsByCategory event, Emitter<ProductState> emit) {
    emit(ProductLoading());
    _productSubscription?.cancel();
    _productSubscription =
        _productRepository.fetchProductsByCategory(event.category).listen(
      (products) {
        add(ProductsLoaded(products: products));
      },
      onError: (error) {
        add(ProductsError(error: error.toString()));
      },
    );
  }

  void _onFetchProductsByCollection(
      FetchProductsByCollection event, Emitter<ProductState> emit) {
    emit(ProductLoading());
    _productSubscription?.cancel();
    _productSubscription =
        _productRepository.fetchProductsByCollection(event.collection).listen(
              (products) => add(ProductsLoaded(products: products)),
              onError: (error) => add(ProductsError(error: error.toString())),
            );
  }

  void _onSortProductsByPrice(
      SortProductsByPrice event, Emitter<ProductState> emit) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final sortedProducts = List<Product>.from(currentState.products);
      sortedProducts.sort((a, b) => event.ascending
          ? a.price.compareTo(b.price)
          : b.price.compareTo(a.price));
      emit(ProductLoaded(products: sortedProducts));
    }
  }

  void _onSortProductsByStatus(
      SortProductsByStatus event, Emitter<ProductState> emit) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final filteredProducts = List<Product>.from(currentState.products);

      final onlyShowTrue = event.showTrue;
      final onlyShowFalse = event.showFalse;

      final statusFilteredProducts = filteredProducts.where((product) {
        if (onlyShowTrue && !product.availability) {
          return false;
        }
        if (onlyShowFalse && product.availability) {
          return false;
        }
        return true;
      }).toList();

      statusFilteredProducts.sort((a, b) {
        if (event.ascending) {
          add(ClearFilters());
          return a.availability == b.availability
              ? 0
              : (a.availability ? -1 : 1);
        } else {
          add(ClearFilters());
          return a.availability == b.availability
              ? 0
              : (a.availability ? 1 : -1);
        }
      });

      // Emit the updated state with filtered and sorted products
      emit(ProductLoaded(products: statusFilteredProducts));
    }
  }

  void _onClearFilters(ClearFilters event, Emitter<ProductState> emit) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      emit(ProductLoaded(
          products: currentState.products)); // Reset to original state
    }
  }

  void _onSortProductsAlphabetically(
      SortProductsAlphabetically event, Emitter<ProductState> emit) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final sortedProducts = List<Product>.from(currentState.products);
      sortedProducts.sort((a, b) => event.ascending
          ? a.name.compareTo(b.name)
          : b.name.compareTo(a.name));
      emit(ProductLoaded(products: sortedProducts));
    }
  }

  void _onProductsLoaded(ProductsLoaded event, Emitter<ProductState> emit) {
    emit(ProductLoaded(products: event.products));
  }

  void _onCheckIfFavorite(
      CheckIfFavorite event, Emitter<ProductState> emit) async {
    try {
      final isFavorite = await _productRepository.isProductFavorite(
          event.userId, event.productId);
      emit(FavoriteStatus(isFavorite: isFavorite));

      if (event.method == FetchMethod.byCategory) {
        add(FetchProductsByCategory(category: event.fetchId));
      } else if (event.method == FetchMethod.byCollection) {
        add(FetchProductsByCollection(collection: event.fetchId));
      }
    } catch (e) {
      emit(const FavoriteStatus(isFavorite: false));
    }
  }

  void _onProductsError(ProductsError event, Emitter<ProductState> emit) {
    emit(ProductError(error: event.error));
  }

  void _onFetchFavorites(FetchFavorites event, Emitter<ProductState> emit) {
    emit(ProductLoading());
    _productSubscription?.cancel();
    _productSubscription =
        _productRepository.fetchFavoriteProducts(event.userId).listen(
              (products) => add(ProductsLoaded(products: products)),
              onError: (error) => add(ProductsError(error: error.toString())),
            );
  }

  Future<void> _onAddToFavorites(
      AddToFavorites event, Emitter<ProductState> emit) async {
    try {
      await _productRepository.addToFavorites(event.userId, event.product);
      add(CheckIfFavorite(
          userId: event.userId,
          productId: event.product.id,
          method: event.method,
          fetchId: event.fetchId));
    } catch (e) {
      print("Failed to add favorite: $e");
    }
  }

  Future<void> _onRemoveFromFavorites(
      RemoveFromFavorites event, Emitter<ProductState> emit) async {
    try {
      await _productRepository.removeFromFavorites(event.userId, event.product);
      add(CheckIfFavorite(
          userId: event.userId,
          productId: event.product.id,
          method: event.method,
          fetchId: event.fetchId));
    } catch (e) {
      print("Failed to remove favorite: $e");
    }
  }

  Future<void> _onAddProducts(
      AddToProducts event, Emitter<ProductState> emit) async {
    try {
      await _productRepository.addProduct(event.product, event.imageFiles);
      if (event.method == FetchMethod.byCategory) {
        _onFetchProductsByCategory(
          FetchProductsByCategory(category: event.fetchId),
          emit,
        );
      } else if (event.method == FetchMethod.byCollection) {
        _onFetchProductsByCollection(
          FetchProductsByCollection(collection: event.fetchId),
          emit,
        );
      }
    } catch (e) {
      print("Failed to add product: $e");
      emit(ProductError(error: e.toString()));
    }
  }

  void _onUpdateProduct(UpdateProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final updatedProduct =
          await _productRepository.updateProduct(event.product);
      emit(ProductUpdated(product: updatedProduct));

      if (event.method == FetchMethod.byCategory) {
        _onFetchProductsByCategory(
          FetchProductsByCategory(category: event.fetchId),
          emit,
        );
      } else if (event.method == FetchMethod.byCollection) {
        _onFetchProductsByCollection(
          FetchProductsByCollection(collection: event.fetchId),
          emit,
        );
      }
    } catch (e) {
      emit(ProductError(error: e.toString()));
    }
  }

  void _onDeleteProduct(DeleteProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      await _productRepository.deleteProduct(event.productId);
      emit(ProductDeleted());
      if (event.method == FetchMethod.byCategory) {
        _onFetchProductsByCategory(
          FetchProductsByCategory(category: event.fetchId),
          emit,
        );
      } else if (event.method == FetchMethod.byCollection) {
        _onFetchProductsByCollection(
          FetchProductsByCollection(collection: event.fetchId),
          emit,
        );
      }
    } catch (e) {
      emit(ProductError(error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _productSubscription?.cancel();
    return super.close();
  }
}
