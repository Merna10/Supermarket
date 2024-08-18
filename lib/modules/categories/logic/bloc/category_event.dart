part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class FetchCategories extends CategoryEvent {}

class AddCategoryItem extends CategoryEvent {
  final Category category;

  const AddCategoryItem({required this.category});

  @override
  List<Object> get props => [category];
}

class FetchCategoryName extends CategoryEvent {
  final String categoryId;

  const FetchCategoryName({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}

class RemoveCategoryItem extends CategoryEvent {
  final Category category;

  const RemoveCategoryItem({required this.category});

  @override
  List<Object> get props => [category];
}