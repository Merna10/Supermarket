import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryId;

  const CategoryScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    // Use the categoryId to fetch and display category details
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Details'),
      ),
      body: Center(
        child: Text('Display details for category $categoryId'),
      ),
    );
  }
}
