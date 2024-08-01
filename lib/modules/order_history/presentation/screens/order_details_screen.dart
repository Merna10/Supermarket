import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market/app/theme/text_styles.dart';
import 'package:market/shared/models/order_list.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderList order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details', style: GoogleFonts.playfairDisplay()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: ${order.id}',
              style: GoogleFonts.playfairDisplay(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Status: ${order.status}',
              style: GoogleFonts.playfairDisplay(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8.0),
            Text('Delivery Address: ${order.deliveryAddress}',
                style: AppTextStyles.textTheme.bodyMedium),
            const SizedBox(height: 8.0),
            Text(
              'Delivery Fee: EGP ${order.deliveryFee.toStringAsFixed(2)}',
              style: AppTextStyles.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Items:',
              style: AppTextStyles.textTheme.displaySmall,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: order.items.length,
                itemBuilder: (context, index) {
                  final item = order.items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      leading: Image.network(
                        item.productImage,
                        fit: BoxFit.fill,
                        width: MediaQuery.sizeOf(context).width * 0.15,
                      ),
                      title: Text(
                        item.productName,
                        style: AppTextStyles.textTheme.displaySmall,
                      ),
                      subtitle: Text(
                          '${item.quantity} x EGP ${item.price.toStringAsFixed(2)}'),
                      trailing: Text(
                          'EGP ${(item.quantity * item.price).toStringAsFixed(2)}'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8.0),
            Text('Total: EGP ${order.total.toStringAsFixed(2)}',
                style: AppTextStyles.textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}
