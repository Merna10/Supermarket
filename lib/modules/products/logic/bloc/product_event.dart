part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class FetchProductsByCategory extends ProductEvent {
  final String category;

  const FetchProductsByCategory({required this.category});

  @override
  List<Object> get props => [category];
}

class FetchProductsByCollection extends ProductEvent {
  final String collection;

  const FetchProductsByCollection({required this.collection});

  @override
  List<Object> get props => [collection];
}

class ProductsLoaded extends ProductEvent {
  final List<Product> products;

  const ProductsLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

class ProductsError extends ProductEvent {
  final String error;

  const ProductsError({required this.error});

  @override
  List<Object> get props => [error];
}

class SortProductsByPrice extends ProductEvent {
  final bool ascending;

  const SortProductsByPrice({required this.ascending});

  @override
  List<Object> get props => [ascending];
}

class SortProductsByStatus extends ProductEvent {
  final bool ascending;
  final bool showTrue;
  final bool showFalse;

  SortProductsByStatus({
    required this.ascending,
    this.showTrue = false,
    this.showFalse = false,
  });

  @override
  List<Object> get props => [ascending, showTrue, showFalse];
}

class ClearFilters extends ProductEvent {}

class SortProductsAlphabetically extends ProductEvent {
  final bool ascending;

  const SortProductsAlphabetically({required this.ascending});

  @override
  List<Object> get props => [ascending];
}

class FavoritesLoaded extends ProductEvent {
  final List<Product> favorites;

  const FavoritesLoaded(this.favorites);

  @override
  List<Object> get props => [favorites];
}

class AddToFavorites extends ProductEvent {
  final String userId;
  final Product product;

  final FetchMethod method;
  final String fetchId;
  const AddToFavorites({
    required this.userId,
    required this.product,
    required this.method,
    required this.fetchId,
  });

  @override
  List<Object> get props => [userId, product];
}

class AddToProducts extends ProductEvent {
  final Product product;
  final List<File>? imageFiles;

 final FetchMethod method;
  final String fetchId;
  const AddToProducts({
    required this.product,
    this.imageFiles,
    required this.method,
    required this.fetchId,
  });
}

class UpdateProduct extends ProductEvent {
  final Product product;
 final FetchMethod method;
  final String fetchId;
  const UpdateProduct({required this.product,
    required this.method,
    required this.fetchId,});

  @override
  List<Object> get props => [product];
}

class DeleteProduct extends ProductEvent {
  final String productId;
final FetchMethod method;
  final String fetchId;
  
  const DeleteProduct({required this.productId,required this.method,
    required this.fetchId,});

  @override
  List<Object> get props => [productId];
}

class RemoveFromFavorites extends ProductEvent {
  final String userId;
  final Product product;

  final FetchMethod method;
  final String fetchId;
  const RemoveFromFavorites({
    required this.userId,
    required this.product,
    required this.method,
    required this.fetchId,
  });

  @override
  List<Object> get props => [userId, product];
}

class CheckIfFavorite extends ProductEvent {
  final String userId;
  final String productId;
  final FetchMethod method;
  final String fetchId;

  const CheckIfFavorite({
    required this.userId,
    required this.productId,
    required this.method,
    required this.fetchId,
  });
}

class FavoriteStatusLoaded extends ProductEvent {
  final bool isFavorite;

  const FavoriteStatusLoaded({required this.isFavorite});

  @override
  List<Object> get props => [isFavorite];
}

class FetchFavorites extends ProductEvent {
  final String userId;

  const FetchFavorites({required this.userId});

  @override
  List<Object> get props => [userId];
}
