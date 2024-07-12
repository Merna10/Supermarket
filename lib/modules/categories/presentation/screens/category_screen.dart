// lib/screens/category_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/modules/categories/data/models/category.dart';
import 'package:market/modules/categories/logic/bloc/category_bloc.dart';
import 'package:market/modules/categories/presentation/widgets/category_card_widget.dart';
import 'package:market/modules/products/presentation/screens/product_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryInitial) {
            context.read<CategoryBloc>().add(FetchCategories());
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryLoaded) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.6,
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 3.0,
              ),
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                Category category = state.categories[index];
                return CategoryCard(category: category);
              },
            );
          } else if (state is CategoryError) {
            return Center(child: Text('Error: ${state.error}'));
          }
          return Container();
        },
      ),
    );
  }
}
