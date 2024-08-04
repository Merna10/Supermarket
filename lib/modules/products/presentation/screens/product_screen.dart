import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:market/app/theme/text_styles.dart';
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
    final userId = user?.uid;

    context
        .read<ProductBloc>()
        .add(FetchProductsByCategory(category: categoryId));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            '$categoryName Products',
            style: AppTextStyles.textTheme.headlineMedium,
          ),
        ),
        backgroundColor: HexColor('f1efde'),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductInitial || state is ProductLoading) {
            return Center(
                child: CircularProgressIndicator(
              color: HexColor('f1efde'),
            ));
          } else if (state is ProductLoaded) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, childAspectRatio: 0.7,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 5.0,
              ),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                Product product = state.products[index];
                return ProductCard(
                  product: product,
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
