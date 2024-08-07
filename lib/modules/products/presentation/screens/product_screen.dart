import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:market/app/theme/text_styles.dart';
import 'package:market/modules/products/data/models/product.dart';
import 'package:market/modules/products/logic/bloc/product_bloc.dart';
import 'package:market/modules/products/presentation/widgets/product_card_widget.dart';
import 'package:market/shared/widgets/drawer.dart';

enum FetchMethod { byCategory, byCollection }

class ProductScreen extends StatelessWidget {
  final String id;
  final FetchMethod fetchMethod;

  const ProductScreen({
    super.key,
    required this.id,
    required this.fetchMethod,
  });

  Future<String> _getCategoryNameById(String id) async {
    final docRef = FirebaseFirestore.instance.collection('categories').doc(id);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      return data?['name'] ?? 'Unknown Category';
    } else {
      throw Exception('Category not found');
    }
  }

  Future<String> _getCollectionNameById(String id) async {
    final docRef = FirebaseFirestore.instance.collection('collections').doc(id);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      return data?['name'] ?? 'Unknown Collection';
    } else {
      throw Exception('Collection not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (fetchMethod == FetchMethod.byCategory) {
      context.read<ProductBloc>().add(FetchProductsByCategory(category: id));
    } else if (fetchMethod == FetchMethod.byCollection) {
      context
          .read<ProductBloc>()
          .add(FetchProductsByCollection(collection: id));
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: FutureBuilder<String>(
          future: fetchMethod == FetchMethod.byCategory
              ? _getCategoryNameById(id)
              : _getCollectionNameById(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: HexColor('f1efde'),
              ));
            } else if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData) {
              return Text(
                '${snapshot.data} Products',
                style: AppTextStyles.textTheme.headlineMedium,
              );
            } else {
              return const Text('Products');
            }
          },
        ),
        backgroundColor: HexColor('f1efde'),
      ),
      drawer: const CustomDrawer(),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductInitial || state is ProductLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: HexColor('f1efde'),
              ),
            );
          } else if (state is ProductLoaded) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 0.7,
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
