import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
class SignUpAddressPage extends StatefulWidget {
  final TextEditingController cityController;
  final TextEditingController streetController;
  final TextEditingController apartmentController;

  SignUpAddressPage({
    required this.cityController,
    required this.streetController,
    required this.apartmentController,
  });

  @override
  State<SignUpAddressPage> createState() => _SignUpAddressPageState();
}

class _SignUpAddressPageState extends State<SignUpAddressPage> {
  Position? _currentPosition;

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: widget.cityController,
          decoration: InputDecoration(labelText: 'City'),
        ),
        TextField(
          controller: widget.streetController,
          decoration: InputDecoration(labelText: 'Street'),
        ),
        TextField(
          controller: widget.apartmentController,
          decoration: InputDecoration(labelText: 'Apartment'),
        ),
        SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: _getCurrentLocation,
          child: Text('Get Current Location'),
        ),
        if (_currentPosition != null)
          Text('Location: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}'),
      ],
    );
  }
}
