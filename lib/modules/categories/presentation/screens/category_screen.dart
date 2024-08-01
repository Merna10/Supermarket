import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
// Assuming this imports your custom colors
import 'package:market/app/theme/text_styles.dart';
import 'package:market/modules/categories/data/models/category.dart';
import 'package:market/modules/categories/logic/bloc/category_bloc.dart';
import 'package:market/modules/categories/presentation/widgets/category_card_widget.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Categories',
            style: AppTextStyles.textTheme.headlineMedium,
          ),
        ),
        backgroundColor: HexColor('f1efde'),
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryInitial) {
            context.read<CategoryBloc>().add(FetchCategories());
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryLoaded) {
            return GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              children: List.generate(
                state.categories.length,
                (index) {
                  Category category = state.categories[index];
                  return CategoryCard(category: category);
                },
              ),
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
