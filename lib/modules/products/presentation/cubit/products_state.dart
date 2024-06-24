import 'package:equatable/equatable.dart';
import 'package:market/modules/products/data/models/product.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Product> products;

  ProductsLoaded({required this.products});

  @override
  List<Object?> get props => [products];
}

class ProductsError extends ProductsState {
  final String message;

  ProductsError({required this.message});

  @override
  List<Object?> get props => [message];
}
