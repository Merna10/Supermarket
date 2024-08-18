import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/app/theme/colors.dart';
import 'package:market/app/theme/text_styles.dart';
import 'package:market/core/enum/fetch_method.dart';
import 'package:market/modules/products/data/models/product.dart';
import 'package:market/modules/products/logic/bloc/product_bloc.dart';
import 'package:market/modules/products/presentation/screens/add_products.dart';
import 'package:market/modules/products/presentation/widgets/product_card_widget.dart';
import 'package:market/shared/widgets/drawer.dart';

class ProductScreen extends StatefulWidget {
  final String id;
  final FetchMethod fetchMethod;

  const ProductScreen({
    super.key,
    required this.id,
    required this.fetchMethod,
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool _showTrue = false;
  bool _showFalse = false;
  static const String placeholderImage =
      'assets/images/Beige Minimalist Stay Tuned Coming Soon Instagram Post (1).png';

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
  void initState() {
    super.initState();
    if (widget.fetchMethod == FetchMethod.byCategory) {
      context
          .read<ProductBloc>()
          .add(FetchProductsByCategory(category: widget.id));
    } else if (widget.fetchMethod == FetchMethod.byCollection) {
      context
          .read<ProductBloc>()
          .add(FetchProductsByCollection(collection: widget.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: FutureBuilder<String>(
          future: widget.fetchMethod == FetchMethod.byCategory
              ? _getCategoryNameById(widget.id)
              : _getCollectionNameById(widget.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child:
                      CircularProgressIndicator(color: AppColors.primaryColor));
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
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  MediaQuery.of(context).size.width - 100,
                  kToolbarHeight,
                  0.0,
                  0.0,
                ),
                items: [
                  PopupMenuItem(
                    value: 'Low to High',
                    child: Text(
                      'Price: Low to High',
                      style: AppTextStyles.textTheme.labelMedium,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'High to Low',
                    child: Text(
                      'Price: High to Low',
                      style: AppTextStyles.textTheme.labelMedium,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'A to Z',
                    child: Text(
                      'Name: A to Z',
                      style: AppTextStyles.textTheme.labelMedium,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'Z to A',
                    child: Text(
                      'Name: Z to A',
                      style: AppTextStyles.textTheme.labelMedium,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'Status True',
                    child: Text(
                      'Only Show In of Stock ',
                      style: AppTextStyles.textTheme.labelMedium,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'Status False',
                    child: Text(
                      'Only Show Out of Stock ',
                      style: AppTextStyles.textTheme.labelMedium,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'clear',
                    child: Text(
                      'Remove all Filters ',
                      style: AppTextStyles.textTheme.labelMedium,
                    ),
                  ),
                ],
              ).then((value) {
                if (value != null) {
                  // Clear previous filter
                  context.read<ProductBloc>().add(ClearFilters());
                  bool ascending;

                  if (value == 'Low to High' || value == 'High to Low') {
                    ascending = value == 'Low to High';
                    context
                        .read<ProductBloc>()
                        .add(SortProductsByPrice(ascending: ascending));
                  } else if (value == 'A to Z' || value == 'Z to A') {
                    ascending = value == 'A to Z';
                    context
                        .read<ProductBloc>()
                        .add(SortProductsAlphabetically(ascending: ascending));
                  } else if (value == 'Status True') {
                    if (!_showTrue) {
                      _showTrue = true;
                      _showFalse = false;
                      context.read<ProductBloc>().add(SortProductsByStatus(
                            ascending: true,
                            showTrue: _showTrue,
                            showFalse: _showFalse,
                          ));
                    }
                  } else if (value == 'Status False') {
                    if (!_showFalse) {
                      _showTrue = false;
                      _showFalse = true;
                      context.read<ProductBloc>().add(SortProductsByStatus(
                            ascending: true,
                            showTrue: _showTrue,
                            showFalse: _showFalse,
                          ));
                    }
                  } else if (value == 'clear') {
                    context.read<ProductBloc>().add(ClearFilters());
                    if (widget.fetchMethod == FetchMethod.byCategory) {
                      context
                          .read<ProductBloc>()
                          .add(FetchProductsByCategory(category: widget.id));
                    } else if (widget.fetchMethod == FetchMethod.byCollection) {
                      context.read<ProductBloc>().add(
                          FetchProductsByCollection(collection: widget.id));
                    }
                  }
                }
              });
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductInitial || state is ProductLoading) {
            return Center(
                child:
                    CircularProgressIndicator(color: AppColors.primaryColor));
          } else if (state is ProductLoaded) {
            if (state.products.isEmpty) {
              return Image.asset(
                placeholderImage,
                fit: BoxFit.cover,
                height: MediaQuery.sizeOf(context).height,
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
                  fetchMethod: widget.fetchMethod,
                  product: product,
                  fetchid: widget.id,
                );
              },
            );
          } else if (state is ProductError) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return const Center(child: Text('Unexpected state'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddProductScreen(
                    fetchId: widget.id,
                    fetchMethod: widget.fetchMethod,
                  ),
                ),
              );
        },
        backgroundColor: AppColors.accentColor,
        foregroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
