import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:market/app/theme/text_styles.dart';
import 'package:market/modules/cart/data/models/cart_item_model.dart';
import 'package:market/modules/cart/logic/bloc/order_bloc.dart';
import 'package:market/modules/products/data/models/product.dart';
import 'package:market/modules/products/presentation/widgets/image_grid.dart';
import 'package:market/modules/products/presentation/widgets/quantity_manager.dart';
import 'package:market/shared/widgets/drawer.dart';


class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late QuantityManager _quantityManager;

  @override
  void initState() {
    super.initState();
    _quantityManager = QuantityManager(widget.product);
    _loadQuantity();
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
      quantity: _quantityManager.quantity, // Use the updated quantity
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            widget.product.name,
            style: AppTextStyles.textTheme.headlineMedium,
          ),
        ),
        backgroundColor: HexColor('f1efde'),
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 7.0),
              ImageGrid(
                  imageUrls: widget.product.productImage, initialIndex: 0),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Distribute space evenly
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/R.png',
                    width: MediaQuery.sizeOf(context).width * 0.33,
                  ),
                  Center(
                    child: Text(
                      widget.product.name,
                      style: AppTextStyles.textTheme.headlineMedium,
                    ),
                  ),
                  Image.asset(
                    'assets/images/L.png',
                    width: MediaQuery.sizeOf(context).width * 0.33,
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Center(
                child: Text(
                  widget.product.availability ? 'In Stock' : 'Out of Stock',
                  style: TextStyle(
                    color:
                        widget.product.availability ? Colors.green : Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Material: ${widget.product.category}',
                style: AppTextStyles.textTheme.labelLarge,
              ),
              const SizedBox(height: 8.0),
              Text(
                'Dimension: ${widget.product.dimension}',
                style: AppTextStyles.textTheme.labelLarge,
              ),
              const SizedBox(height: 8.0),
              const SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          return Visibility(
            visible:
                _quantityManager.quantity > 0 && widget.product.availability,
            child: BottomAppBar(
              color: const Color.fromARGB(134, 255, 228, 245),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Price: EGP ${widget.product.price}',
                      style: AppTextStyles.textTheme.bodyLarge,
                    ),
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
                            color: HexColor('f1efde'),
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
            ),
          );
        },
      ),
    );
  }
}
