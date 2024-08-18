import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:market/app/theme/colors.dart';
import 'package:market/app/theme/text_styles.dart';
import 'package:market/core/services/location_service.dart';
import 'package:market/core/utils/delivery_fee_util.dart';
import 'package:market/modules/cart/data/repositories/cart_repository.dart';
import 'package:market/modules/cart/logic/bloc/order_bloc.dart';
import 'package:market/shared/widgets/drawer.dart';

const double storeLat = 30.020760;
const double storeLon = 31.395011;

class SubmitOrderScreen extends StatefulWidget {
  final double price;
  const SubmitOrderScreen({super.key, required this.price});

  @override
  State<SubmitOrderScreen> createState() => _SubmitOrderScreenState();
}

class _SubmitOrderScreenState extends State<SubmitOrderScreen> {
  String _deliveryAddress = '';
  double _deliveryFee = 0.0;
  String _userName = '';
  String _phoneNumber = '';
  LatLng? _deliveryLatLng;
  late GoogleMapController _mapController;

  final LocationService _locationService = LocationService();
  final OrderRepository _orderRepository = OrderRepository();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchLocationAndCalculateFee();
    _fetchUserInfo();
    context.read<OrderBloc>().add(LoadCart());
  }

  Future<void> _fetchUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    try {
      String userName = await _orderRepository.getUserName(userId.toString());
      String phoneNumber =
          await _orderRepository.getUserPhoneNumber(userId.toString());

      setState(() {
        _userName = userName;
        _phoneNumber = phoneNumber;
      });
    } catch (e) {
      setState(() {
        _userName = 'Failed to get UserName';
        _phoneNumber = 'Failed to get PhoneNumber';
      });
    }
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
        _deliveryLatLng = LatLng(position.latitude, position.longitude);
      });

      _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(_deliveryLatLng!, 14),
      );
    } catch (e) {
      setState(() {
        _deliveryAddress = 'Failed to get location';
        _deliveryFee = 0.0;
      });
    }
  }

  Future<void> _selectNewAddress() async {
    final TextEditingController buildingNumberController =
        TextEditingController();
    final TextEditingController streetNameController = TextEditingController();
    final TextEditingController districtController = TextEditingController();
    final TextEditingController cityController = TextEditingController();
    final TextEditingController apartmentController = TextEditingController();
    final TextEditingController countryController = TextEditingController();

    final String? fullAddress = await showDialog<String>(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Enter New Address'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: buildingNumberController,
                  decoration: const InputDecoration(
                    hintText: '123',
                    labelText: 'Building Number',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: streetNameController,
                  decoration: const InputDecoration(
                    hintText: 'Amphitheatre Parkway',
                    labelText: 'Street Name',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: districtController,
                  decoration: const InputDecoration(
                    hintText: 'North District',
                    labelText: 'District',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: cityController,
                  decoration: const InputDecoration(
                    hintText: 'Mountain View',
                    labelText: 'City',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: apartmentController,
                  decoration: const InputDecoration(
                    hintText: 'Building 43',
                    labelText: 'Apartment Number',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: countryController,
                  decoration: const InputDecoration(
                    hintText: 'Egypt',
                    labelText: 'Country',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final address =
                      '${buildingNumberController.text}, ${streetNameController.text}, ${districtController.text}, ${cityController.text}, ${apartmentController.text}, ${countryController.text}';
                  Navigator.pop(context, address);
                  print(address);
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
    );

    if (fullAddress != null && fullAddress.isNotEmpty) {
      try {
        Position position =
            await _locationService.getCoordinatesFromAddress(fullAddress);
        double distance = calculateDistance(
            position.latitude, position.longitude, storeLat, storeLon);
        double deliveryFee = calculateDeliveryFee(distance);

        setState(() {
          _deliveryAddress = fullAddress;
          _deliveryFee = deliveryFee;
          _deliveryLatLng = LatLng(position.latitude, position.longitude);
        });

        _mapController.animateCamera(
          CameraUpdate.newLatLngZoom(_deliveryLatLng!, 14),
        );
      } catch (e) {
        setState(() {
          _deliveryAddress = 'Failed to get location from address';
          _deliveryFee = 0.0;
        });
      }
    }
  }

  Future<void> _updateUserName() async {
    _nameController.clear();

    final userName = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Enter Your Name'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: 'Name'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, _nameController.text);
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );

    if (userName != null && userName.isNotEmpty) {
      setState(() {
        _userName = userName;
      });
    }
  }

  Future<void> _updatePhoneNumber() async {
    _phoneController.clear();

    final phoneNumber = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Enter Your Phone Number'),
          content: TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(hintText: 'Phone Number'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, _phoneController.text);
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );

    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      setState(() {
        _phoneNumber = phoneNumber;
      });
    }
  }

  Future<void> _handleCheckout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      bool isAvailable =
          await _locationService.isDeliveryAvailable(_deliveryAddress);

      if (!isAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sorry, we don\'t deliver there.'),
          ),
        );
        return;
      }
      context.read<OrderBloc>().add(SubmitOrder(
            userId: user.uid,
            deliveryAddress: _deliveryAddress,
            deliveryFees: _deliveryFee,
            userName: _userName,
            phoneNumber: _phoneNumber,
          ));
    }
    Navigator.pushNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Submit Order',
            style: AppTextStyles.textTheme.headlineMedium,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: GestureDetector(
                  onTap: _updateUserName,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'User Name: ',
                            style: AppTextStyles.textTheme.displaySmall,
                          ),
                          TextButton(
                            onPressed: () async {
                              await _updateUserName();
                            },
                            child: Text(
                              'Change',
                              style: TextStyle(color: HexColor('dad5a8')),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        _userName,
                        style: AppTextStyles.textTheme.displaySmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _updatePhoneNumber,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Phone Number:',
                            style: AppTextStyles.textTheme.displaySmall,
                          ),
                          TextButton(
                            onPressed: () async {
                              await _updatePhoneNumber();
                            },
                            child: Text(
                              'Change',
                              style: TextStyle(color: HexColor('dad5a8')),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        ' $_phoneNumber',
                        style: AppTextStyles.textTheme.displaySmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _selectNewAddress,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Delivery Address',
                            style: AppTextStyles.textTheme.displaySmall,
                          ),
                          TextButton(
                            onPressed: () async {
                              await _selectNewAddress();
                            },
                            child: Text(
                              'Change',
                              style: TextStyle(color: HexColor('dad5a8')),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        _deliveryAddress.isNotEmpty
                            ? _deliveryAddress
                            : 'Select Address',
                        style: AppTextStyles.textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: _deliveryLatLng ?? const LatLng(storeLat, storeLon),
                    zoom: 24,
                  ),
                  markers: _deliveryLatLng != null
                      ? {
                          Marker(
                            markerId: const MarkerId('deliveryLocation'),
                            position: _deliveryLatLng!,
                            infoWindow: const InfoWindow(
                              title: 'Delivery Location',
                            ),
                          ),
                          const Marker(
                            markerId: MarkerId('storeLocation'),
                            position: LatLng(storeLat, storeLon),
                            infoWindow: InfoWindow(
                              title: 'Store Location',
                            ),
                          ),
                        }
                      : {},
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: MediaQuery.sizeOf(context).height * 0.11,
        color: AppColors.primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              ' EGP ${(widget.price + _deliveryFee).toStringAsFixed(2)}',
              style: AppTextStyles.textTheme.bodyLarge,
            ),
            Column(
              children: [
                TextButton(
                  onPressed: _handleCheckout,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(137, 182, 172, 172),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    'Submit',
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
      ),
    );
  }
}
