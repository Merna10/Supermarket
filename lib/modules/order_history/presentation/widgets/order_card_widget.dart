import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:market/app/theme/text_styles.dart';
import 'package:market/shared/models/order_list.dart';
import 'package:market/modules/order_history/presentation/screens/order_details_screen.dart';

class OrderCard extends StatelessWidget {
  final OrderList orderList;

  const OrderCard({super.key, required this.orderList});

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('yyyy-MM-dd – kk:mm').format(orderList.date);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailsScreen(order: orderList),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.all(8.0),
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID: ${orderList.id}',
                  style: AppTextStyles.textTheme.headlineSmall),
              const SizedBox(height: 8.0),
              Text(
                'Status: ${orderList.status}',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Total: EGP ${orderList.total.toStringAsFixed(2)}',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Order Date: $formattedDate',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
