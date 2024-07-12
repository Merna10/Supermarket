// lib/screens/product_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/modules/cart/presentation/cart_screen.dart';
import 'package:market/modules/products/data/models/product.dart';
import 'package:market/modules/products/logic/bloc/product_bloc.dart';
import 'package:market/modules/products/presentation/widgets/product_card_widget.dart';

class ProductScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const ProductScreen(
      {super.key, required this.categoryId, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    context
        .read<ProductBloc>()
        .add(FetchProductsByCategory(category: categoryId));

    return Scaffold(
      appBar: AppBar(
        title: Text('$categoryName Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              if (user != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CartScreen(
                            userId: 'byYx0b3MJ5IGNHToI5Ws',
                          )),
                );
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.6,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                Product product = state.products[index];
                return ProductCard(
                  price: product.price,
                  productId: product.id,
                  productName: product.name,
                  productImage: product.productImage,
                  userId: 'byYx0b3MJ5IGNHToI5Ws',
                );
              },
            );
          } else if (state is ProductError) {
            return Center(child: Text('Error: ${state.error}'));
          }
          return Container();
        },
      ),
    );
  }
}
