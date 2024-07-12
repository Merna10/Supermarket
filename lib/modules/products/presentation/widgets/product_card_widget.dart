// lib/widgets/product_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/modules/cart/data/models/cart_item_model.dart';
import 'package:market/modules/cart/data/models/order_list.dart';
import 'package:market/modules/cart/logic/bloc/order_bloc.dart';

class ProductCard extends StatefulWidget {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final String userId; // Add userId here

  const ProductCard({
    super.key,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.userId, // Add userId here
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int quantity = 0;

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decrementQuantity() {
    if (quantity > 0) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              child: Image.network(
                widget.productImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(widget.productName),
          Text('\$${widget.price.toStringAsFixed(2)}'),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  _decrementQuantity();
                  if (quantity > 0) {
                    final orderItem = OrderItem(
                      productId: widget.productId,
                      productName: widget.productName,
                      quantity: quantity,
                      price: widget.price,
                    );
                    BlocProvider.of<OrderBloc>(context).add(AddOrderItem(
                        orderItem: orderItem, userId: widget.userId));
                  }
                },
              ),
              Text(quantity.toString()),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _incrementQuantity();
                  if (quantity > 0) {
                    final orderItem = OrderItem(
                      productId: widget.productId,
                      productName: widget.productName,
                      quantity: quantity,
                      price: widget.price,
                    );
                    BlocProvider.of<OrderBloc>(context).add(AddOrderItem(
                        orderItem: orderItem, userId: widget.userId));
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
