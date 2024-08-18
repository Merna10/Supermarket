import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:market/app/theme/colors.dart';
import 'package:market/app/theme/text_styles.dart';
import 'package:market/modules/order_history/logic/bloc/history_bloc.dart';
import 'package:market/shared/models/order_list.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderList order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final List<String> _statuses = [
    'Placed',
    'Processing',
    'Shipping',
    'Completed',
    'Returned',
  ];

  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.order.status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text('Order Details',
            style: GoogleFonts.playfairDisplay(color: HexColor('#304B7D'))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<HistoryBloc, HistoryState>(
          listener: (context, state) {
            if (state is StatusUpdateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Order status updated successfully!')),
              );
            } else if (state is HistoryErrors) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.error}')),
              );
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order ID: ${widget.order.id}',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                Center(
                  child: Text(
                    'Order By: ${widget.order.userName}',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Text(
                      'Status:',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    DropdownButton<String>(
                      value: _selectedStatus,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedStatus = newValue!;
                        });
                        BlocProvider.of<HistoryBloc>(context).add(
                          UpdateOrderStatus(
                            orderId: widget.order.id,
                            newStatus: _selectedStatus,
                          ),
                        );
                      },
                      items: _statuses
                          .map<DropdownMenuItem<String>>((String status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text('Delivery Address: ${widget.order.deliveryAddress}',
                    style: AppTextStyles.textTheme.bodyMedium),
                const SizedBox(height: 8.0),
                Text(
                  'Phone: ${widget.order.phoneNumber}',
                  style: AppTextStyles.textTheme.bodyMedium,
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Delivery Fee: EGP ${widget.order.deliveryFee.toStringAsFixed(2)}',
                  style: AppTextStyles.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Items:',
                  style: AppTextStyles.textTheme.displaySmall,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.order.items.length,
                    itemBuilder: (context, index) {
                      final item = widget.order.items[index];
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
                Text('Total: EGP ${widget.order.total.toStringAsFixed(2)}',
                    style: AppTextStyles.textTheme.headlineSmall),
              ],
            );
          },
        ),
      ),
    );
  }
}
