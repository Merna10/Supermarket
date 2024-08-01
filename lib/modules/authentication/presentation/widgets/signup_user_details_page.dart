import 'package:flutter/material.dart';

class SignUpUserDetailsPage extends StatelessWidget {
  final TextEditingController userNameController;
  final TextEditingController phoneNumberController;

  const SignUpUserDetailsPage({super.key, required this.userNameController, required this.phoneNumberController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: userNameController,
          decoration: const InputDecoration(labelText: 'Username'),
        ),
        TextField(
          controller: phoneNumberController,
          decoration: const InputDecoration(labelText: 'Phone Number'),
        ),
      ],
    );
  }
}
