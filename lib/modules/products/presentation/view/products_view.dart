import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/modules/products/data/models/product.dart';
import 'package:market/modules/products/data/repositories/product_repository.dart';
import 'package:market/modules/products/presentation/cubit/products_cubit.dart'; // Import the ProductsCubit class
import 'package:market/modules/products/presentation/cubit/products_state.dart'; // Import the ProductsState classes

class ProductsScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  ProductsScreen({required this.categoryId, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsCubit(ProductRepository())
        ..fetchProductsByCategory(categoryId), // Initialize ProductsCubit
      child: Scaffold(
        appBar: AppBar(
          title: Text(categoryName),
        ),
        body: BlocBuilder<ProductsCubit, ProductsState>(
          // Use ProductsCubit and ProductsState
          builder: (context, state) {
            if (state is ProductsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ProductsLoaded) {
              return buildProductGridView(state.products);
            } else if (state is ProductsError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget buildProductGridView(List<Product> products) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 0.5,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          color: Colors.white,
          child: Column(
            children: [
              Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 8),
              Text(
                product.name,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 4),
              Text(
                'Quantity: ${product.quantity}',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 4),
              Text(
                ' ${product.availability}',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 4),
              IconButton(
                  onPressed: () => print('Added ${product.name} to cart'),
                  icon: Icon(Icons.add)),
            ],
          ),
        );
      },
    );
  }
}
