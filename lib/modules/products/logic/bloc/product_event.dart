// lib/bloc/product_event.dart
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
