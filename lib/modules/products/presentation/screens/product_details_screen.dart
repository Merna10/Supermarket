import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:market/app/theme/text_styles.dart';
import 'package:market/modules/products/data/models/product.dart';
import 'package:market/modules/products/presentation/widgets/image_grid.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            product.name,
            style: AppTextStyles.textTheme.headlineMedium,
          ),
        ),
        backgroundColor: HexColor('f1efde'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 7.0),
            ImageGrid(imageUrls: product.productImage, initialIndex: 0),
            const SizedBox(height: 16.0),
            Text(
              product.name,
              style: AppTextStyles.textTheme.headlineMedium,
            ),
            const SizedBox(height: 8.0),
            Text(
              '\$${product.price}',
            ),
            const SizedBox(height: 8.0),
            Text(
              'Availability: ${product.availability ? 'In stock' : 'Out of stock'}',
            ),
          ],
        ),
      ),
    );
  }
}
