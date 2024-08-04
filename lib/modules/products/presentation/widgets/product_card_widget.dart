import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:market/modules/cart/data/models/cart_item_model.dart';
import 'package:market/modules/cart/logic/bloc/order_bloc.dart';
import 'package:hive/hive.dart';
import 'package:market/modules/products/data/models/product.dart';
import 'package:market/modules/products/presentation/screens/product_details_screen.dart';
import 'package:market/modules/products/presentation/widgets/image_grid.dart';
import 'package:market/modules/products/presentation/widgets/image_viewer.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
    
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
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;

    if (isLoggedIn) {
      // Fetch quantity from Firestore
      await _loadQuantityFromFirestore();
    } else {
      // Fetch quantity from Hive
      await _loadQuantityFromHive();
    }
  }

  Future<void> _loadQuantityFromFirestore() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        throw Exception('User not logged in');
      }

      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(widget.product.id)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        final quantity = data?['quantity'] ?? 0;

        setState(() {
          this.quantity = quantity;
        });
      } else {
        setState(() {
          this.quantity = 0;
        });
      }
    } catch (e) {
      print('Error loading quantity from Firestore: $e');
    }
  }

  Future<void> _loadQuantityFromHive() async {
    try {
      var box = await Hive.openBox<OrderItem>('order');
      final existingItem = box.values.firstWhere(
        (item) => item.productId == widget.product.id,
        orElse: () => OrderItem(
          productId: widget.product.id,
          productName: widget.product.name,
          quantity: 0,
          price: widget.product.price,
          productImage:
              widget.product.productImage.isNotEmpty ? widget.product.productImage.first : '',
        ),
      );

      setState(() {
        quantity = existingItem.quantity;
      });
    } catch (e) {
      // Handle errors
      print('Error loading quantity from Hive: $e');
    }
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
     productId: widget.product.id,
          productName: widget.product.name,
          quantity: 0,
          price: widget.product.price,
          productImage:
              widget.product.productImage.isNotEmpty ? widget.product.productImage.first : '',
    );
    BlocProvider.of<OrderBloc>(context).add(AddOrderItem(orderItem: orderItem));
    BlocProvider.of<OrderBloc>(context).add(UpdateOrderItemQuantity(
      orderItem: orderItem,
      quantity: quantity,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
       onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailsScreen(product:widget.product ),
                      ),
                    );
                  },
      child: Card(
        color: Colors.white,
        elevation: 0,
        
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
                          imageUrls: widget.product.productImage,
                          initialIndex: _currentImageIndex,
                        ),
                      ),
                    );
                  },
                  child: SizedBox(
                    height: 300,
                    child: PageView.builder(
                      itemCount: widget.product.productImage.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentImageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return ImageGrid(
                          imageUrls: widget.product.productImage,
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
                    widget.product.name,
                    style: GoogleFonts.playfairDisplay(
                      textStyle: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.product.price.toStringAsFixed(2)} LE',
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (!widget.product.availability)
                    Center(
                      child: Text(
                        'Out of Stock',
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: Color.fromARGB(255, 211, 17, 17),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  if (quantity == 0 && widget.product.availability)
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
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (quantity != 0 && widget.product.availability)
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
                            onPressed: _incrementQuantity,
                            icon: const Icon(Icons.add),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
