import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/modules/products/data/models/product.dart';
import 'package:market/modules/products/data/repositories/product_repository.dart';
import 'package:market/modules/products/presentation/cubit/product_details_cubit.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String productId;

  const ProductDetailsScreen({Key? key, required this.productId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productDetailsCubit = context.read<ProductDetailsCubit>();
    productDetailsCubit.fetchProductDetails(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: BlocBuilder<ProductDetailsCubit, Product?>(
        builder: (context, product) {
          if (product == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            return buildProductDetails(product);
          }
        },
      ),
    );
  }

  Widget buildProductDetails(Product product) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(product.imageUrl),
          SizedBox(height: 16),
          Text(product.name, style: TextStyle(fontSize: 24)),
          SizedBox(height: 8),
          Text(product.description),
          SizedBox(height: 8),
          Text('Quantity: ${product.quantity}'),
          SizedBox(height: 8),
          Text('Availability: ${product.availability}'),
        ],
      ),
    );
  }
}
