import 'package:flutter/material.dart';

class SignUpEmailPage extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  SignUpEmailPage({required this.emailController, required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(labelText: 'Email'),
        ),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
      ],
    );
  }
}
