import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market/core/enum/fetch_method.dart';
import 'package:market/modules/categories/logic/bloc/category_bloc.dart';
import 'package:market/shared/widgets/scaffold_with_nav_bar.dart';
import 'package:market/modules/categories/data/models/category.dart';
import 'package:market/modules/products/presentation/screens/product_screen.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final bool canDelete;

  const CategoryCard({
    super.key,
    required this.category,
    required this.canDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        if (canDelete) {
          _showDeleteConfirmationDialog(context);
        }
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScaffoldWithNavBar(
              child: ProductScreen(
                id: category.id,
                fetchMethod: FetchMethod.byCategory,
              ),
            ),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                child: Stack(
                  children: [
                    Image.network(
                      category.imageUrl,
                      fit: BoxFit.cover,
                      height: double.infinity,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        color: Colors.black.withOpacity(0.5),
                        child: Text(
                          category.name,
                          style: GoogleFonts.playfairDisplay(
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Category'),
          content: const Text('Are you sure you want to delete this category?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context
                    .read<CategoryBloc>()
                    .add(RemoveCategoryItem(category: category));
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
