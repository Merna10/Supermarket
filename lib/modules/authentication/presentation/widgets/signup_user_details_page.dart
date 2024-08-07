import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class SignUpUserDetailsPage extends StatelessWidget {
  final TextEditingController userNameController;
  final TextEditingController phoneNumberController;

  const SignUpUserDetailsPage(
      {super.key,
      required this.userNameController,
      required this.phoneNumberController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: HexColor('f1efde'), width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: HexColor('f1efde'), width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                cursorColor: HexColor('a57666'),
                textAlign: TextAlign.center,
                controller: userNameController,
                decoration: const InputDecoration(
                  labelText: 'UserName',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: HexColor('f1efde'), width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                cursorColor: HexColor('f1efde'),
                textAlign: TextAlign.center,
                controller: phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: InputBorder.none,
                ),
                obscureText: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
