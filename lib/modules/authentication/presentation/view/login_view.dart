import 'package:flutter/material.dart';
import 'package:market/modules/authentication/data/repositories/authentication_repository.dart';
import 'package:market/modules/authentication/presentation/view/register_view.dart';
import 'package:market/modules/authentication/presentation/view_models/login_view_model.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthenticationRepository authRepository = AuthenticationRepository();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(authRepository, context),
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Center(
          child: Consumer<LoginViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    onChanged: (value) => viewModel.setEmail(value),
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    onChanged: (value) => viewModel.setPassword(value),
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  ElevatedButton(
                    onPressed: () => viewModel.login(),
                    child: const Text('Login'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: const Text('Create a new Email'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
