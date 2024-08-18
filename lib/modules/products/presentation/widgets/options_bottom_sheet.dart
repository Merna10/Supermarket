import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market/core/enum/fetch_method.dart';
import 'package:market/modules/products/data/models/product.dart';

import '../../logic/bloc/product_bloc.dart';

class OptionsBottomSheet extends StatelessWidget {
  final Product product;
  final FetchMethod fetchMethod;
  final String fetchid;
  const OptionsBottomSheet({
    super.key,
    required this.product,
    required this.fetchMethod,
    required this.fetchid,
  });

  void _showEditProductForm(BuildContext context) {
    final nameController = TextEditingController(text: product.name);
    final priceController =
        TextEditingController(text: product.price.toString());
    final dimensionController = TextEditingController(text: product.dimension);
    final categoryIDController =
        TextEditingController(text: product.categoryID);
    final collectionIDController =
        TextEditingController(text: product.collectionID);
    final quantityController =
        TextEditingController(text: product.quantity.toString());
    final availabilityController = TextEditingController(
        text: product.availability ? 'Available' : 'Unavailable');
    final isFavoriteController =
        TextEditingController(text: product.isFavorite ? 'Yes' : 'No');
    final productImageController =
        TextEditingController(text: product.productImage.join(', '));

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
                TextField(
                  controller: dimensionController,
                  decoration: const InputDecoration(labelText: 'Dimension'),
                ),
                TextField(
                  controller: categoryIDController,
                  decoration: const InputDecoration(labelText: 'Category ID'),
                ),
                TextField(
                  controller: collectionIDController,
                  decoration: const InputDecoration(labelText: 'Collection ID'),
                ),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                ),
                TextField(
                  controller: availabilityController,
                  decoration: const InputDecoration(labelText: 'Availability'),
                ),
                TextField(
                  controller: isFavoriteController,
                  decoration: const InputDecoration(labelText: 'Is Favorite'),
                ),
                TextField(
                  controller: productImageController,
                  decoration: const InputDecoration(
                      labelText: 'Product Images (comma-separated)'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final updatedProduct = product.copyWith(
                      name: nameController.text,
                      price: double.tryParse(priceController.text) ??
                          product.price,
                      dimension: dimensionController.text,
                      categoryID: categoryIDController.text,
                      collectionID: collectionIDController.text,
                      quantity: double.tryParse(quantityController.text) ??
                          product.quantity,
                      availability: availabilityController.text.toLowerCase() ==
                          'available',
                      isFavorite:
                          isFavoriteController.text.toLowerCase() == 'yes',
                      productImage:
                          productImageController.text.split(', ').toList(),
                    );

                    BlocProvider.of<ProductBloc>(context).add(UpdateProduct(
                      product: updatedProduct,
                      fetchId: fetchid,
                      method: fetchMethod,
                    ));
                    if (product.quantity == 0 || !product.availability) {
                      //  _sendNotificationToAdmin();
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Update Product'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // void _sendNotificationToAdmin() async {
  //   const adminEmail = 'zefyiciyda@gufum.com';
  //   const subject = 'Product Out of Stock/Unavailable Notification';
  //   final body = 'Product ${product.name} is out of stock or unavailable.';

  //   await ProductService().sendEmailNotification(adminEmail, subject, body);
  // }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: const Text('Are you sure you want to delete this Product?'),
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
                    .read<ProductBloc>()
                    .add(DeleteProduct(productId: product.id,fetchId: fetchid,method: fetchMethod));
                //  _sendNotificationToAdmin();
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.blue),
            title: Text('Edit', style: GoogleFonts.roboto(fontSize: 16)),
            onTap: () {
              Navigator.pop(context);
              _showEditProductForm(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: Text('Delete', style: GoogleFonts.roboto(fontSize: 16)),
            onTap: () {
              Navigator.pop(context);
              _showDeleteConfirmationDialog(context);
            },
          ),
        ],
      ),
    );
  }
}
