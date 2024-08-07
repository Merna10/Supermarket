import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:market/app/theme/text_styles.dart';
import 'package:market/core/services/location_service.dart';
import 'package:market/core/utils/delivery_fee_util.dart';
import 'package:market/modules/cart/logic/bloc/order_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:market/shared/widgets/drawer.dart';

const double storeLat = 30.020760;
const double storeLon = 31.395011;

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String _deliveryAddress = '';
  double _deliveryFee = 0.0;

  final LocationService _locationService = LocationService();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchLocationAndCalculateFee();
    context.read<OrderBloc>().add(LoadCart());
  }

  Future<void> _fetchLocationAndCalculateFee() async {
    try {
      Position position = await _locationService.getCurrentPosition();
      String address = await _locationService.getAddressFromLatLng(position);
      double distance = calculateDistance(
          position.latitude, position.longitude, storeLat, storeLon);
      double deliveryFee = calculateDeliveryFee(distance);

      setState(() {
        _deliveryAddress = address;
        _deliveryFee = deliveryFee;
      });
    } catch (e) {
      setState(() {
        _deliveryAddress = 'Failed to get location';
        _deliveryFee = 0.0;
      });
    }
  }

  Future<void> _selectNewAddress() async {
    final address = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter New Address'),
          content: TextField(
            controller: _addressController,
            decoration: const InputDecoration(hintText: 'Address'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, _addressController.text),
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );

    if (address != null && address.isNotEmpty) {
      try {
        Position position =
            await _locationService.getCoordinatesFromAddress(address);
        double distance = calculateDistance(
            position.latitude, position.longitude, storeLat, storeLon);
        double deliveryFee = calculateDeliveryFee(distance);

        setState(() {
          _deliveryAddress = address;
          _deliveryFee = deliveryFee;
        });
      } catch (e) {
        setState(() {
          _deliveryAddress = 'Failed to get location from address';
          _deliveryFee = 0.0;
        });
      }
    }
  }

  Future<void> _handleCheckout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushNamed(context, '/');
    } else {
      context.read<OrderBloc>().add(SubmitOrder(
            userId: user.uid,
            deliveryAddress: _deliveryAddress,
            deliveryFees: _deliveryFee,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Cart',
            style: AppTextStyles.textTheme.headlineMedium,
          ),
        ),
        backgroundColor: HexColor('f1efde'),
      ),
      drawer: const CustomDrawer(),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return Center(
                child: CircularProgressIndicator(color: HexColor('f1efde')));
          } else if (state is CartLoaded) {
            if (state.cartItems.items.isEmpty &&
                state.outOfStockItems.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/—Pngtree—vector sad emoji icon_4186900.png',
                    fit: BoxFit.cover,
                  ),
                  Text(
                    'Cart is Empty',
                    style: AppTextStyles.textTheme.displaySmall,
                  ),
                ],
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
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
                          onTap: () {},
                          leading: Image.network(
                            item.productImage,
                            fit: BoxFit.fill,
                            width: MediaQuery.sizeOf(context).width * 0.15,
                          ),
                          title: Text(
                            item.productName,
                            style: AppTextStyles.textTheme.displaySmall,
                          ),
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
                                  '${item.quantity} x EGP ${item.price.toStringAsFixed(2)}'),
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
                              'EGP ${(item.quantity * item.price).toStringAsFixed(2)}'),
                        ),
                      );
                    },
                  ),
                ),
                if (state.outOfStockItems.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Out of stock items:',
                          style: AppTextStyles.textTheme.displaySmall,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        ...state.outOfStockItems.map((item) => Dismissible(
                              key: ValueKey(item.productId),
                              onDismissed: (direction) {
                                context
                                    .read<OrderBloc>()
                                    .add(RemoveOrderItem(orderItem: item));
                              },
                              background: Container(color: Colors.red),
                              child: ListTile(
                                leading: Image.network(
                                  item.productImage,
                                  fit: BoxFit.fill,
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.15,
                                ),
                                title: Text(
                                  item.productName,
                                  style: AppTextStyles.textTheme.displaySmall,
                                ),
                                subtitle: const Text(
                                  'Out of Stock',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text('To $_deliveryAddress'),
                          ),
                          TextButton(
                            onPressed: _selectNewAddress,
                            child: Text(
                              'Change',
                              style: TextStyle(color: HexColor('dad5a8')),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
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
            final totalPrice = state.cartItems.total + _deliveryFee;
            return BottomAppBar(
              height: MediaQuery.sizeOf(context).height * 0.11,
              color: HexColor('f1efde'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ' EGP ${totalPrice.toStringAsFixed(2)}',
                    style: AppTextStyles.textTheme.bodyLarge,
                  ),
                  Column(
                    children: [
                      TextButton(
                        onPressed: _handleCheckout,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              const Color.fromARGB(137, 182, 172, 172),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: Text(
                          'CheckOut',
                          style: AppTextStyles.textTheme.labelLarge,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          '+${_deliveryFee.toStringAsFixed(2)} delivery fees',
                          style: AppTextStyles.textTheme.bodyMedium,
                        ),
                      ),
                    ],
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
