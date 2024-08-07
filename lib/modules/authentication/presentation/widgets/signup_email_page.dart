import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class SignUpEmailPage extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const SignUpEmailPage(
      {super.key,
      required this.emailController,
      required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: HexColor('f1efde'), width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
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
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
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
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
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
