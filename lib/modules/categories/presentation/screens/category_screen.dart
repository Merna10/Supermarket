import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/app/theme/colors.dart';
import 'package:market/app/theme/text_styles.dart';
import 'package:market/modules/authentication/logic/bloc/auth_bloc.dart';
import 'package:market/modules/categories/data/models/category.dart';
import 'package:market/modules/categories/logic/bloc/category_bloc.dart';
import 'package:market/modules/categories/presentation/widgets/category_card_widget.dart';
import 'package:market/shared/widgets/drawer.dart';
import 'package:uuid/uuid.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthCheckStatusEvent());
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

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
        backgroundColor: AppColors.primaryColor,
      ),
      drawer: const CustomDrawer(),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, categoryState) {
          if (categoryState is CategoryInitial) {
            context.read<CategoryBloc>().add(FetchCategories());
            return const Center(child: CircularProgressIndicator());
          } else if (categoryState is CategoryLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            );
          } else if (categoryState is CategoryLoaded) {
            return BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                final canDelete = authState is AuthAuthenticated &&
                    authState.role == 'super_admin';
                return GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  children: List.generate(
                    categoryState.categories.length,
                    (index) {
                      Category category = categoryState.categories[index];
                      return CategoryCard(
                        category: category,
                        canDelete: canDelete,
                      );
                    },
                  ),
                );
              },
            );
          } else if (categoryState is CategoryError) {
            return Center(child: Text('Error: ${categoryState.error}'));
          }
          return Container();
        },
      ),
      floatingActionButton: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated && state.role == 'super_admin') {
            return FloatingActionButton(
              onPressed: () {
                _showAddCategoryDialog();
              },
              backgroundColor: AppColors.accentColor,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Category Name'),
              ),
              TextField(
                controller: _imageUrlController,
                decoration:
                    const InputDecoration(labelText: 'Image URL (optional)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final name = _nameController.text.trim();
                final imageUrl = _imageUrlController.text.trim();

                if (name.isNotEmpty) {
                  final newCategory = Category(
                    id: const Uuid().v4(),
                    name: name,
                    imageUrl: imageUrl,
                  );
                  context
                      .read<CategoryBloc>()
                      .add(AddCategoryItem(category: newCategory));
                }

                _nameController.clear();
                _imageUrlController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
