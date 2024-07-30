import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/modules/cart/logic/bloc/order_bloc.dart';

class CartScreen extends StatefulWidget {
  final String userId;

  const CartScreen({super.key, required this.userId});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(LoadCart());
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Cart'),
    ),
    body: BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state is OrderLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CartLoaded) {
          if (state.cartItems.items.isEmpty) {
            return const Center(child: Text('No items in cart'));
          }
          return ListView.builder(
            itemCount: state.cartItems.items.length,
            itemBuilder: (context, index) {
              final item = state.cartItems.items[index];
              return Dismissible(
                key: ValueKey(item.productId),
                onDismissed: (direction) {
                  context
                      .read<OrderBloc>()
                      .add(RemoveOrderItem(orderItem: item));
                },
                background: Container(color: Colors.red),
                child: ListTile(
                  title: Text(item.productName),
                  subtitle: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (item.quantity > 1) {
                            context.read<OrderBloc>().add(
                                UpdateOrderItemQuantity(
                                    orderItem: item,
                                    quantity: item.quantity - 1));
                          } else {
                            context
                                .read<OrderBloc>()
                                .add(RemoveOrderItem(orderItem: item));
                          }
                        },
                      ),
                      Text(
                          '${item.quantity} x \$${item.price.toStringAsFixed(2)}'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          context.read<OrderBloc>().add(
                              UpdateOrderItemQuantity(
                                  orderItem: item,
                                  quantity: item.quantity + 1));
                        },
                      ),
                    ],
                  ),
                  trailing: Text(
                      '\$${(item.quantity * item.price).toStringAsFixed(2)}'),
                ),
              );
            },
          );
        } else if (state is OrderError) {
          return Center(child: Text('Error: ${state.error}'));
        } else {
          return const Center(child: Text('No items in cart'));
        }
      },
    ),
    bottomNavigationBar: BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state is CartLoaded && state.cartItems.items.isNotEmpty) {
          final totalPrice = state.cartItems.total;
          return BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total: \$${totalPrice.toStringAsFixed(2)}'),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<OrderBloc>()
                        .add(SubmitOrder(userId: widget.userId));
                  },
                  child: const Text('Checkout'),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    ),
  );
}
}
