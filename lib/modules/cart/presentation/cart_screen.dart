// lib/screens/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/modules/cart/logic/bloc/order_bloc.dart';

class CartScreen extends StatelessWidget {
  final String userId;

  const CartScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is OrderInProgress) {
            return ListView.builder(
              itemCount: state.order.items.length,
              itemBuilder: (context, index) {
                final item = state.order.items[index];
                return ListTile(
                  title: Text(item.productName),
                  subtitle: Text(
                      '${item.quantity} x \$${item.price.toStringAsFixed(2)}'),
                  trailing: Text(
                      '\$${(item.quantity * item.price).toStringAsFixed(2)}'),
                );
              },
            );
          } else if (state is OrderLoaded) {
            return ListView.builder(
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return ListTile(
                  title: Text('Order ${order.id}'),
                  subtitle: Text('Total: \$${order.total.toStringAsFixed(2)}'),
                );
              },
            );
          } else if (state is OrderError) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return Center(child: Text('No orders'));
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            double totalPrice = 0.0;
            if (state is OrderInProgress) {
              for (var item in state.order.items) {
                totalPrice += item.quantity * item.price;
              }
            }
            return Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<OrderBloc>(context)
                          .add(SubmitOrder(userId: userId));
                    },
                    child: Text('Submit Order'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
