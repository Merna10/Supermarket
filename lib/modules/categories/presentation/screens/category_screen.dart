import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:market/app/theme/colors.dart'; // Assuming this imports your custom colors
import 'package:market/modules/cart/presentation/cart_screen.dart';
import 'package:market/modules/categories/data/models/category.dart';
import 'package:market/modules/categories/logic/bloc/category_bloc.dart';
import 'package:market/modules/categories/presentation/widgets/category_card_widget.dart';
import 'package:market/modules/products/presentation/screens/product_screen.dart';

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
            style: GoogleFonts.playfairDisplay(
              textStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
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
