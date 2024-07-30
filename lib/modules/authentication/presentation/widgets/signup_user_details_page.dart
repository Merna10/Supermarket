import 'package:flutter/material.dart';

class SignUpUserDetailsPage extends StatelessWidget {
  final TextEditingController userNameController;
  final TextEditingController phoneNumberController;

  SignUpUserDetailsPage({required this.userNameController, required this.phoneNumberController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: userNameController,
          decoration: InputDecoration(labelText: 'Username'),
        ),
        TextField(
          controller: phoneNumberController,
          decoration: InputDecoration(labelText: 'Phone Number'),
        ),
      ],
    );
  }
}
