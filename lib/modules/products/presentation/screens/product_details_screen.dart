import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:market/app/theme/colors.dart';
import 'package:market/app/theme/text_styles.dart';
import 'package:market/core/enum/fetch_method.dart';
import 'package:market/modules/authentication/logic/bloc/auth_bloc.dart';
import 'package:market/modules/cart/data/models/cart_item_model.dart';
import 'package:market/modules/cart/logic/bloc/order_bloc.dart';
import 'package:market/modules/categories/data/repositories/category_repository.dart';
import 'package:market/modules/categories/logic/bloc/category_bloc.dart';
import 'package:market/modules/products/data/models/product.dart';
import 'package:market/modules/products/data/repositories/product_repository.dart';
import 'package:market/modules/products/presentation/widgets/fav_widget.dart';
import 'package:market/shared/widgets/image_grid.dart';
import 'package:market/modules/products/presentation/widgets/quantity_manager.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  final FetchMethod fetchMethod;

  const ProductDetailsScreen({
    super.key,
    required this.fetchMethod,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late QuantityManager _quantityManager;
  Future<Map<String, dynamic>?>? _collectionDetailsFuture;

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthCheckStatusEvent());
    _quantityManager = QuantityManager(widget.product);
    _loadQuantity();
    _collectionDetailsFuture =
        ProductRepository().getCollectionDetails(widget.product.collectionID);
  }

  Future<void> _loadQuantity() async {
    await _quantityManager.loadQuantity();
    setState(() {});
  }

  void _incrementQuantity() {
    setState(() {
      _quantityManager.incrementQuantity();
    });
    _updateCart();
  }

  void _decrementQuantity() {
    setState(() {
      _quantityManager.decrementQuantity();
    });
    _updateCart();
  }

  void _updateCart() {
    final orderItem = OrderItem(
      productId: widget.product.id,
      productName: widget.product.name,
      quantity: _quantityManager.quantity,
      price: widget.product.price,
      productImage: widget.product.productImage.isNotEmpty
          ? widget.product.productImage.first
          : '',
    );
    BlocProvider.of<OrderBloc>(context).add(UpdateOrderItemQuantity(
      orderItem: orderItem,
      quantity: _quantityManager.quantity,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, stateAuth) {
        return Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text(
                widget.product.name,
                style: AppTextStyles.textTheme.headlineMedium,
              ),
            ),
            backgroundColor: AppColors.primaryColor,
            actions: [
              FavWidget(
                product: widget.product,
                fetchMethod: widget.fetchMethod,
              ),
            ],
          ),
          body: BlocProvider(
            create: (context) => CategoryBloc(
                categoryRepository: CategoryRepository())
              ..add(FetchCategoryName(categoryId: widget.product.categoryID)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 7.0),
                    ImageGrid(
                      imageUrls: widget.product.productImage,
                      initialIndex: 0,
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Image.asset(
                            'assets/images/R.png',
                            width: MediaQuery.sizeOf(context).width * 0.33,
                          ),
                        ),
                        Center(
                          child: Text(
                            widget.product.name,
                            style: AppTextStyles.textTheme.headlineMedium,
                          ),
                        ),
                        Flexible(
                          child: Image.asset(
                            'assets/images/L.png',
                            width: MediaQuery.sizeOf(context).width * 0.33,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Center(
                      child: Text(
                        widget.product.availability
                            ? 'In Stock'
                            : 'Out of Stock',
                        style: TextStyle(
                          color: widget.product.availability
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) {
                        if (state is CategoryLoading) {
                          return const CircularProgressIndicator();
                        } else if (state is CategoryError) {
                          return Text('Error: ${state.error}');
                        } else if (state is CategoryNameLoaded) {
                          return Text(
                            'Material: ${state.categoryName}',
                            style: AppTextStyles.textTheme.labelLarge,
                          );
                        }
                        return const Text('Category information not available');
                      },
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Dimension: ${widget.product.dimension}',
                      style: AppTextStyles.textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8.0),
                    FutureBuilder<Map<String, dynamic>?>(
                      future: _collectionDetailsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return const Text(
                              'Error fetching collection details');
                        } else if (snapshot.hasData) {
                          final details = snapshot.data!;
                          return Center(
                            child: Text(
                              '${widget.product.name} ${details['description'] ?? 'No details available'}',
                              style: AppTextStyles.textTheme.labelMedium,
                            ),
                          );
                        } else {
                          return Text(
                            '${widget.product.name} offers essential, versatile scarves in classic colors and simple patterns. Designed for everyday wear, these scarves feature comfortable fabrics like cotton and wool. Their minimalist style ensures they easily complement any outfit, making them practical and stylish staples for any wardrobe.',
                            style: AppTextStyles.textTheme.labelMedium,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              return BottomAppBar(
                color: const Color.fromARGB(134, 255, 228, 245),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'EGP ${widget.product.price}',
                        style: AppTextStyles.textTheme.displaySmall,
                      ),
                      if (stateAuth is AuthAuthenticated)
                        if (stateAuth.role == 'customer')
                          if (_quantityManager.quantity >= 0 &&
                              widget.product.availability)
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: HexColor('fddfe1'),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    onPressed: _decrementQuantity,
                                    icon: const Icon(Icons.remove),
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${_quantityManager.quantity}',
                                  style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    onPressed: _quantityManager.quantity <
                                            widget.product.quantity
                                        ? _incrementQuantity
                                        : null,
                                    icon: const Icon(Icons.add),
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                      if (stateAuth is AuthUnauthenticated)
                        if (_quantityManager.quantity >= 0 &&
                            widget.product.availability)
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: HexColor('fddfe1'),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: _decrementQuantity,
                                  icon: const Icon(Icons.remove),
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${_quantityManager.quantity}',
                                style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: _quantityManager.quantity <
                                          widget.product.quantity
                                      ? _incrementQuantity
                                      : null,
                                  icon: const Icon(Icons.add),
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
