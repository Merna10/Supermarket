part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;

  const ProductLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

class ProductUpdated extends ProductState {
  final Product product;

  const ProductUpdated({required this.product});

  @override
  List<Object> get props => [product];
}

class ProductDeleted extends ProductState {}

class ProductError extends ProductState {
  final String error;

  const ProductError({required this.error});

  @override
  List<Object> get props => [error];
}

class FavoriteStatus extends ProductState {
  final bool isFavorite;

  const FavoriteStatus({required this.isFavorite});

  @override
  List<Object> get props => [isFavorite];
}

class FavoriteProductsLoaded extends ProductState {
  final List<Product> favorites;

  const FavoriteProductsLoaded({required this.favorites});

  @override
  List<Object> get props => [favorites];
}
