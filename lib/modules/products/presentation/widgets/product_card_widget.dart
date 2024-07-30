import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:market/app/theme/text_styles.dart';
import 'package:market/modules/cart/data/models/cart_item_model.dart';
import 'package:market/modules/cart/logic/bloc/order_bloc.dart';
import 'package:hive/hive.dart';
import 'package:market/modules/products/presentation/widgets/image_grid.dart';
import 'package:market/modules/products/presentation/widgets/image_viewer.dart';

class ProductCard extends StatefulWidget {
  final String productId;
  final String productName;
  final List<String> productImage;
  final double price;
  final String userId;
  final bool productStatus;

  const ProductCard({
    super.key,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.userId,
    required this.productStatus,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int quantity = 0;
  int _currentImageIndex = 0;
  @override
  void initState() {
    super.initState();
    _loadQuantity();
  }

  Future<void> _loadQuantity() async {
    var box = await Hive.openBox<OrderItem>('cart');
    final existingItem = box.values.firstWhere(
      (item) => item.productId == widget.productId,
      orElse: () => OrderItem(
        productId: widget.productId,
        productName: widget.productName,
        quantity: 0,
        price: widget.price,
      ),
    );

    setState(() {
      quantity = existingItem.quantity;
    });
  }

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
    _updateCart();
  }

  void _decrementQuantity() {
    if (quantity > 0) {
      setState(() {
        quantity--;
      });
      _updateCart();
    }
  }

  void _updateCart() {
    final orderItem = OrderItem(
      productId: widget.productId,
      productName: widget.productName,
      quantity: quantity,
      price: widget.price,
    );
    BlocProvider.of<OrderBloc>(context).add(AddOrderItem(orderItem: orderItem));

    BlocProvider.of<OrderBloc>(context).add(UpdateOrderItemQuantity(
      orderItem: orderItem,
      quantity: quantity,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageViewer(
                        imageUrls: widget.productImage,
                        initialIndex: _currentImageIndex,
                      ),
                    ),
                  );
                },
                child: SizedBox(
                  height: 300,
                  child: PageView.builder(
                    itemCount: widget.productImage.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return ImageGrid(
                        imageUrls: widget.productImage,
                        initialIndex: index,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.productName,
                  style: GoogleFonts.playfairDisplay(
                    textStyle: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.price.toStringAsFixed(2)}LE',
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                  ),
                ),
                const SizedBox(height: 8),
                if (!widget.productStatus)
                  Center(
                    child: Text(
                      'Out Stock',
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: Color.fromARGB(255, 211, 17, 17)),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                if (quantity == 0 && widget.productStatus)
                  Center(
                    child: TextButton(
                      onPressed: _incrementQuantity,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: HexColor('f1efde'),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: Text(
                        'Add to Cart',
                        style: GoogleFonts.playfairDisplay(
                          textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                if (quantity != 0 && widget.productStatus)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        '$quantity',
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: HexColor('f1efde'),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: _incrementQuantity,
                          icon: const Icon(Icons.add),
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
