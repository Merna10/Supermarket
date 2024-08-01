import 'package:flutter/material.dart';

class SignUpEmailPage extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const SignUpEmailPage({super.key, required this.emailController, required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: emailController,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        TextField(
          controller: passwordController,
          decoration: const InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
      ],
    );
  }
}
