// lib/bloc/category_state.dart
part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();
  
  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> categories;

  CategoryLoaded({required this.categories});

  @override
  List<Object> get props => [categories];
}

class CategoryError extends CategoryState {
  final String error;

  CategoryError({required this.error});

  @override
  List<Object> get props => [error];
}
