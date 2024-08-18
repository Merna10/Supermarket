import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/app/theme/colors.dart';
import 'package:market/core/enum/fetch_method.dart';
import 'package:market/modules/products/data/models/product.dart';
import 'package:market/modules/products/logic/bloc/product_bloc.dart';
import 'package:market/modules/products/presentation/widgets/product_card_widget.dart';
import 'package:market/app/theme/text_styles.dart';

class FavProductScreen extends StatefulWidget {
  const FavProductScreen({super.key});

  @override
  State<FavProductScreen> createState() => _FavProductScreenState();
}

class _FavProductScreenState extends State<FavProductScreen> {
  String? userId;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    userId = user?.uid;

    if (userId != null) {
      context.read<ProductBloc>().add(FetchFavorites(userId: userId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    const FetchMethod fetchMethod = FetchMethod.byCategory;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Wishlist',
            style: AppTextStyles.textTheme.headlineMedium,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductInitial || state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            if (state.products.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/—Pngtree—vector sad emoji icon_4186900.png',
                    fit: BoxFit.cover,
                  ),
                  Text(
                    'You have no favorite products yet.',
                    style: AppTextStyles.textTheme.displaySmall,
                  ),
                ],
              );
            }
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.5,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 5.0,
              ),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                Product product = state.products[index];
                return ProductCard(
                  fetchMethod: fetchMethod,
                  product: product,
                  fetchid: product.categoryID,
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
