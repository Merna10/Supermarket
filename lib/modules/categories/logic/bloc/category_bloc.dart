import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:market/modules/categories/data/models/category.dart';
import 'package:market/modules/categories/data/repositories/category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository;

  CategoryBloc({required CategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository,
        super(CategoryInitial()) {
    on<FetchCategories>(_onFetchCategories);
  }

  void _onFetchCategories(FetchCategories event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      final categories = await _categoryRepository.fetchCategories();
      emit(CategoryLoaded(categories: categories));
    } catch (e) {
      emit(CategoryError(error: e.toString()));
    }
  }
}
